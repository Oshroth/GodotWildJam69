extends Area3D
class_name EnemySpawner

@export var world:World
@onready var collision_shape:BoxShape3D = get_node("CollisionShape3D").shape
@export var spawn_time:float = 2
var current_spawn_time:float = 2

var is_spawning = true

@onready var enemies:Array[PackedScene] = [
	preload("res://Game/Enemies/voidling.tscn")
]

func start_spawning() -> void:
	is_spawning = true
	current_spawn_time = spawn_time

func _get_random_spawn() -> Vector3:
	var rand_z = randf_range(0, collision_shape.size.z)
	return Vector3(position.x, position.y, rand_z + position.z)

func spawn_enemy() -> void:
	var enemy_scene:PackedScene = enemies.pick_random()
	var new_enemy:Node3D = enemy_scene.instantiate()
	new_enemy.position = _get_random_spawn()
	world.add_enemy(new_enemy)

func _process(delta: float) -> void:
	if is_spawning:
		current_spawn_time -= delta
		if current_spawn_time <= 0:
			current_spawn_time = spawn_time
			spawn_enemy()
