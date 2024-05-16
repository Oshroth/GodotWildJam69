extends Node3D
class_name World

@export var tower:Node3D

func add_enemy(enemy:Enemy):
	add_child(enemy)
	enemy.enter_world(tower)

