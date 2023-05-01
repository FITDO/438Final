extends Area3D

var ending = false

func _process(delta):
	
	if ending:
		var amount = 0.5 * delta
		$AnimationPlayer.speed_scale = $AnimationPlayer.speed_scale + amount
		$CrystalLight.omni_range = $CrystalLight.omni_range + amount
		$CrystalLight.light_energy = $CrystalLight.light_energy + 8 * delta
		
func _on_body_entered(body):
	
	if body.get_collision_layer () == 4:
		beginEndGameSeq()

func beginEndGameSeq() -> void:
	
	if not ending:
		ending = true
		$EndGameParticles.emitting = true
		$EndGameTimer.start()


func _on_timer_timeout():
	if get_tree().change_scene_to_file ("res://Scenes/GameScenes/win_game_scene.tscn"):
		print ("It worked")
	else:
		print ("Failed to change scene")
