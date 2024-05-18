extends Node3D
class_name MageTower

signal gold_changed(gold: int)
#Hacky way.
static var instance: MageTower = null

@export var max_health:float = 1000
var current_health:float

@onready var death_sound = $death_sound

# TODO: Use this to build towers.
var gold:int = 200:
	set(value):
		gold = value
		gold_changed.emit(value)

func _ready() -> void:
	current_health = max_health
	instance = self
	$CanvasLayer/ProgressBar.value = max_health
	$CanvasLayer/ProgressBar.max_value = max_health

func _process(_delta: float) -> void:
	$CanvasLayer/Label.text = str(gold)

func damage(amount:float) -> void:
	current_health -= amount
	$CanvasLayer/ProgressBar.value = current_health
	$CanvasLayer/ProgressBar.max_value = max_health
	if current_health <= 0:
		print("End game")
		get_tree().reload_current_scene()

func play_enemy_death():
	death_sound.play()
