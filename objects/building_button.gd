extends Button

class_name BuildingButton

@export var building_cost: int:
	set(value):
		building_cost = value
		if is_node_ready():
			cost_label.text = str(building_cost)
@export var building_name: StringName

@onready var name_label: Label = $Name
@onready var cost_label: Label = $Cost

func _ready():
	name_label.text = building_name
	cost_label.text = str(building_cost)