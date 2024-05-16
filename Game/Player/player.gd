extends CharacterBody3D

@onready var player_model = $player_model
@onready var animation_player = $AnimationPlayer
@export var navigation_parent:NavigationRegion3D

@export var camera:Camera3D
@export var cursor:Node3D

var current_gold:int = 200

var current_tower:Tower = null

var available_tower:Array[PackedScene] = [
	preload("res://Game/Towers/BirdTower/BirdTower.tscn")
]

var speed:int = 400

func _process(delta: float) -> void:
	print(collision_layer)
	_update_cursor()
	if Input.is_key_pressed(KEY_0):
		if cursor.get_child_count() == 0:
			current_tower = available_tower[0].instantiate()
			current_tower.placing = true
			cursor.add_child(current_tower)
			
	
	if Input.is_action_just_pressed("click"):
		if cursor.get_child_count() > 0:
			cursor.remove_child(current_tower)
			navigation_parent.add_child(current_tower)
			current_tower.global_position = cursor.global_position
			current_tower.global_position.y = 0
			current_tower.placing = false
			current_tower = null
			navigation_parent.bake_navigation_mesh(true)

func _physics_process(delta):
	var input_direction := Input.get_vector("left", "right", "up", "down")
	var input_vector:Vector3 = Vector3(input_direction.x, 0, input_direction.y)
	var player_direction:Vector3 = (camera.transform.basis * input_vector)
	player_direction.y = 0
	player_direction = player_direction.normalized()
	
	#moving the character and rotation the model
	velocity = player_direction * speed * delta
	if velocity != Vector3.ZERO:
		player_model.look_at(transform.origin + velocity,Vector3.UP)
		animation_player.speed_scale = 3
		animation_player.play("player/walk")
	else:
		animation_player.speed_scale = 1
		animation_player.play("player/idle")
	move_and_slide()
	
func _update_cursor():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = 256
	ray_query.collide_with_areas = false
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result:
		cursor.position = raycast_result.position


