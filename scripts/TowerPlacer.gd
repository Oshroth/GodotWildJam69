extends Node3D

@export var towers: Array[Building]
@export var placeholder_mat : Material

@export var game_ui: GameUI

var tower_meshes_ghost: Array[Node3D]
var tower_ghost: Node3D
#var actual_pointer: Node3D

var is_placing := false
var selected_tower : Building

@export var tower_scale: float = 3.0

func _ready() -> void:
	game_ui.buildings = towers
	for tower_obj in towers:
		var tower: Node3D = tower_obj.mesh.instantiate()
		if tower is MeshInstance3D:
			for mats: int in tower.get_surface_override_material_count():
				tower.set_surface_override_material(mats, placeholder_mat)
		for child in tower.find_children("*", "MeshInstance3D") as Array[MeshInstance3D]:
			for mats in child.get_surface_override_material_count():
				child.set_surface_override_material(mats, placeholder_mat)
		add_child(tower)
		tower.scale = Vector3.ONE * tower_scale
		tower.hide()
		tower_meshes_ghost.append(tower)

func _physics_process(_delta: float) -> void:
	var point := ScreenPointToRay()
	point.x = int(point.x)
	point.z = int(point.z)
	if is_placing:
		tower_ghost.global_position = point
		if Input.is_action_just_pressed(&"place_building"):
			spawn_tower(selected_tower, point)
			_clean_up_ghost()
		elif Input.is_action_just_pressed(&"cancel_building"):
			_clean_up_ghost()
			
func spawn_tower(building: Building, pos: Vector3) -> void:
	MageTower.instance.gold -= building.cost
	var tower_node: Node3D = building.spawn_scene.instantiate()
	$BuildingSound.stream = building.placement_sound
	add_child(tower_node)
	tower_node.global_position = pos
	tower_node.scale = Vector3.ONE * tower_scale
	
	$BuildingSound.play()


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


func _on_game_ui_build_tower(type: Building.Type) -> void:
	var tower_filter := towers.filter(func(tower: Building) -> bool: return tower.type == type)
	if tower_filter.is_empty() || tower_filter[0].cost > MageTower.instance.gold:
		return
	
	if is_placing:
		_clean_up_ghost()
		
	tower_ghost = tower_meshes_ghost[towers.find(tower_filter[0])]
	tower_ghost.show()
	selected_tower = tower_filter[0]
	is_placing = true
	

func _clean_up_ghost() -> void:
	is_placing = false
	if tower_ghost != null:
		tower_ghost.hide()
	tower_ghost = null
	selected_tower = null


func _on_mage_tower_gold_changed(gold: int) -> void:
	if selected_tower != null and selected_tower.cost > gold:
		_clean_up_ghost()
