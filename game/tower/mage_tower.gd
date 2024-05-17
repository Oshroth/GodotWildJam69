extends Node3D
class_name MageTower
#Hacky way.
static var instance = null

@export var max_health:float = 1000
var current_health:float

# TODO: Use this to build towers.
var gold:int = 200

func _ready() -> void:
	
	instance = self
	$CanvasLayer/ProgressBar.value = max_health
	$CanvasLayer/ProgressBar.max_value = max_health

func _process(delta: float) -> void:
	$CanvasLayer/Label.text = "Coins: " + str(gold)

func damage(amount:float) -> void:
	current_health -= amount
	$CanvasLayer/ProgressBar.value = current_health
	$CanvasLayer/ProgressBar.max_value = max_health
	if current_health <= 0:
		print("End game")
		get_tree().reload_current_scene()
