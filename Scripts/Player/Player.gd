extends CharacterBody3D

@export_group ("Player Variables")

@export var maxHealth : int = 5
@export var currentHealth : int = 5

@export_group ("Player Movement")

@export var speed : float = 7
@export var jump_velocity : float = 4.5

@export_group ("Player Dodge")

@export var dodgeMultiple : float = 2.5
@export var dodgeTime : float = .6
@export var dodgeRefreshTime : float = 2.0

@export_group ("Player Arrow")

var maxArrows : int = 3
var currentArrowCount : int = 3

@export var arrowChargeTime : float = .8


@export_group ("Player Components")

@export var playerCamera : Camera3D = null
@export var mouseMarker : Decal = null

var gameUI = null
var arrowMaster = null

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity_y : float = 0

var rayOrigin = Vector3()
var rayEnd = Vector3()

enum playerState { IDLE = 0 , WALKING = 1 , DODGEING = 2 , CHARGINGSHOT = 3}

var currentState

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gameUI = get_parent().get_node("GameHud")
	
	arrowMaster = preload("res://Prefabs/Player/arrow.tscn")
	
	currentState = playerState.IDLE
	

func _physics_process(delta):
	
	
	match (currentState):
		playerState.IDLE:
			self._Idle (delta)
		playerState.WALKING:
			self._Walking (delta)
		playerState.DODGEING:
			self._Dodgeing (delta)
		playerState.CHARGINGSHOT:
			self._ChargeShot (delta)

func _Idle (delta):
	
	if Input.is_action_just_pressed("move_dodge"):
		_startDodge ()
		return;
	else:
		_playerMovement (delta)
	
	if (velocity != Vector3.ZERO):
		currentState = playerState.WALKING
	
	_playerFacing (delta)
	
	if Input.is_action_just_pressed("swing_sword"):
		$RotationHead/SwordPoint.swingSword()
	
	if Input.is_action_just_pressed("fire_arrow") and currentArrowCount > 0:
		_StartChargeShot ()
		return;

func _Walking (delta):
	
	_playerMovement (delta)
	
	if (velocity == Vector3.ZERO):
		currentState = playerState.IDLE
	
	_playerFacing (delta)
	
	if Input.is_action_just_pressed("swing_sword"):
		$RotationHead/SwordPoint.swingSword()
	
	if Input.is_action_just_pressed("fire_arrow") and currentArrowCount > 0:
		_StartChargeShot ()
		return;
		
	if Input.is_action_just_pressed("move_dodge") and $Timers/DodgeRefreshTimer.is_stopped():
		_startDodge ()
		return;

func _startDodge ():
	$Timers/DodgeRollTimer.start(dodgeTime)
	$Timers/DodgeRefreshTimer.start(dodgeRefreshTime)
	
	var horizontal_velocity = Input.get_vector("move_left" ,"move_right" , "move_forward" , "move_backward").normalized() * speed * dodgeMultiple
	
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	gameUI.HideDodge()
	currentState = playerState.DODGEING

func _Dodgeing (delta):
	
	if (is_on_floor()):
		velocity_y = 0
	else:
		velocity_y -= gravity * delta
	
	move_and_slide ()
	
	checkForCollisions ()
	
	_playerFacing (delta)
	
	if $Timers/DodgeRollTimer.is_stopped():
		currentState = playerState.IDLE

func _StartChargeShot ():
	
	velocity.x = 0
	velocity.z = 0
	
	$Timers/ArrowChargeTimer.start(arrowChargeTime)
	currentState = playerState.CHARGINGSHOT

func _ChargeShot (delta):
	
	_playerFacing (delta)
	
	if (is_on_floor()):
		velocity_y = 0
	else:
		velocity_y -= gravity * delta
		
	velocity.y = velocity_y
	
	move_and_slide()
	
	checkForCollisions ()
	
	if Input.is_action_just_pressed("move_dodge"):
		$ArrowLight.hide()
		_startDodge()
		return;
	
	
	if Input.is_action_just_released("fire_arrow"):
		if $Timers/ArrowChargeTimer.is_stopped():
			var arrowInst = arrowMaster.instantiate()
			
			arrowInst.transform = $RotationHead/ArrowSpawner.global_transform
			
			get_parent().add_child(arrowInst)
			
			currentArrowCount = currentArrowCount - 1;
			
			gameUI.UpdateArrows(currentArrowCount)
			
			$Sounds/ArrowSound.play()
		
		$ArrowLight.hide()
		currentState = playerState.IDLE

func _playerMovement (delta):
	
	var horizontal_velocity = Input.get_vector("move_left" ,"move_right" , "move_forward" , "move_backward").normalized() * speed
	
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	
	if (is_on_floor()):
		velocity_y = 0
	else:
		velocity_y -= gravity * delta
		
	velocity.y = velocity_y
	
	move_and_slide()
	
	checkForCollisions ()

func checkForCollisions ():
	
	var possible_collision = self.get_last_slide_collision()
	
	if possible_collision:
		var objecthit = possible_collision.get_collider()
		
		if objecthit.get_collision_layer() == 16:
			self.TakeDamage(1)
			objecthit.TakeDamage(1)

func _playerFacing (delta):
	
	var space_state = get_world_3d().direct_space_state
	
	var mouse_position = get_viewport().get_mouse_position();
	
	if mouse_position == null:
		return;
	
	rayOrigin = playerCamera.project_ray_origin(mouse_position)
	
	rayEnd = rayOrigin + playerCamera.project_ray_normal(mouse_position) * 2000
	
	var prqp = PhysicsRayQueryParameters3D.create (rayOrigin , rayEnd)
	
	var intersection = space_state.intersect_ray(prqp)
	
	if not intersection.is_empty():
		var pointPos2D = Vector2 (intersection.position.z , intersection.position.x) 
		var playerPosition2D = Vector2 (self.get_global_position().z , self.get_global_position().x) 
		
		var angel = playerPosition2D.angle_to_point(pointPos2D) + PI
		
		mouseMarker.rotation.y = angel
		
		mouseMarker.position.x = intersection.position.x
		mouseMarker.position.y = intersection.position.y
		mouseMarker.position.z = intersection.position.z
		
		$RotationHead.rotation.y = angel
	else:
		
		mouseMarker.position.x = 0
		mouseMarker.position.y = -100
		mouseMarker.position.z = 0

func add_arrow (amount) -> void:
	currentArrowCount = currentArrowCount + amount
	
	if currentArrowCount > maxArrows:
		currentArrowCount = maxArrows
	
	gameUI.UpdateArrows(currentArrowCount)

func TakeDamage (damage) -> void:
	self.currentHealth = self.currentHealth - damage
	
	gameUI.UpdateHealth (self.currentHealth)
	
	if currentHealth < 1:
		get_tree().change_scene_to_file ("res://Scenes/GameScenes/game_over_scene.tscn")

func Heal (amount) -> void:
	
	self.currentHealth = self.currentHealth + amount
	
	if currentHealth > maxHealth:
		currentHealth = maxHealth
	
	gameUI.UpdateHealth (self.currentHealth)

func _on_dodge_refresh_timer_timeout ():
	gameUI.ShowDodge()


func _on_arrow_charge_timer_timeout():
	if currentState == playerState.CHARGINGSHOT:
		$ArrowLight.show()
