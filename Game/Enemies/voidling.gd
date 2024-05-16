extends Node3D
class_name Enemy

var target:MageTower = null
@export var speed:float = 10.0
@export var attack_timer:float = 1.0
@export var attack_power:float = 2
@export var gold_worth:float = 10

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
	target.damage(attack_power)
	is_attacking = false
	

func enter_world(new_target:Node3D) -> void:
	target = new_target
	look_at(target.position)
	print("Enemy entered world")
