extends Node3D
class_name MageTower

signal tower_destroyed
signal gold_changed(gold: int)
#Hacky way.
static var instance: MageTower = null

@export var max_health:float = 1000
var current_health:float
@onready var progress_bar = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/ProgressBar
@onready var time_label = $CanvasLayer/TimerPanel/MarginContainer/VBoxContainer/Time
@onready var win_timer = $"../WinTimer"

@onready var death_sound = $death_sound

# TODO: Use this to build towers.
var gold:int = 200:
	set(value):
		gold = value
		gold_changed.emit(value)

func _ready() -> void:
	current_health = max_health
	instance = self
	progress_bar.value = max_health
	progress_bar.max_value = max_health
	
	time_label.text = ""

func _process(_delta: float) -> void:
	$CanvasLayer/GoldPanel/MarginContainer/TextureRect2/Label.text = str(gold)
	if win_timer.is_stopped():
		time_label.text = str(ceil(win_timer.wait_time))
	else:
		time_label.text = str(ceil(win_timer.time_left))

func damage(amount:float) -> void:
	current_health -= amount
	progress_bar.value = current_health
	progress_bar.max_value = max_health
	if current_health <= 0:
		tower_destroyed.emit()

func play_enemy_death():
	death_sound.play()
