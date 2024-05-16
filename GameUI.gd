extends Control

class_name GameUI

signal buildTower(type: Building.Type)

@export var building_button_scene : PackedScene
@export var buildings: Array[Building]

@onready var building_panel: BoxContainer = $BuildingPanel

func _ready():
	
	for building in buildings:
		var button := building_button_scene.instantiate() as BuildingButton
		button.building_cost = building.cost
		button.building_name = building.building_name
		button.icon = building.texture
		button.pressed.connect(building_button_tapped.bind(building.type))
		building_panel.add_child(button)

func building_button_tapped(type: Building.Type):
	buildTower.emit(type)

func _process(delta):
	if Input.is_action_just_pressed("select_tower_1"):
		building_button_tapped(Building.Type.MAGE)
	if Input.is_action_just_pressed("select_tower_2"):
		building_button_tapped(Building.Type.TREE_SENTRY)
