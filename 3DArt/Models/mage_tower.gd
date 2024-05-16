extends Node3D
class_name MageTower

@export var max_health:float = 100
@onready var current_health:float = max_health

# TODO: Add attacker if the tower itself can reflect damage or something.
func damage(amount:float) -> void:
	current_health -= amount
	print(current_health)
	if current_health <= 0:
		# TODO: Game over with stats etc?
		get_tree().reload_current_scene()
