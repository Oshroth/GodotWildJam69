extends CanvasLayer

@onready var color_rect = $ColorRect

func _ready():
	var t = create_tween().set_loops().set_ease(Tween.EASE_OUT)
	t.tween_property(color_rect,"material:shader_parameter/grain_amount",0.1,1.0)
	t.tween_property(color_rect,"material:shader_parameter/grain_amount",0.02,1.0)
	#t.tween_property(color_rect,"material:shader_parameter/grain_size",2,0.5)
	#t.tween_property(color_rect,"material:shader_parameter/grain_size",1,0.5)
