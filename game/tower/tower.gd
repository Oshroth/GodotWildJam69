extends Node3D
class_name TowerB

@export var health:float = 10
@export var max_health:float = 10

signal on_death

func damage(amount:float, other:Node3D) -> void:
	health -= amount
	if health <= 0:
		on_death.emit()
		queue_free()
