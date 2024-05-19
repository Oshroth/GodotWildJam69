extends Node3D
class_name TowerB

@export var health:float = 10
@export var max_health:float = 10

@export var projectile:PackedScene
@export var projectile_model:String
@export var damage_amount:float
@export var attack_timer:float
@export var projectile_position:Node3D
@export var animation_player:AnimationPlayer
@export var animation_idle:String
@export var tower_mesh:Node3D
@export var hit_effect_targets:Array[MeshInstance3D]

@export var target_finder:Area3D
@export var animation_attack:String
@onready var current_timer:float = attack_timer
@export var distance:float = 12

var target:Enemy = null
var damage_material = preload("res://Shaders/damage_material.tres")

signal on_death

func _ready():
	for x in hit_effect_targets:
		x.material_override = x.get_active_material(0).duplicate()
		x.get_active_material(0).setup_local_to_scene()
	animation_player.play(animation_idle)
	projectile_position.reparent(tower_mesh)
	health = max_health

func damage(amount:float, other:Node3D) -> void:
	hit_effect()
	health -= amount
	if health <= 0:
		on_death.emit()
		queue_free()

func scale_visual(amount:Vector3) -> void:
	$Visual.scale = amount

func _process(delta: float) -> void:
	current_timer -= delta
	if current_timer <= 0:
		acquire_target()
		shoot_projectile()
		current_timer = attack_timer

func shoot_projectile() -> void:
	if target != null:
		animation_player.play(animation_attack)
		await animation_player.animation_finished
		if target == null:
			animation_player.play(animation_idle)
			return
		tower_mesh.look_at(target.position)
		rotation.x = 0
		rotation.z = 0
		var new_projectile:Projectile = projectile.instantiate()
		new_projectile.model = projectile_model
		new_projectile.damage = damage_amount
		get_parent().add_child(new_projectile)
		new_projectile.global_position = projectile_position.global_position
		new_projectile.target = target
		animation_player.play(animation_idle)

func _on_target_finder_body_entered(body: Node3D) -> void:
	if body is Enemy and target == null:
		if body.global_position.distance_to(global_position) <= distance:
			target = body
			target.on_death.connect(reset_target)
		
func acquire_target() -> void:
	if target == null:
		var bodies = target_finder.get_overlapping_bodies()
		for body in bodies:
			if body is Enemy:
				if body.global_position.distance_to(global_position) <= distance:
					var test_enemy:Enemy = body
					var distance = test_enemy.global_position.distance_to(global_position)
					target = body
					target.on_death.connect(reset_target)
					break

func reset_target() -> void:
	target = null

func hit_effect():
	for x in hit_effect_targets:
		x.get_active_material(0).albedo_color = Color.RED
		#x.set_surface_override_material(0,damage_material)
	var t = get_tree().create_timer(0.15)
	await t.timeout
	for x in hit_effect_targets:
		x.get_active_material(0).albedo_color = Color.WHITE
		#x.set_surface_override_material(0,null)
