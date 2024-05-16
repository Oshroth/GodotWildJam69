extends Node3D
class_name Enemy

var target:MageTower = null
@export var max_health:float = 10
@export var health:float = 10
@export var speed:float = 10.0
@export var attack_timer:float = 1.0
@export var attack_power:float = 2
@export var gold_worth:float = 10

signal on_death

func _process(delta: float) -> void:
	var direction = target.position - position
	if direction.length() < 5:
		attack()
	else:
		direction = direction.normalized()
		position += direction * speed * delta

var is_attacking = false

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
	print("Enemy entered world")
