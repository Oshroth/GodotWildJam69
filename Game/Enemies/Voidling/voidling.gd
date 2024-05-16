extends CharacterBody3D
class_name Enemy

var target:MageTower = null
@export var max_health:float = 10
@export var health:float = 10
@export var speed:float = 10.0
@export var attack_timer:float = 1.0
@export var attack_power:float = 2
@export var gold_worth:float = 10
@onready var navigation_agent = $NavigationAgent3D

signal on_death
var is_attacking = false

func _process(delta: float) -> void:
	var direction = target.position - position
	if direction.length() < 5:
		attack()

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished() && is_attacking:
		return
		
	var direction = target.position - position
	if direction.length() < 5:
		return
		
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	look_at(next_path_position)
	velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()

func attack() -> void:
	if is_attacking:
		return

	is_attacking = true
	await get_tree().create_timer(attack_timer, false).timeout
	target.damage(attack_power, self)
	is_attacking = false

func damage(amount:float) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	on_death.emit()
	queue_free()

func enter_world(new_target:Node3D) -> void:
	target = new_target
	look_at(target.position)
	
	await get_tree().physics_frame
	
	navigation_agent.set_target_position(new_target.global_position)
