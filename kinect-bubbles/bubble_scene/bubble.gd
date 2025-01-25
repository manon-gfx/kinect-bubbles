extends CharacterBody3D

# emit when the player pops a bubble
signal popped(name)


func pop():
	#print("popped ", bubble_name, "!")
	# set the mesh to invisible so it is not still visible when the bubble is popping
	$MeshInstance3D.visible = false

	$AnimatedSprite3D.play("pop")
	popped.emit(name)

var camera_pos = 0
var radius = 1
var bubble_name = "default"

var acceleration = Vector3.ZERO
var drift = 50
var stiffness = 0.1
var rng = RandomNumberGenerator.new()

var target = Vector3.ZERO

# rotate sprite by certain amount of radians (probably) while it keeps looking at the camera
func initialize(start_position: Vector3, scale_factor: float, _bubble_name) -> void:
	position = start_position
	bubble_name = _bubble_name
	scale = Vector3(scale_factor, scale_factor, scale_factor)
	target = position

func _process(delta: float) -> void:
	target += drift * Vector3(rng.randfn(0.0, 1.0), rng.randfn(0.0, 1.0), 0.0) * delta
	
	var a = stiffness * (target - position)
	var dv = delta * a
	velocity += dv
	move_and_collide(dv)

func get_camera_pos_for_init(start_position: Vector3, radius: float) -> void:
	camera_pos = get_viewport().get_camera_3d().global_transform.origin
	camera_pos.y = global_position.y
	look_at_from_position(start_position, camera_pos, Vector3.UP)

# remove the node from memory after the animation has finished playing
func _on_animated_sprite_3d_animation_finished() -> void:
	queue_free()
