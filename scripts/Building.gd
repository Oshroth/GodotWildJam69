extends Resource

class_name Building

@export var cost: int
@export var building_name: StringName
@export var type: Type
@export var texture: Texture2D

enum Type {
	NONE,
	MAGE,
	TREE_SENTRY
}
