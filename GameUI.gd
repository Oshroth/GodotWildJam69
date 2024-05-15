extends Control

class_name GameUI

signal buildTower(type: Building.Type)

@export var building_button_scene : PackedScene

@onready var building_panel: BoxContainer = $BuildingPanel

func _ready():
	var button := building_button_scene.instantiate() as BuildingButton
	#button.icon
	button.building_cost = 100
	button.building_name = &"Archer Tower"
	button.pressed.connect(building_button_tapped.bind(Building.Type.ARCHER))
	building_panel.add_child(button)
	
	button = building_button_scene.instantiate() as BuildingButton
	#button.icon
	button.building_cost = 150
	button.building_name = &"Placeholder Tower"
	button.pressed.connect(building_button_tapped.bind(Building.Type.PLACEHOLDER))
	building_panel.add_child(button)

func building_button_tapped(type: Building.Type):
	buildTower.emit(type)
