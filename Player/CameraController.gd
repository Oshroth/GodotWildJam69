extends Node3D


@onready var camera_3d: Camera3D = $Camera3D
var my_tween:Tween




func _input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("scroll_down") and camera_3d.size <= 30:
		camera_3d.size += 2.5
	
	if Input.is_action_just_pressed("scroll_up") and camera_3d.size >= 5:
		camera_3d.size -= 2.5
	
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rotation_degrees.y -= 60 * delta
	elif Input.is_action_pressed("ui_right"):
		rotation_degrees.y += 60 * delta
