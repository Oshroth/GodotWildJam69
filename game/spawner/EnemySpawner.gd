extends Node3D

@export var spawn_timer:float = 1.5
@export var spawn_radius:float = 200
@export var main_target:Node3D

var current_spawn_timer:float = 1.5

var enemies:Array[PackedScene] = [
	preload("res://game/enemies/voidling/voidling.tscn")
]

func _process(delta: float) -> void:
	current_spawn_timer -= delta
	if current_spawn_timer <= 0:
		current_spawn_timer = spawn_timer
		_spawn_random_enemy()

func _spawn_random_enemy() -> void:
	var enemy_scene:PackedScene = enemies.pick_random()
	var new_enemy:Enemy = enemy_scene.instantiate()
	var spawn_position := Vector3(randf_range(-1,1), 0.0, randf_range(-1,1)) * spawn_radius
	get_parent().add_child(new_enemy)
	new_enemy.global_position = spawn_position
	new_enemy.enter_world(main_target)
