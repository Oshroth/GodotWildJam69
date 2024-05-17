extends Resource

class_name Building

@export var cost: int
@export var building_name: StringName
@export var type: Type
@export var texture: Texture2D
@export var mesh: PackedScene
@export var spawn_scene: PackedScene
@export var placement_sound: AudioStream

enum Type {
	NONE,
	TREE_SENTRY
}
