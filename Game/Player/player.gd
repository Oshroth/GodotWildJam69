extends CharacterBody3D

@onready var player_model = $player_model
@onready var animation_player = $AnimationPlayer
@export var camera:Camera3D
@export var cursor:Node3D

var current_gold:int = 200

var current_tower:PackedScene = null

var available_tower:Array[PackedScene] = [
	preload("res://TestTower.tscn"),
	preload("res://TestTower.tscn")
]

var speed:int = 400

func _process(delta: float) -> void:
	_update_cursor()

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
	# TODO: Probably move this from physics process
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result:
		cursor.position = raycast_result.position


