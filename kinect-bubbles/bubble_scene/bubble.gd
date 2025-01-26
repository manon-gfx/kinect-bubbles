extends CharacterBody3D

# emit when the player pops a bubble
signal popped(increment_score)

var is_popped = false

func pop(increment_score=true):
	# skip double pops
	if is_popped:
		return

	# set the mesh to invisible so it is not still visible when the bubble is popping
	$MeshInstance3D.visible = false

	$AudioStreamPlayer.pitch_scale = 1.6 - scale.x # 0.7 to 1.5
	$AudioStreamPlayer.play()

	$AnimatedSprite3D.play("pop")
	
	is_popped = true

	popped.emit(increment_score)

var bubble_name = "default"

var drift = 50
var stiffness = 0.1
var rng = RandomNumberGenerator.new()
var target = Vector3(0, 10, 3)

# rotate sprite by certain amount of radians (probably) while it keeps looking at the camera
func initialize(start_position: Vector3, scale_factor: float, _bubble_name) -> void:
	position = start_position
	bubble_name = _bubble_name
	scale = Vector3(scale_factor, scale_factor, scale_factor)
	collision_layer = 2
	collision_mask = 1
	

func _physics_process(delta: float) -> void:
	target += drift * Vector3(rng.randfn(0.0, 1.0), rng.randfn(0.0, 1.0), 0.0) * delta
	
	var a = stiffness * (target - position)
	var dv = delta * a
	velocity += dv
	var collision = move_and_collide(dv)

	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("spiky_object"):
			pop(false)
			
	if target.x < -40 or target.x > 40 or target.y < -5 or target.y > 40:
		if position.x < -40 or position.x > 40 or position.y < -5 or position.y > 40:
			queue_free()

# remove the node from memory after the animation has finished playing
func _on_animated_sprite_3d_animation_finished() -> void:
	queue_free()
