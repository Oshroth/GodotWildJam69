extends Node3D
@onready var sub_viewport : SubViewport = $SubViewport

@export var models: Array[SnapshotModel]

func _ready() -> void:
	for model in models:
		var model_node: Node3D = model.mesh.instantiate()
		sub_viewport.add_child(model_node)
		model_node.position = model.offset
		
		await take_snapshot(model.filename)
		model_node.queue_free()
	
	get_tree().quit()
	
func take_snapshot(filename: String) -> void:
	# Wait a few frames
	await RenderingServer.frame_post_draw
	
	# Get the image from the viewport's texture
	var img : Image = sub_viewport.get_texture().get_image()

	# convert it to RGBA8 to have transparency
	img.convert(Image.FORMAT_RGBA8)
	# save it
	img.save_png('res://assets/images/' + filename)
