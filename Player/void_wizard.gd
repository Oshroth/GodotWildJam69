extends Node3D

@onready var animation_player_2 = $AnimationPlayer2


func play_animation(anim_name:String):
	animation_player_2.play(anim_name)
