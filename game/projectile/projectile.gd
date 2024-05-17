extends Node3D
class_name Projectile

@export var speed:float = 30
@export var damage:float = 2
@export var model:String = "seed/rock"

@onready var seed = $seed
@onready var rock = $rock


var target:Enemy = null

func _ready():
	if model == "seed/rock":
		print("hey the projectile doesnt have model")
	elif model == "seed":
		seed.show()
	elif model == "rock":
		rock.show()

func _process(delta: float) -> void:
	if target != null:
		var direction := target.global_transform.origin - global_transform.origin
		look_at(target.global_transform.origin)
		#if direction.length() < 2:
			#queue_free()
			#target.damage(damage)
			#
		direction = direction.normalized()
		global_transform.origin += direction * speed * delta
	else:
		queue_free()
		


func _on_hurtbox_body_entered(body):
	if body is Enemy:
		target.damage(damage)
		call_deferred("queue_free")
