extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _process(delta):
	
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()

func _on_retry_button_pressed():
	print ("Pressed")
	if get_tree().change_scene_to_file("res://Scenes/GameScenes/GameScene.tscn"):
		print ("It worked")
	else:
		print ("Failed to change scene")



func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	print ("Pressed")
	if get_tree().change_scene_to_file("res://Scenes/GameScenes/main_menu.tscn"):
		print ("It worked")
	else:
		print ("Failed to change scene")
