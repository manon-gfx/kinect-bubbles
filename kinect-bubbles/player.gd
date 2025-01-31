extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_velocity = 50


var kinect_body_node = preload("res://kinect_body_node/kinect_body_node.tscn")
var target_velocity = Vector3.ZERO

func _ready() -> void:
	$pivot.queue_free()
	#$pivot/top.queue_free()
	#$pivot/mid.queue_free()
	#$pivot/bottom.queue_free()
	#$CollisionShape3D.queue_free()
	for joint_id in range(3):			
		var joint = kinect_body_node.instantiate()
		joint.name = "Joint" + str(joint_id)
		joint.position = Vector3(0, joint_id, 0)
		add_child(joint)
		#var collisionShape = CollisionShape3D.new()
		#collisionShape.shape = joint.get_node("CollisionShape3D").shape
		#add_child(collisionShape)
		
	
	
func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#$pivot.basis = Basis.looking_at(direction)

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			target_velocity.y = jump_velocity
			
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)

		# If the collision is with ground
		if collision.get_collider() == null:
			continue

		# If the collider is with a mob
		if collision.get_collider().is_in_group("bubble"):
			var bubble = collision.get_collider()
			bubble.pop()
		
		if collision.get_collider().is_in_group("spiky_object"):
			var spike = collision.get_collider()
			spike.touched_spike()
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
