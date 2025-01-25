extends Node

#@export var bubble_scene: PackedScene

var bubble_scene = preload("res://bubble_scene/bubble.tscn")
var spike_scene = preload("res://spiky_object_scenes/spiky_object.tscn")
var min_x
var max_x
var min_y
var max_y
var min_z
var max_z

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
	
func add_bubble_in_random_loc(rng):
		var bubble = bubble_scene.instantiate()
		spawn_location = Vector3(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y), Z_COORD_COLLIDERS)
		#print(spawn_location)
		# bubble initialize: pos, radius, name
		bubble.initialize(spawn_location, rng.randf_range(0.1,1.1), rng.randi())
		# Spawn the bubble by adding it to the Main scene.
		add_child(bubble)
		bubble.popped.connect($UserInterface._on_bubble_popped)

func add_spike_in_random_loc(rng):
		var spike = spike_scene.instantiate()
		spawn_location = Vector3(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y), Z_COORD_COLLIDERS)
		# bubble initialize: pos, radius, name
		spike.initialize(spawn_location, rng.randf_range(0.1,1.1), rng.randi())
		# Spawn the bubble by adding it to the Main scene.
		add_child(spike)
		spike.spiked.connect($UserInterface._on_spike_touched)
	

var random_chance = 0.0
func _on_bubble_and_spike_timer_timeout() -> void:
	#$BubbleAndSpikeTimer.wait_time = rng.randf_range(1,6)
	$BubbleAndSpikeTimer.wait_time = rng.randf_range(0,1)
	if rng.randf() > 0.8:
		add_spike_in_random_loc(rng)
	else:
		add_bubble_in_random_loc(rng)
	
