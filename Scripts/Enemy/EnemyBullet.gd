extends RigidBody3D

var speed = 8;

var damage = 1;

var bulletCrashMaster = preload("res://Prefabs/Enemy/bullet_crash.tscn")

func _ready():
	pass

func _physics_process(delta):
	
	var horizontal_velocity = Vector3 (0 , -1 , 0).normalized() * speed
	var velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	var possible_collision = move_and_collide (velocity * delta)
	
	if possible_collision:
		var objectHit = possible_collision.get_collider()
		
		#player Layer
		if objectHit.get_collision_layer() == 4:
			objectHit.TakeDamage (damage)
		
		var crash = bulletCrashMaster.instantiate()
		
		crash.transform = self.global_transform
		
		get_parent().add_child(crash)
		
		queue_free()

func _on_death_timer_timeout():
	queue_free()
