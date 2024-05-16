extends Node3D
class_name Projectile

@export var speed:float = 2.0

var target:Enemy = null

func set_model(new_target:Enemy) -> void:
	target = new_target
	
func _process(delta: float) -> void:
	var direction = target.position - position
	look_at(target.position)
	direction = direction.normalized()
	position += direction * speed * delta
