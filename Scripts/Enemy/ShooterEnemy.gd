extends BsEnemy

var player = null

var bulletMaster

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_child(0).get_node("Player")
	bulletMaster = preload("res://Prefabs/Enemy/EnemyBullet.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_facePlayer (delta)


func DeathEvent () -> void:
	spawnDeathParticles ()
	queue_free()

func _facePlayer (delta):
	
	if player:
		var selfPosition2D = Vector2 (self.get_global_position().z , self.get_global_position().x) 
		var playerPosition2D = Vector2 (player.get_global_position().z , player.get_global_position().x) 
		
		var angle = selfPosition2D.angle_to_point(playerPosition2D) + PI
		
		$RotationHead.rotation.y = angle
		
	else:
		print ("Player Has Died")
		# Reload scene


func _on_shoot_timer_timeout():
	
	var bulletInst = bulletMaster.instantiate()
	
	bulletInst.global_transform = $RotationHead/BulletSpawner.global_transform
	
	get_tree().get_root().get_child(0).add_child(bulletInst)
	
	$ShootSound.play()
