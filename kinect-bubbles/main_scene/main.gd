extends Node

#@export var bubble_scene: PackedScene

var bubble_scene = preload("res://bubble_scene/bubble.tscn")
var min_x
var max_x
var min_y
var max_y
var min_z
var max_z

var number_of_bubbles = 5

var spawn_location = Vector3(2, 5, 3)
var bubble_radius = 1.8

var esc_pressed_once = false
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if (esc_pressed_once):
				get_tree().quit()
			else:
				esc_pressed_once = true
		elif event.keycode != KEY_ESCAPE:
			esc_pressed_once = false
			
			
func _ready() -> void:
	var shape_box = $BubbleArea/CollisionShape3D.shape.size
	var pos_box = $BubbleArea/CollisionShape3D.position
	min_x = pos_box[0]-shape_box[0] + bubble_radius
	max_x = pos_box[0]+shape_box[0] - bubble_radius
	min_y = pos_box[1]-shape_box[1] + bubble_radius
	max_y = pos_box[1]+shape_box[1] - bubble_radius
	min_z = pos_box[2]-shape_box[2] + bubble_radius
	max_z = pos_box[2]+shape_box[2] - bubble_radius
	
	var rng = RandomNumberGenerator.new()

	var my_random_number = rng.randf_range(-10.0, 10.0)
	
	for i in range(number_of_bubbles):
		
		var bubble = bubble_scene.instantiate()
		spawn_location = Vector3(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y), rng.randf_range(min_z, max_z))
		bubble.initialize(spawn_location, 0, i)
		# Spawn the bubble by adding it to the Main scene.
		add_child(bubble)
	#pass
	
	
