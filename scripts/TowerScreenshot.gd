extends Node3D

@onready var mage_tower: Node3D = $SubViewport/mage_tower
@onready var tree_sentry: Node3D = $SubViewport/tree_sentry

func _ready() -> void:
	mage_tower.show()
	tree_sentry.hide()
	
	await take_snapshot("mage_tower_icon.png")
	
	mage_tower.hide()
	tree_sentry.show()
	
	await take_snapshot("tree_sentry_icon.png")
	
	get_tree().quit()
	
func take_snapshot(filename: String) -> void:
	# Wait a few frames
	await RenderingServer.frame_post_draw
	
	# Get the image from the viewport's texture
	var img : Image = $SubViewport.get_texture().get_image()

	# convert it to RGBA8 to have transparency
	img.convert(Image.FORMAT_RGBA8)
	# save it
	img.save_png('res://assets/images/' + filename)
