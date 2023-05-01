extends StaticBody3D

class_name FireWall

@export var activate_on_start : bool = false
var currentVector

# Called when the node enters the scene tree for the first time.
func _ready():
	
	currentVector = self.position
	
	if activate_on_start:
		activate ()
	else:
		deactivate ()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate () -> void:
	self.position.x = currentVector.x
	self.position.y = currentVector.y
	self.position.z = currentVector.z
	$GPUParticles3D.emitting = true

func deactivate () -> void:
	self.position.x = currentVector.x
	self.position.y = currentVector.y - 500
	self.position.z = currentVector.z
	$GPUParticles3D.emitting = false
