extends Area3D

var joint_id = 0
var disabled = false

func _on_body_entered(body: Node) -> void:
	# Skip collisions if disabled
	if disabled:
		return;
	
	if body.is_in_group("bubble"):
			body.pop()

	if body.is_in_group("spiky_object"):
		body.touched_spike()
		var kinect_player = self.get_parent()
		kinect_player.pop_limb(self.joint_id)

func pop() -> void:
	disabled = true
	$CollisionShape3D.disabled = true # Doesn't seem to do anything?
	$AnimatedSprite3D.play("pop")
