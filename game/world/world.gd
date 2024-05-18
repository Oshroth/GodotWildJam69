extends Node3D

@onready var enemy_spawner = $EnemySpawner


func spawn_enemy(instance:Enemy, pos:Vector3) -> void:
	print("Spawn enemy")

func spawn_tower(instance:Node3D, pos:Vector3) -> void:
	print("Spawn tower")

func _ready():
	await get_tree().create_timer(5).timeout
	enemy_spawner.start()
	


func _on_win_timer_timeout():
	print("You win WOWOWOOWWO")
