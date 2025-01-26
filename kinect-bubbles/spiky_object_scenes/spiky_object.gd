extends CharacterBody3D

# emit when the player pops a bubble
signal spiked(name)

var camera_pos = 0
var spike_name = "default"

var rng = RandomNumberGenerator.new()
var direction = Vector3.UP
var speed = 2.0
var rotating = true
var rot_speed = 2.0

var current_rotation = 0.0

func touched_spike():
	spiked.emit(name)


func initialize(
	start_position: Vector3,
	scale_factor: float,
	_spike_name):
	spike_name = _spike_name
	position = start_position
	scale = Vector3(scale_factor, scale_factor, scale_factor)
	collision_mask = 1

func _process(delta: float) -> void:
	# if can_bounce:
	# 	if position.x < -40 or position.x > 40:
	# 		direction.x = -direction.x
	# 	if position.y < 0 or position.y > 40:
	# 		direction.y = -direction.y`
	if rotating:
		current_rotation += delta * rot_speed
	else:
		current_rotation = atan2(direction.y, direction.x) - (PI * 0.5)
	set_rotation(Vector3(0.0, 0.0, current_rotation))

func _physics_process(delta: float) -> void:
	var dv = speed * direction * delta
	velocity += dv
	var collision = move_and_collide(dv)

	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("bubble"):
			collider.pop(false)
