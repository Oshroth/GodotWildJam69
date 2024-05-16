extends Node3D
class_name MageTower

@export var max_health:float = 100
@onready var current_health:float = max_health

var damage_scene:PackedScene = preload("res://Game/Meta/DamageNumber/damage_number.tscn")

# TODO: Add attacker if the tower itself can reflect damage or something.
func damage(amount:float, other:Enemy) -> void:
	current_health -= amount
	var damage_view:DamageNumber = damage_scene.instantiate()
	damage_view.set_model(str(amount), global_position)
	get_parent().add_child(damage_view)
	if current_health <= 0:
		# TODO: Game over with stats etc?
		get_tree().reload_current_scene()
