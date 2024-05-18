extends Node3D

@export var dialog:Array[String]
@onready var enemy_spawner = $EnemySpawner
@onready var dialog_label = $DialogUI/ColorRect/dialog_label
@onready var game_ui = $GameUI
@onready var canvas_layer = $MageTower/CanvasLayer
@onready var dialog_ui = $DialogUI
@onready var win_timer = $WinTimer


var baby_tween:Tween
var talking:bool = false

func spawn_enemy(instance:Enemy, pos:Vector3) -> void:
	print("Spawn enemy")

func spawn_tower(instance:Node3D, pos:Vector3) -> void:
	print("Spawn tower")

func _ready():
	game_ui.hide()
	canvas_layer.hide()
	manage_intro()
	

func _on_win_timer_timeout():
	print("You win WOWOWOOWWO")

func _process(delta):
	if Input.is_action_just_pressed("place_building"):
		if talking:
			baby_tween.kill()
			dialog_label.visible_ratio = 1
			talking = false
		else:
			manage_intro()

func manage_intro():
	if baby_tween:
		baby_tween.kill()
	
	if dialog.is_empty():
		dialog_ui.hide()
		game_ui.show()
		canvas_layer.show()
		win_timer.start()
		enemy_spawner.start()
		set_process(false)
	else:
		var text:String = dialog.pop_front()
		dialog_label.text = text
		dialog_label.visible_ratio = 0
		talking = true
		baby_tween = create_tween()
		baby_tween.tween_property(dialog_label,"visible_ratio",1,text.length()/5)
		baby_tween.finished.connect(tween_finished)

func tween_finished():
	talking = false
	

