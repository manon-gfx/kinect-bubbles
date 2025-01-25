extends CharacterBody3D


func _physics_process(delta):
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
			$AnimatedSprite3D.play("pop")
