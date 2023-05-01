extends RigidBody3D

var speed = 15;

var damage = 3;

func _ready():
	pass

func _physics_process(delta):
	
	var horizontal_velocity = Vector3 (0 , -1 , 0).normalized() * speed
	var velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	var possible_collision = move_and_collide (velocity * delta)
	
	if possible_collision:
		var objectHit = possible_collision.get_collider()
		
		#Enemy Layer
		if objectHit.get_collision_layer() == 16:
			objectHit.TakeDamage(damage)
		
		queue_free()


func _on_life_timer_timeout():
	queue_free()
