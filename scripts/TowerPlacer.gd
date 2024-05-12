extends Node3D

@export var towerPlaceholder : PackedScene
var tower_ghost: Node3D

func _ready():
	tower_ghost = towerPlaceholder.instantiate()
	add_child(tower_ghost)

func _process(delta):
	var point = ScreenPointToRay()
	point.x = floori(point.x) - floori(point.x) % 2
	point.z = floori(point.z) - floori(point.z) % 2
	print(point)
	tower_ghost.global_position = point

func ScreenPointToRay() -> Vector3:
	var spaceState := get_world_3d().direct_space_state
	
	var mousePos := get_viewport().get_mouse_position()
	var camera := get_tree().root.get_camera_3d()
	
	var rayOrigin := camera.project_ray_origin(mousePos)
	var rayEnd := rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var ray := PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var rayArray := spaceState.intersect_ray(ray)
	
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3()
