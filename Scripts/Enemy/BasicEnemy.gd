extends CharacterBody3D

class_name BsEnemy

@export_category("Enemy Values")

@export var health : int = 3
@export var damage : int = 1

var deathParticlemaster = preload("res://Prefabs/Enemy/EnemyDealth.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func TakeDamage (damagetaken) -> void:
	health = health - damagetaken
	
	if health < 1:
		DeathEvent ()

func DeathEvent () -> void:
	printerr ("Method Not Defined: DeathEvent")

func spawnDeathParticles () -> void:
	var deathParticles = deathParticlemaster.instantiate ()
	
	deathParticles.transform = self.global_transform
	
	get_tree().get_root().get_child(0).add_child(deathParticles)
	
