extends Node3D

func _ready():
	pass

func _on_death_timer_timeout():
	queue_free()
