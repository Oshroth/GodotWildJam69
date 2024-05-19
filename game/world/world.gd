extends Node3D

signal level_lost
signal level_won

@export_multiline var dialog:Array[String]
@onready var enemy_spawner = $EnemySpawner
@onready var dialog_label = $DialogUI/ColorRect/dialog_label
@onready var game_ui = $GameUI
@onready var canvas_layer = $MageTower/CanvasLayer
@onready var dialog_ui = $DialogUI
@onready var win_timer = $WinTimer
@onready var mage_tower: MageTower = $MageTower
@onready var intro_cutscene = $IntroCutscene
@onready var music_slow = $MusicSlow
@onready var music_fast = $MusicFast
@onready var audio_stream_player = $wizard/AudioStreamPlayer



var baby_tween:Tween
var talking:bool = false
var intro_active := true
var dialog_index : int = 0


func _ready():
	intro_active = true
	dialog_index = 0
	game_ui.hide()
	canvas_layer.hide()
	manage_intro()
	mage_tower.tower_destroyed.connect(_on_tower_destroyed)

func _on_win_timer_timeout():
	level_won.emit()

func _on_tower_destroyed():
	level_lost.emit()

func _process(delta):
	if intro_active and Input.is_action_just_pressed("skip_dialog"):
		baby_tween.kill()
		dialog_index = dialog.size()
		audio_stream_player.stop()
		manage_intro()
	if intro_active and Input.is_action_just_pressed("place_building"):
		if talking:
			baby_tween.kill()
			dialog_label.visible_ratio = 1
			audio_stream_player.stop()
			talking = false
		else:
			manage_intro()

func manage_intro():
	if baby_tween:
		baby_tween.kill()
	
	if dialog_index >= dialog.size():
		dialog_ui.hide()
		game_ui.show()
		canvas_layer.show()
		intro_cutscene.play("walk_to_end")
	else:
		var text:String = dialog[dialog_index]
		dialog_label.text = text
		dialog_label.visible_ratio = 0
		audio_stream_player.play()
		talking = true
		baby_tween = create_tween()
		baby_tween.tween_property(dialog_label,"visible_ratio",1,text.length()/30)
		baby_tween.finished.connect(tween_finished)
		dialog_index += 1

func tween_finished():
	audio_stream_player.stop()
	talking = false

func _on_intro_cutscene_animation_finished(anim_name):
		fade_music()
		win_timer.start()
		enemy_spawner.start()
		intro_active = false

func fade_music(to_action:bool = true):
	if to_action:
		var t = create_tween().set_parallel(true)
		#t.tween_property(music_slow,"volume_db",-80,0.2)
		music_slow.volume_db = 0
		music_fast.volume_db = 0
