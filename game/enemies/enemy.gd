extends CharacterBody3D
class_name Enemy

var target:Node3D = null
var temp_target:Node3D = null

@export var max_health:float = 10
@export var health:float = 10
@export var speed:float = 1.0
@export var attack_timer:float = 1.0
@export var attack_power:float = 2
@export var gold_worth:int = 10
@export var attack_distance:float = 5.0
@export var awareness:Area3D
@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
@onready var death_sound = $death_sound
@onready var animation_player = $AnimationPlayer


signal on_death
var is_attacking := false
var anims:Array[String] = ["voidling/attack","voidling/attack2"]

func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished() && is_attacking:
		return
	
	var target_direction:Vector3 = target.global_transform.origin - global_transform.origin
	if temp_target != null:
		target_direction = temp_target.global_transform.origin - global_transform.origin

	if target_direction.length() < attack_distance:
		attack()
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
	if temp_target != null:
		animation_player.speed_scale = 1
		animation_player.play(anims.pick_random())
		await animation_player.animation_finished
		animation_player.speed_scale = 2
		animation_player.play("voidling/walk")
		if temp_target != null:
			temp_target.damage(attack_power, self)
		else:
			target.damage(attack_power)
	else:
		animation_player.speed_scale = 1
		animation_player.play(anims.pick_random())
		await animation_player.animation_finished
		animation_player.speed_scale = 2
		animation_player.play("voidling/walk")
		if temp_target == null:
			target.damage(attack_power)
		else:
			temp_target.damage(attack_power, self)
	is_attacking = false

func damage(amount:float) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	on_death.emit()
	# TODO: Gold in world label should show the increase...
	MageTower.instance.gold += gold_worth
	MageTower.instance.play_enemy_death()
	queue_free()

func enter_world(new_target:Node3D) -> void:
	target = new_target
	look_at(target.position)
	await get_tree().physics_frame
	navigation_agent.set_target_position(target.global_position + get_random_unit_vector())

func get_random_unit_vector() -> Vector3:
	return Vector3(randf_range(-1,1), 0, randf_range(-1,1)).normalized()

func _on_awareness_area_area_entered(area: Area3D) -> void:
	if area.get_parent() is TowerB:
		temp_target = area.get_parent_node_3d()
		temp_target.on_death.connect(_reacquire_target)
		navigation_agent.set_target_position(temp_target.global_position + get_random_unit_vector())

func _reacquire_target() -> void:
	temp_target = null
	navigation_agent.set_target_position(target.global_position + get_random_unit_vector())

func acquire_target() -> void:
	if target == null:
		var bodies = awareness.get_overlapping_areas()
		for body in bodies:
			if body.get_parent() is TowerB:
				var test_enemy:TowerB = body.get_parent()
				temp_target = body
				break
