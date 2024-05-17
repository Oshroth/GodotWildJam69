extends Node3D
class_name TowerB

@export var health:float = 10
@export var max_health:float = 10

@export var projectile:PackedScene
@export var damage_amount:float
@export var attack_timer:float
@export var projectile_position:Node3D
@onready var current_timer:float = attack_timer

var target:Enemy = null

signal on_death

func damage(amount:float, other:Node3D) -> void:
	health -= amount
	if health <= 0:
		on_death.emit()
		queue_free()

func _process(delta: float) -> void:
	current_timer -= delta
	if current_timer <= 0:
		current_timer = attack_timer
		shoot_projectile()

func shoot_projectile() -> void:
	if target != null:
		%AnimationPlayer.play("tree/attack")
		await %AnimationPlayer.animation_finished
		look_at(target.position)
		var new_projectile:Projectile = projectile.instantiate()
		new_projectile.global_position = projectile_position.global_position
		new_projectile.target = target
		get_parent().add_child(new_projectile)

func _on_target_finder_body_entered(body: Node3D) -> void:
	if body is Enemy and target == null:
		target = body
		target.on_death.connect(reset_target)

func reset_target() -> void:
	target = null
