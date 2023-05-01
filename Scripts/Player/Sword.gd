extends Node3D

var onRight = false;

var player = null

@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Area3D/SwordMesh.hide()
	$Area3D/SwordCollision.disabled = true
	
	player = get_parent().get_parent()

func swingSword () -> void:
	if !($AnimationPlayer.is_playing()):
		if (onRight):
			$AnimationPlayer.play_backwards("SwordSwing")
			onRight = false
		else:
			$AnimationPlayer.play("SwordSwing")
			onRight = true

func _on_animation_player_animation_started(anim_name):
	$Area3D/SwordMesh.show()
	$SwordSound.play()
	$Area3D/SwordCollision.disabled = false

func _on_animation_player_animation_finished(anim_name):
	$Area3D/SwordMesh.hide()
	$Area3D/SwordCollision.disabled = true

func _on_area_3d_body_entered(body):
	if body.get_collision_layer() == 16:
		body.TakeDamage (damage)
		player.add_arrow (1)
