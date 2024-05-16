extends Control

class_name GameUI

signal buildTower(type: Building.Type)

@export var building_button_scene : PackedScene

@onready var building_panel: BoxContainer = $BuildingPanel

func _ready():
	var button := building_button_scene.instantiate() as BuildingButton
	#button.icon
	button.building_cost = 100
	button.building_name = &"Mage Tower"
	button.pressed.connect(building_button_tapped.bind(Building.Type.MAGE))
	building_panel.add_child(button)
	
	button = building_button_scene.instantiate() as BuildingButton
	#button.icon
	button.building_cost = 150
	button.building_name = &"Placeholder Tower"
	button.pressed.connect(building_button_tapped.bind(Building.Type.TREE_SENTRY))
	building_panel.add_child(button)

func building_button_tapped(type: Building.Type):
	buildTower.emit(type)

func _process(delta):
	if Input.is_action_just_pressed("select_tower_1"):
		building_button_tapped(Building.Type.MAGE)
	if Input.is_action_just_pressed("select_tower_2"):
		building_button_tapped(Building.Type.TREE_SENTRY)
