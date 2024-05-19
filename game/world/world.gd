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


func _ready():
	game_ui.hide()
	canvas_layer.hide()
	manage_intro()
	mage_tower.tower_destroyed.connect(_on_tower_destroyed)

func _on_win_timer_timeout():
	level_won.emit()

func _on_tower_destroyed():
	level_lost.emit()

func _process(delta):
	if Input.is_action_just_pressed("place_building"):
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
	
	if dialog.is_empty():
		dialog_ui.hide()
		game_ui.show()
		canvas_layer.show()
		intro_cutscene.play("walk_to_end")
	else:
		var text:String = dialog.pop_front()
		dialog_label.text = text
		dialog_label.visible_ratio = 0
		audio_stream_player.play()
		talking = true
		baby_tween = create_tween()
		baby_tween.tween_property(dialog_label,"visible_ratio",1,text.length()/30)
		baby_tween.finished.connect(tween_finished)

func tween_finished():
	audio_stream_player.stop()
	talking = false

func _on_intro_cutscene_animation_finished(anim_name):
		fade_music()
		win_timer.start()
		enemy_spawner.start()
		set_process(false)

func fade_music(to_action:bool = true):
	if to_action:
		if music_fast == null:
			music_fast = AudioStreamPlayer.new()
			music_fast.autoplay = true
			music_fast.stream = load("res://Audio/GJ69TowerDefense_MX_duringWaves_-15dB.wav")
			add_child(music_fast)
		if music_slow == null:
			music_slow = AudioStreamPlayer.new()
			music_slow.autoplay = true
			music_slow.stream = load("res://Audio/GJ69TowerDefense_MX_betweenWaves_-15dB.wav")
			add_child(music_slow)
		var t = create_tween().set_parallel(true)
		t.tween_property(music_slow,"volume_db",-80,0.2)
		music_fast.volume_db = 0
