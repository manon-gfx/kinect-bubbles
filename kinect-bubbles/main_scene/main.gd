extends Node

#@export var bubble_scene: PackedScene

var bubble_scene = preload("res://bubble_scene/bubble.tscn")
var broken_bottle_scene = preload("res://spiky_object_scenes/broken_bottle.tscn")
var cactus_01_scene = preload("res://spiky_object_scenes/cactus_01.tscn")
var cactus_02_scene = preload("res://spiky_object_scenes/cactus_02.tscn")
var cactus_03_scene = preload("res://spiky_object_scenes/cactus_03.tscn")
var knife_scene = preload("res://spiky_object_scenes/knife.tscn")
var nail_in_wood_scene = preload("res://spiky_object_scenes/nail_in_wood.tscn")
var spike_scene = preload("res://spiky_object_scenes/spiky_object.tscn")
var pint_scene = preload("res://spiky_object_scenes/pint.tscn")
var pint_2_scene = preload("res://spiky_object_scenes/pint_2.tscn")
var thorn_scene = preload("res://spiky_object_scenes/thorn.tscn")

const BROKEN_BOTTLE = 0
const CACTUS1= 1
const CACTUS2 = 2
const CACTUS3 = 3
const KNIFE = 4
const NAIL_IN_WOOD = 5
const SPIKE = 6
const PINT = 7
const PINT2 = 8
#const THORN = 9
const SPIKY_COUNT = 9

const SPIKY_CATEGORY_PIN = 0
const SPIKY_CATEGORY_CACTUS = 1
const SPIKY_CATEGORY_OTHER = 2

func spiky_type_to_cat(spiky_type):
	if spiky_type == PINT || spiky_type == PINT2 || spiky_type == KNIFE:
		return SPIKY_CATEGORY_PIN
	elif spiky_type == CACTUS1 || spiky_type == CACTUS2 || spiky_type == CACTUS3:
		return SPIKY_CATEGORY_CACTUS
	else:
		return SPIKY_CATEGORY_OTHER

var list_of_spiky_objects = [
	broken_bottle_scene,
	cactus_01_scene,
	cactus_02_scene,
	cactus_03_scene,
	knife_scene,
	nail_in_wood_scene,
	spike_scene,
	pint_scene,
	pint_2_scene,
	#thorn_scene
]
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

		### Anneriet: reset everything on pressing space (no need to go to game over screen first)
		if event.pressed and event.keycode == KEY_SPACE:
			get_tree().reload_current_scene()


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

	const MAGIC_Z = 32.596; # emperically found
	var min_bounds = $Camera3D.project_position(Vector2.ZERO, MAGIC_Z)
	var max_bounds = $Camera3D.project_position($Camera3D.get_viewport().size, MAGIC_Z)
	min_x = min_bounds.x
	max_x = max_bounds.x
	min_y = max_bounds.y # note these are swapped, not a bug
	max_y = min_bounds.y

	print(min_y)
	print(max_y)


	rng = RandomNumberGenerator.new()

	for i in range(number_of_bubbles):
		add_bubble_in_random_loc(rng)
#
	#for i in range(number_of_spikes):
		#add_spike_in_random_loc(rng)
	if not $KinectPlayer.has_a_kinect:
		$player.queue_free()

	### Anneriet new: For showing game over
	$KinectPlayer.game_over.connect($UserInterface.show_game_over)

func calc_spawn_location(rng):
	match rng.randi() % 3:
		0: # Left
			spawn_location = Vector3(min_x - offset, rng.randf_range(min_y, max_y), Z_COORD_COLLIDERS)
		1: # Right
			spawn_location = Vector3(max_x + offset, rng.randf_range(min_y, max_y), Z_COORD_COLLIDERS)
		2: # Top
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
	var spiky_type = rng.randi_range(0, SPIKY_COUNT - 1)
	var spiky_cat = spiky_type_to_cat(spiky_type)
	var spiky = list_of_spiky_objects[spiky_type].instantiate()

	var spawn_location = Vector3.ZERO # invalid
	var spawn_direction = Vector3.ZERO

	var center_x = (min_x + max_x) * 0.5
	var center_y = (min_y + max_y) * 0.5
	var center = Vector3(center_x, center_y, Z_COORD_COLLIDERS);


	var side = rng.randi() % 3
	var target = center + Vector3(rng.randf_range(-15.0, 15.0), -4.0, 0.0)
	match side:
		0: # Left
			spawn_location = Vector3(min_x - offset, rng.randf_range(min_y + 10.0, max_y), Z_COORD_COLLIDERS)
			target = center + Vector3(rng.randf_range(-15.0, 0.0), -4.0, 0.0)
		1: # Right
			spawn_location = Vector3(max_x + offset, rng.randf_range(min_y + 10.0, max_y), Z_COORD_COLLIDERS)
			target = center + Vector3(rng.randf_range(0.0, 15.0), -4.0, 0.0)
		2: # Top
			spawn_location = Vector3(rng.randf_range(min_x, max_x), max_y + offset, Z_COORD_COLLIDERS)

	spawn_direction = (target - spawn_location).normalized()

	spiky.initialize(
		spawn_location,
		#calc_spawn_location(rng),
		0.2,
		rng.randi()
	)
	spiky.direction = spawn_direction

	if spiky_cat == SPIKY_CATEGORY_PIN:
		spiky.speed = 4.0
		spiky.rotating = false
	else:
		spiky.speed = 2.0
		var rotspd = rng.randf_range(3.0, 5.0)
		if rng.randi() % 2 == 0:
			rotspd = -rotspd
		spiky.rot_speed = rotspd

	#spiky.speed = 0.0

	# Spawn the bubble by adding it to the Main scene.
	add_child(spiky)
	spiky.spiked.connect($UserInterface._on_spike_touched)

func _on_spike_timer_timeout() -> void:
	$SpikeTimer.wait_time = rng.randf_range(4.0, 6.0)
	add_spike_in_random_loc(rng)

func _on_bubble_timer_timeout() -> void:
	#$BubbleAndSpikeTimer.wait_time = rng.randf_range(1,6)
	$BubbleTimer.wait_time = rng.randf_range(1.0, 2.0)
	add_bubble_in_random_loc(rng)
