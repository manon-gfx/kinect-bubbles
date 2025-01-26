extends CharacterBody3D

# emit when the player pops a bubble
signal spiked(name)

var camera_pos = 0
var spike_name = "default"

var rng = RandomNumberGenerator.new()
var direction = Vector3(rng.randfn(0.0, 1.0), rng.randfn(0.0, 1.0), 0.0).normalized()
var speed = 2.0

### Anneriet: for rotating sprites
var rotation_speed = 0.1

func touched_spike():
	print("touched spike: ", spike_name, "!")
	spiked.emit(name)
	
	
### Anneriet: added an additional rotation_speed parameter to initialize
func initialize(start_position: Vector3, scale_factor: float, _spike_name, _rotation_speed):
	spike_name = _spike_name
	position = start_position
	scale = Vector3(scale_factor, scale_factor, scale_factor)
	
	#Anneriet: for rotating sprites
	$Sprite3D.billboard = false
	rotation_speed = _rotation_speed


func _process(delta: float) -> void:
	if position.x < -40 or position.x > 40:
		direction.x = -direction.x
	if position.y < 0 or position.y > 40: 
		direction.y = -direction.y

	var dv = speed * direction * delta
	velocity += dv
	# Anneriet: for rotating sprites
	rotation += Vector3(0, 0, rotation_speed)
	move_and_collide(dv)
