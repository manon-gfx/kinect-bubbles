extends Area3D

var joint_id = 0
var disabled = false
var target_scale = 1.0

func _on_body_entered(body: Node) -> void:
	# Skip collisions if disabled
	if disabled:
		return;
	
	if body.is_in_group("bubble"):
		if !body.is_popped: #skip double pops
			body.pop()
			var kinect_player = self.get_parent()
			if kinect_player.name == "KinectPlayer": # WTF Godot
				kinect_player.restore_limb()

	if body.is_in_group("spiky_object"):
		body.touched_spike()
		var kinect_player = self.get_parent()
		if kinect_player.name == "KinectPlayer": # WTF Godot
			kinect_player.pop_limb(self.joint_id)

func _process(delta: float) -> void:
	set_scale(scale.lerp(Vector3(target_scale, target_scale, target_scale), delta))

func pop() -> void:
	disabled = true
	$CollisionShape3D.disabled = true # Doesn't seem to do anything?
	$AnimatedSprite3D.play("pop")

func spawn() -> void:
	set_scale(Vector3.ZERO)
	$AnimatedSprite3D.play("default")
	disabled = false
	$CollisionShape3D.disabled = false # Doesn't seem to do anything?
