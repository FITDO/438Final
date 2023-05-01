extends BsEnemy

var player = null
var sniperShootCrash = preload("res://Prefabs/Enemy/SniperBulletCrash.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_child(0).get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if not player:
		return
	
	$RayCast3D.target_position = get_player_position ()
	
	var objectHit = $RayCast3D.get_collider ()
	
	if objectHit:
		
		if objectHit.get_collision_layer() == 4:
			if $ShootTime.is_stopped():
				$ShootTime.start()
		else:
			$ShootTime.stop()
		
		var selfPosition2D = Vector2 (self.get_global_position().z , self.get_global_position().x) 
		var playerPosition2D = Vector2 (player.position.z , player.position.x) 
		
		var angle = selfPosition2D.angle_to_point(playerPosition2D) + PI
		
		$LaserScaler.rotation.y = angle
		
		var distance = self.global_position.distance_to($RayCast3D.get_collision_point())
		
		$LaserScaler.scale.z = distance + .25
		
	else:
		$LaserScaler.scale.y = .01;
		$ShootTime.stop()
	


func get_player_position () -> Vector3:
	
	var sniperPos = self.global_position
	var playerPos = player.global_position
	
	var trueTarget = playerPos - sniperPos
	
	return trueTarget

func DeathEvent () -> void:
	spawnDeathParticles ()
	queue_free()

func _on_shoot_timer_timeout():
	player.TakeDamage(damage)
	
	var crash = sniperShootCrash.instantiate()
	
	crash.global_position = $RayCast3D.get_collision_point();
	
	get_tree().get_root().get_child(0).add_child(crash)
