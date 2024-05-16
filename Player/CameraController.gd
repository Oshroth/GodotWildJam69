extends Node3D


@onready var camera_3d = $Camera3D
var my_tween:Tween




func _input(event):
	
	if Input.is_action_just_pressed("scroll_down") and camera_3d.size <= 30:
		camera_3d.size += 2.5
	
	if Input.is_action_just_pressed("scroll_up") and camera_3d.size >= 5:
		camera_3d.size -= 2.5
	
	if Input.is_action_just_pressed("ui_left"):
		if my_tween != null:
			my_tween.kill()
		my_tween = create_tween()
		my_tween.tween_property(self,"rotation_degrees:y",rotation_degrees.y + 45,0.2)
	elif Input.is_action_just_pressed("ui_right"):
		if my_tween != null:
			my_tween.kill()
		my_tween = create_tween()
		my_tween.tween_property(self,"rotation_degrees:y",rotation_degrees.y - 45,0.2)
