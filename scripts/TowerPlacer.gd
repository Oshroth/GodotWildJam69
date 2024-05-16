extends Node3D

@export var tower_meshes : Array[PackedScene]
@export var tower_scenes : Array[PackedScene]
@export var placeholder_mat : Material
var tower_meshes_ghost: Array[Node3D]
var tower_ghost: Node3D
#var actual_pointer: Node3D

var is_placing := false
var selected_tower := Building.Type.NONE

func _ready():
	#actual_pointer = towerPlaceholders[0].instantiate()
	#actual_pointer.scale = Vector3(.1, .1, .1)
	#add_child(actual_pointer)
	for mesh in tower_meshes:
		var tower: Node3D = mesh.instantiate()
		if tower is MeshInstance3D:
			for mats in tower.get_surface_override_material_count():
				tower.set_surface_override_material(mats, placeholder_mat)
		for child in tower.find_children("*", "MeshInstance3D") as Array[MeshInstance3D]:
			for mats in child.get_surface_override_material_count():
				child.set_surface_override_material(mats, placeholder_mat)
		add_child(tower)
		tower.hide()
		tower_meshes_ghost.append(tower)

func _physics_process(_delta):
	var point = ScreenPointToRay()
	#actual_pointer.global_position = point
	point.x = int(point.x)
	point.z = int(point.z)
	if is_placing:
		tower_ghost.global_position = point
		if Input.is_action_just_pressed(&"place_building"):
			_clean_up_ghost()
			spawn_tower(selected_tower, point)
			selected_tower = Building.Type.NONE
		elif Input.is_action_just_pressed(&"cancel_building"):
			_clean_up_ghost()
			
func spawn_tower(type: Building.Type, position: Vector3):
	var tower: Node3D
	match type:
		Building.Type.MAGE:
			tower = tower_scenes[0].instantiate()
		Building.Type.TREE_SENTRY:
			tower = tower_scenes[1].instantiate()
			
	add_child(tower)
	tower.global_position = position

func ScreenPointToRay() -> Vector3:
	var spaceState := get_world_3d().direct_space_state
	
	var mousePos := get_viewport().get_mouse_position()
	var camera := get_viewport().get_camera_3d()
	
	var rayOrigin := camera.project_ray_origin(mousePos)
	var rayEnd := rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var ray := PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var rayArray := spaceState.intersect_ray(ray)
	
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3()


func _on_game_ui_build_tower(type: Building.Type):
	if is_placing:
		_clean_up_ghost()
		
	match type:
		Building.Type.MAGE:
			tower_ghost = tower_meshes_ghost[0]
			selected_tower = type
		Building.Type.TREE_SENTRY:
			tower_ghost = tower_meshes_ghost[1]
			selected_tower = type
	tower_ghost.show()
	is_placing = true

func _clean_up_ghost():
	is_placing = false
	tower_ghost.hide()
	tower_ghost = null
