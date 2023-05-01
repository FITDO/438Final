extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Controls.hide()
	
func _process(delta):
	
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()

func _on_controls_button_pressed():
	$Main.hide()
	$Controls.show()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_return_button_pressed():
	$Controls.hide()
	$Main.show()


func _on_play_button_pressed():
	print ("Pressed")
	if get_tree().change_scene_to_file("res://Scenes/GameScenes/GameScene.tscn"):
		print ("It worked")
	else:
		print ("Failed to change scene")
