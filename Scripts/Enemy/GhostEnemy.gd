extends BsEnemy

var speed = 4
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_child(0).get_node("Player")

func _physics_process(delta):
	
	if player:
		self.global_position = self.global_position.move_toward(player.get_global_position(), delta * speed)


func DeathEvent () -> void:
	spawnDeathParticles ()
	queue_free()
