extends Area3D

var joint_id = 0
var disabled = false
var target_scale = 1.0

func _on_body_entered(body: Node) -> void:
	print("body entered: ", body.get_groups())
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
	var real_target_scale = target_scale
	var kinect_player = self.get_parent()
	if kinect_player.name == "KinectPlayer": # WTF Godot
		real_target_scale = target_scale * kinect_player.player_size

	set_scale(scale.lerp(Vector3(real_target_scale, real_target_scale, real_target_scale), delta))

func pop() -> void:
	disabled = true
	$CollisionShape3D.disabled = true # Doesn't seem to do anything?
	$AnimatedSprite3D.play("pop")

func spawn() -> void:
	set_scale(Vector3.ZERO)
	$AnimatedSprite3D.play("default")
	disabled = false
	$CollisionShape3D.disabled = false # Doesn't seem to do anything?


func _on_area_entered(area: Area3D) -> void:
	print("area entered: ", area)
	pass # Replace with function body.
