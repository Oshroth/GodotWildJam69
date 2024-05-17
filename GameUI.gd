extends Control

class_name GameUI

signal buildTower(type: Building.Type)

@export var building_button_scene : PackedScene
var buildings: Array[Building]
var build_buttons: Array[BuildingButton]

@onready var building_panel: BoxContainer = $BuildingPanel

func _ready() -> void:
	
	for building in buildings:
		var button := building_button_scene.instantiate() as BuildingButton
		button.building_cost = building.cost
		button.building_name = building.building_name
		button.icon = building.texture
		button.pressed.connect(building_button_tapped.bind(building.type))
		building_panel.add_child(button)
		build_buttons.append(button)

func building_button_tapped(type: Building.Type) -> void:
	buildTower.emit(type)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select_tower_1") and !buildings.is_empty():
		building_button_tapped(buildings[0].type)
	if Input.is_action_just_pressed("select_tower_2") and buildings.size() >= 2:
		building_button_tapped(buildings[1].type)


func _on_gold_changed(gold: int) -> void:
	for i in range(buildings.size()):
		build_buttons[i].disabled = buildings[i].cost > gold
