extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_velocity = 50

var target_velocity = Vector3.ZERO

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
		$pivot.basis = Basis.looking_at(direction)

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
			# we check that we are hitting it from above.
			#if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				#mob.squash()
				#target_velocity.y = bounce_impulse
				# Prevent further duplicate calls.
				#break
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
