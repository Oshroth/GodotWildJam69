extends Node3D
class_name Projectile

@export var speed:float = 2.0

var target:Enemy = null
var attack_damage:float = 1

func set_model(new_target:Enemy, new_attack_damage:float) -> void:
	target = new_target
	attack_damage = new_attack_damage
	
func _process(delta: float) -> void:
	var direction = target.position - position
	look_at(target.position)
	direction = direction.normalized()
	position += direction * speed * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
