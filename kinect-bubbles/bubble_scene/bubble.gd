extends CharacterBody3D

func pop():
	$AnimatedSprite3D.play("pop")
	
func _ready() -> void:
	#pop()
	#rotate_sprite(1)
	pass
#
var rotation_axis = Vector3(0, 0, 1) 
var rotation_amount = 0.1
var total_rotation = 0.0
var camera_pos = 0

# rotate sprite by certain amount of radians (probably) while it keeps looking at the camera
func rotate_sprite(rotation_amount: float):
	camera_pos = get_viewport().get_camera_3d().global_transform.origin
	camera_pos.y = global_position.y
	look_at(camera_pos, Vector3(0, 1, 0).rotated(rotation_axis, total_rotation))
	
#func _process(delta: float) -> void:
	#rotate_sprite(total_rotation)
	#total_rotation += rotation_amount
