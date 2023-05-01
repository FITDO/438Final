extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("reload_current_scene"):
		get_tree().reload_current_scene()
