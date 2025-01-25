extends CharacterBody3D

# emit when the player pops a bubble
signal popped


func pop():
	print("popped ", bubble_name, "!")
	$AnimatedSprite3D.play("pop")
	popped.emit()
	#print(get_parent().get_children())
	
	
#func _ready() -> void:
	##rotate_sprite(1)
	##pop()
	#pass

var rotation_axis = Vector3(0, 0, 1) 
var rotation_amount = 0.1
var total_rotation = 0.0
var camera_pos = 0
var bubble_name = "default"

# rotate sprite by certain amount of radians (probably) while it keeps looking at the camera
func initialize(start_position: Vector3, rotation_amount: float, bubble_name: String) -> void:
	position = start_position
	bubble_name = bubble_name
	print(bubble_name)
	
	# defer because camera doesnt exist yet
	#call_deferred("func get_camera_pos_for_inits",start_position, rotation_amount)

# does not work...
func get_camera_pos_for_init(start_position: Vector3, rotation_amount: float) -> void:
	camera_pos = get_viewport().get_camera_3d().global_transform.origin
	camera_pos.y = global_position.y
	look_at_from_position(start_position, camera_pos, Vector3.UP)
	
# rotate sprite by certain amount of radians (probably) while it keeps looking at the camera
func rotate_sprite(rotation_amount: float):
	camera_pos = get_viewport().get_camera_3d().global_transform.origin
	camera_pos.y = global_position.y
	look_at(camera_pos, Vector3(0, 1, 0).rotated(rotation_axis, total_rotation))
	
#func _process(delta: float) -> void:
	#rotate_sprite(total_rotation)
	#total_rotation += rotation_amount


func _on_animated_sprite_3d_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.
