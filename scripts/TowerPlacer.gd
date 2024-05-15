extends Node3D

@export var towerPlaceholders : Array[PackedScene]
@export var towerScenes : Array[PackedScene]
var tower_ghost: Node3D
var actual_pointer: Node3D

var is_placing := false
var selected_tower := Building.Type.NONE

func _ready():
	actual_pointer = towerPlaceholders[0].instantiate()
	actual_pointer.scale = Vector3(.1, .1, .1)
	add_child(actual_pointer)

func _physics_process(_delta):
	var point = ScreenPointToRay()
	actual_pointer.global_position = point
	point.x = int(point.x) - int(point.x) % 2
	point.z = int(point.z) - int(point.z) % 2
	print(point)
	if is_placing:
		tower_ghost.global_position = point
		if Input.is_action_just_pressed(&"place_building"):
			is_placing = false
			tower_ghost.queue_free()
			spawn_tower(selected_tower, point)
			selected_tower = Building.Type.NONE
		elif Input.is_action_just_pressed(&"cancel_building"):
			is_placing = false
			tower_ghost.queue_free()
			
func spawn_tower(type: Building.Type, position: Vector3):
	var tower: Node3D
	match type:
		Building.Type.ARCHER:
			tower = towerScenes[0].instantiate()
		Building.Type.PLACEHOLDER:
			tower = towerScenes[1].instantiate()
			
	add_child(tower)
	tower.global_position = position

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


func _on_game_ui_build_tower(type: Building.Type):
	if is_placing:
		tower_ghost.queue_free()
		
	
	match type:
		Building.Type.ARCHER:
			tower_ghost = towerPlaceholders[0].instantiate()
			selected_tower = type
		Building.Type.PLACEHOLDER:
			tower_ghost = towerPlaceholders[1].instantiate()
			selected_tower = type
	
	add_child(tower_ghost)
	is_placing = true
