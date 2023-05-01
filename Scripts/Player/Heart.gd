extends Area3D

@export var healamount : int = 2



func _on_body_entered(body):
	
	if body.get_collision_layer() == 4:
			body.Heal (healamount)
			queue_free()
