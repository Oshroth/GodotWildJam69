extends CharacterBody3D


@onready var player_model = $player_model
@onready var animation_player = $AnimationPlayer


var speed:int = 400

func _physics_process(delta):
	
	#input to 3d
	var user_input:Vector2 = Vector2(Input.get_axis("ui_left","ui_right"),Input.get_axis("ui_down","ui_up"))
	var player_direction:Vector3 = Vector3(user_input.x,0,-user_input.y).normalized()
	
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


