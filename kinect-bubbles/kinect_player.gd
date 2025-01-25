extends Node3D

var has_a_kinect = false
var rng = RandomNumberGenerator.new()

const VISUAL_COUNT = 16

var kinect_node = null;
var player_size = 5.0
var bones = [
	# core
	[KinectBody.JointID_SpineBase, KinectBody.JointID_SpineMid],
	[KinectBody.JointID_SpineMid, KinectBody.JointID_Neck],
	[KinectBody.JointID_Neck, KinectBody.JointID_Head],

	#left arm and shoulder
	[KinectBody.JointID_SpineMid, KinectBody.JointID_ShoulderLeft],
	[KinectBody.JointID_ShoulderLeft, KinectBody.JointID_ElbowLeft],
	[KinectBody.JointID_ElbowLeft, KinectBody.JointID_WristLeft],
	[KinectBody.JointID_WristLeft, KinectBody.JointID_HandLeft],

	#left arm and shoulder
	[KinectBody.JointID_SpineMid, KinectBody.JointID_ShoulderRight],
	[KinectBody.JointID_ShoulderRight, KinectBody.JointID_ElbowRight],
	[KinectBody.JointID_ElbowRight, KinectBody.JointID_WristRight],
	[KinectBody.JointID_WristRight, KinectBody.JointID_HandRight],

	# left leg
	[KinectBody.JointID_SpineMid, KinectBody.JointID_HipLeft],
	[KinectBody.JointID_HipLeft, KinectBody.JointID_KneeLeft],
	[KinectBody.JointID_KneeLeft, KinectBody.JointID_AnkleLeft],
	[KinectBody.JointID_AnkleLeft, KinectBody.JointID_FootLeft],

	# right leg
	[KinectBody.JointID_SpineMid, KinectBody.JointID_HipRight],
	[KinectBody.JointID_HipRight, KinectBody.JointID_KneeRight],
	[KinectBody.JointID_KneeRight, KinectBody.JointID_AnkleRight],
	[KinectBody.JointID_AnkleRight, KinectBody.JointID_FootRight],
]


var joint_positions = []

var kinect_body_node = preload("res://kinect_body_node/kinect_body_node.tscn")
var player_bubble_visual = preload("res://player_bubble_visual/player_bubble_visual.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.set_seed(hash("manon"));
	var root = get_tree().root.get_child(0)

	for i in range(KinectBody.JointID_Count):
		joint_positions.append(Vector3(0, 0, 0))

	for child in root.get_children():
		print(child.name)
		if child.is_class("KinectNode"):
			self.kinect_node = child as KinectNode
			break

	if self.kinect_node == null:
		print("failed to find the kinect node :(")
	else:
		has_a_kinect = true
		for i in range(KinectBody.JointID_Count):
			var bubble = kinect_body_node.instantiate()
			bubble.name = "Bubble_" + str(i)
			if i == KinectBody.JointID_Head:
				bubble.scale = Vector3(2.0, 2.0, 2.0)
			add_child(bubble)

		for bone_index in range(bones.size()):
			for i in range(VISUAL_COUNT):
				var bubble = player_bubble_visual.instantiate()
				bubble.name = "VisualBubble_" + str(bone_index) + "_" + str(i)
				var s = rng.randf_range(0.2, 0.5)
				bubble.scale = Vector3(s, s, s);
				bubble.tangent_offset = i / (VISUAL_COUNT as float)
				bubble.bitangent_offset = rng.randf_range(-0.4, 0.4)

				add_child(bubble)
		# Debug ground plane
		# var plane_mesh = PlaneMesh.new()
		# var plane = MeshInstance3D.new()
		# plane.name = "Ground"
		# plane.mesh = plane_mesh
		# plane.set_position(Vector3(1, 1, 1))
		# add_child(plane)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.kinect_node != null:
		var body = self.kinect_node.get_body(0) as KinectBody

		# Acquire ground plane from the kinect
		var plane_direction = Vector3(
			body.ground_plane.x, body.ground_plane.y, body.ground_plane.z);
		var plane_offset = -plane_direction * body.ground_plane.w

		# var ground = self.get_node("Ground");
		# ground.set_position(plane_offset)
		# ground.look_at(plane_offset + plane_direction, Vector3.UP)

		# Update joints
		for joint_id in range(KinectBody.JointID_Count):
			var kin_pos = body.get_joint_position(joint_id) - plane_offset
			var scene_pos = kin_pos * player_size
			scene_pos.z += 22.0

			var prev_pos = joint_positions[joint_id];

			var diff = (scene_pos - prev_pos) * 20.0;
			if diff.length() > 20.0:
				diff = diff.normalized() * 20.0;
			var pos = prev_pos + diff * delta;
			joint_positions[joint_id] = pos

			var bubble = self.get_node("Bubble_" + str(joint_id))
			bubble.set_position(pos)

		for bone_index in range(bones.size()):
			var a = joint_positions[bones[bone_index][0]]
			var b = joint_positions[bones[bone_index][1]]
			#for i in range(2):
				#var t = i / 2.0
				#var pos = a * (1 - t) + b * t
				## var bubble = kinect_body_node.instantiate()
				#var bubble = self.get_node("Bubble_" + str(bone_index) + "_" + str(i))
				#bubble.set_position(pos)
			for i in range(VISUAL_COUNT):
				var bubble = self.get_node("VisualBubble_" + str(bone_index) + "_" + str(i))


				var pos = a.lerp(b, bubble.tangent_offset);
				var tangent = (b - a).normalized();
				var bitangent = Vector3(-tangent.y, tangent.x, 0)
				bubble.target_position = pos + bitangent * bubble.bitangent_offset;
