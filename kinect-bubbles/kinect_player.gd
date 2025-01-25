extends Node3D

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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		for bone_index in range(bones.size()):
			for i in range(4):
				var bubble = kinect_body_node.instantiate()
				bubble.name = "Bubble_" + str(bone_index) + "_" + str(i)
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
			joint_positions[joint_id] = scene_pos


		for bone_index in range(bones.size()):
			var a = joint_positions[bones[bone_index][0]]
			var b = joint_positions[bones[bone_index][1]]
			for i in range(4):
				var t = i / 4.0
				var pos = a * (1 - t) + b * t
				# var bubble = kinect_body_node.instantiate()
				var bubble = self.get_node("Bubble_" + str(bone_index) + "_" + str(i))
				bubble.set_position(pos)
