extends CharacterBody3D

# emit when the player pops a bubble
signal spiked

var rotation_axis = Vector3(0, 0, 1) 
var rotation_amount = 0.1
var total_rotation = 0.0
var camera_pos = 0
var spike_name = "default"


func touched_spike():
	print("touched spike: ", spike_name, "!")
	# set the mesh to invisible so it is not still visible when the bubble is popping
	#$MeshInstance3D.visible = false

	spiked.emit()
	
# rotate sprite by certain amount of radians (probably) while it keeps looking at the camera
func initialize(start_position: Vector3, _rotation_amount: float, _spike_name) -> void:
	position = start_position
	spike_name = _spike_name
	#print(bubble_name)
	# defer because camera doesnt exist yet (might not be necessary, this is a manual billboarding)
	call_deferred("get_camera_pos_for_init",start_position, _rotation_amount)

func get_camera_pos_for_init(start_position: Vector3, _rotation_amount: float) -> void:
	camera_pos = get_viewport().get_camera_3d().global_transform.origin
	camera_pos.y = global_position.y
	look_at_from_position(start_position, camera_pos, Vector3.UP)
	
# rotate sprite by certain amount of radians (probably) while it keeps looking at the camera
func rotate_sprite(_rotation_amount: float):
	camera_pos = get_viewport().get_camera_3d().global_transform.origin
	camera_pos.y = global_position.y
	look_at(camera_pos, Vector3(0, 1, 0).rotated(rotation_axis, _rotation_amount))
	
