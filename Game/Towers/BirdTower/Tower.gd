extends Node3D
class_name Tower

@export var projectile_scene:PackedScene
@export var attack_timer:float = 2
@export var attack_damage:float = 1
@export var icon:Texture2D

var target:Enemy = null
var shoot_timer:Timer = Timer.new()

var placing:bool = false

func shoot() -> void:
	if target != null:
		var projectile:Projectile = projectile_scene.instantiate()
		projectile.set_model(target, attack_damage)

func _ready():
	shoot_timer.wait_time = attack_timer
	shoot_timer.autostart = false
	shoot_timer.one_shot = false
	shoot_timer.timeout.connect(shoot)
	add_child(shoot_timer)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if placing:
		return
		
	if area.get_parent() is Enemy and target == null:
		target = area.get_parent()
		target.on_death.connect(_on_target_killed)
		shoot_timer.start()

func _on_area_3d_area_exited(area: Area3D) -> void:
	if placing:
		return
		
	if area.get_parent() is Enemy and target != null:
		target == null
		shoot_timer.stop()
		# TODO: Manual attempt
	
func _on_target_killed() -> void:
	target = null
	shoot_timer.stop()
	# TODO: Manual attempt.


func _on_area_3d_body_entered(body: Node3D) -> void:
	if placing:
		return
		
	if body is Enemy and target == null:
		target = body
		target.on_death.connect(_on_target_killed)
		shoot_timer.start()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if placing:
		return
		
	if body.get_parent() is Enemy and target != null:
		target == null
		shoot_timer.stop()
		# TODO: Manual attempt
