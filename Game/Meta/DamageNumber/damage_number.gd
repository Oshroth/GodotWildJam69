extends Label3D
class_name DamageNumber

func set_model(new_text:String, position:Vector3) -> void:
	text = new_text
	position = position

func _ready() -> void:
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", position + Vector3(0, 1, 0), 0.75)
	tween.tween_property(self, "scale", Vector3(0.1, 0.1, 0.1), 0.75).set_trans(Tween.TRANS_BACK)
	await tween.finished
	queue_free()

