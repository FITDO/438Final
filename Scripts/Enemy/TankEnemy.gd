extends BsEnemy

var speed = 3

var player = null

func _ready():
	player = get_tree().get_root().get_child(0).get_node("Player")

func _physics_process(delta):
	
	$NavigationAgent3D.set_target_position(player.global_position)
	
	var current_location = global_transform.origin
	var next_location = $NavigationAgent3D.get_next_path_position()
	var new_veloctiy = (next_location - current_location).normalized() * speed
	
	velocity = new_veloctiy
	
	
	move_and_slide()

func DeathEvent () -> void:
	spawnDeathParticles()
	queue_free()
