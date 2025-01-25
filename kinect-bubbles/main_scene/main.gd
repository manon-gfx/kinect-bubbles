extends Node


@export var bubble_scene: PackedScene

var max_size_x
var max_size_y
var max_size_z

var number_of_bubbles = 1
func _ready() -> void:
	var bubble = bubble_scene.instantiate()
		# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	#var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	#mob_spawn_location.progress_ratio = randf()
	var spawn_location = Vector3(2, 5, 3)

	#var player_position = $Player.position
	bubble.initialize(spawn_location, 0, "made bubble")

	# Spawn the mob by adding it to the Main scene.
	add_child(bubble)
	#pass
	
	
