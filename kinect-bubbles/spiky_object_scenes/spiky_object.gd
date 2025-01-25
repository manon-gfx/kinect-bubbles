extends CharacterBody3D

# emit when the player pops a bubble
signal spiked(name)

var rotation_axis = Vector3(0, 0, 1) 
var rotation_amount = 0.1
var total_rotation = 0.0
var camera_pos = 0
var spike_name = "default"


func touched_spike():
	print("touched spike: ", spike_name, "!")
	spiked.emit(name)
	

func initialize(start_position: Vector3, scale_factor: float, _spike_name):
	spike_name = _spike_name
	position = start_position
	scale = Vector3(scale_factor, scale_factor, scale_factor)
