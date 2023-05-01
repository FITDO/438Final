extends Node3D

var ghostEnemy = preload("res://Prefabs/Enemy/GhostEnemy.tscn")
var shooterEnemy = preload("res://Prefabs/Enemy/ShooterEnemy.tscn")
var sniperEnemy = preload("res://Prefabs/Enemy/SniperEnemy.tscn")
var tankEnemy = preload("res://Prefabs/Enemy/TankEnemy.tscn")

func _ready():
	$TriggerBox.connect ("body_entered" , _on_trigger_box_body_entered)

func _process(delta):
	
	if $SpawnedEnemies.get_child_count() == 0:
		for firewall in $Firewalls.get_children():
			firewall.deactivate ()


func _on_trigger_box_body_entered (body) -> void:
	print ("trigger was entered")
	
	var keepGoing = true
	
	var element = null
	var count = 0
	
	for firewall in $Firewalls.get_children():
		firewall.activate ()
	
	spawnEnemies ()
	
	$TriggerBox.queue_free()

func spawnEnemies () -> void:
	
	readspawnNode (ghostEnemy , $EnemySpawn/GhostEnemies.get_children())
	readspawnNode (shooterEnemy , $EnemySpawn/ShooterEnemies.get_children())
	readspawnNode (sniperEnemy , $EnemySpawn/SniperEnemies.get_children())
	readspawnNode (tankEnemy , $EnemySpawn/TankEnemies.get_children())
	
	
	print ("Spawning")

func readspawnNode (enemyType , spawnArray):
	
	var enemy = null
	
	for spawnlocation in spawnArray:
		
		enemy = enemyType.instantiate()
		
		enemy.transform = spawnlocation.transform
		
		$SpawnedEnemies.add_child(enemy)
