extends Node3D
class_name Projectile

@export var speed:float = 10
@export var damage:float = 2

var target:Enemy = null

func _process(delta: float) -> void:
	if target != null:
		var direction = target.position - position
		look_at(target.position)
		if direction.length() < 2:
			queue_free()
			target.damage(damage)
			
		direction = direction.normalized()
		position += direction * speed * delta
	else:
		queue_free()
		
