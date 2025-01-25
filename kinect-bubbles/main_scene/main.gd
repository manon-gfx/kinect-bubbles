extends Node

#@export var bubble_scene: PackedScene

var bubble_scene = preload("res://bubble_scene/bubble.tscn")
var spike_scene = preload("res://spiky_object_scenes/spiky_object.tscn")
var cactus_03_scene = preload("res://spiky_object_scenes/cactus_03.tscn")
var pint_2_scene = preload("res://spiky_object_scenes/pint_2.tscn")
var min_x
var max_x
var min_y
var max_y
var min_z
var max_z
var offset = 2

var number_of_bubbles = 10
var number_of_spikes = 5

var spawn_location = Vector3(2, 5, 3)
var bubble_radius = 1.8

var esc_pressed_once = false

const Z_COORD_COLLIDERS = 3


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if (esc_pressed_once):
				get_tree().quit()
			else:
				esc_pressed_once = true
		elif event.keycode != KEY_ESCAPE:
			esc_pressed_once = false
			
		
var rng: RandomNumberGenerator
	
func _ready() -> void:
	var shape_box = $BubbleArea/CollisionShape3D.shape.size
	var pos_box = $BubbleArea/CollisionShape3D.position
	min_x = pos_box[0]-shape_box[0] + bubble_radius
	max_x = pos_box[0]+shape_box[0] - bubble_radius
	min_y = pos_box[1]-shape_box[1] + bubble_radius
	max_y = pos_box[1]+shape_box[1] - bubble_radius
	min_z = pos_box[2]-shape_box[2] + bubble_radius
	max_z = pos_box[2]+shape_box[2] - bubble_radius
	
	rng = RandomNumberGenerator.new()

	for i in range(number_of_bubbles):
		add_bubble_in_random_loc(rng)
	
	for i in range(number_of_spikes):
		add_spike_in_random_loc(rng)
	if not $KinectPlayer.has_a_kinect:
		$player.queue_free()

func calc_spawn_location(rng):
	match rng.randi() % 4:
		0:
			spawn_location = Vector3(min_x - offset, rng.randf_range(min_y, max_y), Z_COORD_COLLIDERS)
		1:
			spawn_location = Vector3(max_x + offset, rng.randf_range(min_y, max_y), Z_COORD_COLLIDERS)
		2:
			spawn_location = Vector3(rng.randf_range(min_x, max_x), min_y - offset, Z_COORD_COLLIDERS)
		3:
			spawn_location = Vector3(rng.randf_range(min_x, max_x), max_y + offset, Z_COORD_COLLIDERS)

	return spawn_location

func add_bubble_in_random_loc(rng):
	# bubble initialize: pos, radius, name
	var bubble = bubble_scene.instantiate()
	bubble.initialize(calc_spawn_location(rng), rng.randf_range(0.2,1.0), rng.randi())

	# Spawn the bubble by adding it to the Main scene.
	add_child(bubble)
	bubble.popped.connect($UserInterface._on_bubble_popped)

func add_spike_in_random_loc(rng):
	# bubble initialize: pos, radius, name
	var spiky = 0
	var randomnum = rng.randf()
	if randomnum > 0.67:
		spiky = spike_scene.instantiate()
	elif randomnum > 0.33:
		spiky = cactus_03_scene.instantiate()
	else:
		spiky = pint_2_scene.instantiate()
	spiky.initialize(calc_spawn_location(rng), rng.randf_range(0.2,0.6), rng.randi())
	


	# Spawn the bubble by adding it to the Main scene.
	add_child(spiky)
	spiky.spiked.connect($UserInterface._on_spike_touched)
	

func _on_bubble_and_spike_timer_timeout() -> void:
	#$BubbleAndSpikeTimer.wait_time = rng.randf_range(1,6)
	$BubbleAndSpikeTimer.wait_time = rng.randf_range(0,1)
	if rng.randf() > 0.8:
		add_spike_in_random_loc(rng)
	else:
		add_bubble_in_random_loc(rng)
	
