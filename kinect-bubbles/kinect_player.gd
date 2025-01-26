extends Node3D

var has_a_kinect = false
var rng = RandomNumberGenerator.new()

var current_body = -1
var prev_best_candidate = -1
var body_timer = -1

const LIMB_OTHER = -1
const LIMB_HEAD = 0
const LIMB_ARM_LEFT = 1
const LIMB_ARM_RIGHT = 2
const LIMB_LEG_LEFT = 3
const LIMB_LEG_RIGHT = 4

var limbs = [
	[KinectBody.JointID_Neck, KinectBody.JointID_Head],
	[KinectBody.JointID_ShoulderLeft, KinectBody.JointID_ElbowLeft, KinectBody.JointID_WristLeft, KinectBody.JointID_HandLeft, KinectBody.JointID_HandTipLeft, KinectBody.JointID_ThumbLeft],
	[KinectBody.JointID_ShoulderRight, KinectBody.JointID_ElbowRight, KinectBody.JointID_WristRight, KinectBody.JointID_HandRight, KinectBody.JointID_HandTipRight, KinectBody.JointID_ThumbRight],
	[KinectBody.JointID_HipLeft, KinectBody.JointID_KneeLeft, KinectBody.JointID_AnkleLeft, KinectBody.JointID_FootLeft],
	[KinectBody.JointID_HipRight, KinectBody.JointID_KneeRight, KinectBody.JointID_AnkleRight, KinectBody.JointID_FootRight],
]

var popped_limbs = []

var limb_to_bone = [
	[],
	[],
	[],
	[],
	[]
]

var limb_to_joints = [
	[],
	[],
	[],
	[],
	[]
]

func joint_to_limb(joint_id) -> int:
	for limb_index in range(limbs.size()):
		for joint in limbs[limb_index]:
			if joint == joint_id:
				return limb_index

	return LIMB_OTHER

#enum KinectJointID
#{
	#JointID_SpineBase = 0,
	#JointID_SpineMid = 1,
	#JointID_Neck = 2,
	#JointID_Head = 3,
	#JointID_ShoulderLeft = 4,
	#JointID_ElbowLeft = 5,
	#JointID_WristLeft = 6,
	#JointID_HandLeft = 7,
	#JointID_ShoulderRight = 8,
	#JointID_ElbowRight = 9,
	#JointID_WristRight = 10,
	#JointID_HandRight = 11,
	#JointID_HipLeft = 12,
	#JointID_KneeLeft = 13,
	#JointID_AnkleLeft = 14,
	#JointID_FootLeft = 15,
	#JointID_HipRight = 16,
	#JointID_KneeRight = 17,
	#JointID_AnkleRight = 18,
	#JointID_FootRight = 19,
	#JointID_SpineShoulder = 20,
	#JointID_HandTipLeft = 21,
	#JointID_ThumbLeft = 22,
	#JointID_HandTipRight = 23,
	#JointID_ThumbRight = 24,
	#JointID_Count = ( JointID_ThumbRight + 1 )
#};

var kinect_node = null;
var player_size = 2.0
var bones = [
	# core
	[KinectBody.JointID_SpineBase, KinectBody.JointID_SpineMid],
	[KinectBody.JointID_SpineMid, KinectBody.JointID_SpineShoulder],
	[KinectBody.JointID_SpineShoulder, KinectBody.JointID_Neck],
	[KinectBody.JointID_Neck, KinectBody.JointID_Head],

	#left arm and shoulder
	[KinectBody.JointID_SpineShoulder, KinectBody.JointID_ShoulderLeft],
	[KinectBody.JointID_ShoulderLeft, KinectBody.JointID_ElbowLeft],
	[KinectBody.JointID_ElbowLeft, KinectBody.JointID_WristLeft],
	[KinectBody.JointID_WristLeft, KinectBody.JointID_HandLeft],

	#left arm and shoulder
	[KinectBody.JointID_SpineShoulder, KinectBody.JointID_ShoulderRight],
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

var bone_densities = [
	24, 24, 4, 4, 
	4, 16, 8, 8,
	4, 16, 8, 8,
	4, 32, 24, 8,
	4, 32, 24, 8,
]
var joint_positions = []

var kinect_body_node = preload("res://kinect_body_node/kinect_body_node.tscn")
var player_bubble_visual = preload("res://player_bubble_visual/player_bubble_visual.tscn")

func grow() -> void:
	player_size += 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.set_seed(hash("manon"));
	var root = get_tree().root.get_child(0)

	for i in range(KinectBody.JointID_Count):
		joint_positions.append(Vector3(0, 0, 0))

	for child in root.get_children():
		if child.is_class("KinectNode"):
			self.kinect_node = child as KinectNode
			break

	if self.kinect_node == null:
		print("failed to find the kinect node :(")
	else:
		has_a_kinect = true
		for i in range(KinectBody.JointID_Count):
			var limb = joint_to_limb(i)
			if limb != LIMB_OTHER:
				limb_to_joints[limb].append(i)

			var bubble = kinect_body_node.instantiate()
			bubble.name = "Bubble_" + str(i)
			bubble.joint_id = i;
			bubble.target_scale = 1.0 / 5.0;
			if i == KinectBody.JointID_Head:
				bubble.target_scale = 2.0 / 5.0;
			add_child(bubble)
			bubble.spawn()

		for bone_index in range(bones.size()):
			var joint_a = bones[bone_index][0]
			var limb = joint_to_limb(joint_a)
			if limb != LIMB_OTHER:
				limb_to_bone[limb].append(bone_index)
			
			var density = bone_densities[bone_index]
			for i in range(density):
				var bubble = player_bubble_visual.instantiate()
				bubble.name = "VisualBubble_" + str(bone_index) + "_" + str(i)
				var s = rng.randf_range(0.2, 0.5) / 5.0
				bubble.target_scale = s;
				bubble.tangent_offset = i / (density as float)
				bubble.bitangent_offset = rng.randf_range(-0.4, 0.4)
				add_child(bubble)
				bubble.spawn()
		# Debug ground plane
		# var plane_mesh = PlaneMesh.new()
		# var plane = MeshInstance3D.new()
		# plane.name = "Ground"
		# plane.mesh = plane_mesh
		# plane.set_position(Vector3(1, 1, 1))
		# add_child(plane)

func pop_limb(joint_id) -> void:
	var limb = joint_to_limb(joint_id)
	if limb == LIMB_OTHER:
		return

	# limb already popped
	if self.popped_limbs.has(limb):
		return

	var bone_list = limb_to_bone[limb]
	for bone in bone_list:
		for i in range(bone_densities[bone]):
			var node = get_node("VisualBubble_" + str(bone) + "_" + str(i))
			var time_offset = rng.randf_range(0.0, 0.5)
			var play_sound = rng.randi_range(0, 5) == 0
			node.pop(time_offset, play_sound)
	pass

	for joint in limb_to_joints[limb]:
		var node = get_node("Bubble_" + str(joint))
		node.pop()

	popped_limbs.append(limb)

func restore_limb() -> void:
	# grow if nothing to heal
	if popped_limbs.size() == 0:
		grow()
		return

	var limb = popped_limbs.pop_front()

	var bone_list = limb_to_bone[limb]
	for bone in bone_list:
		for i in range(bone_densities[bone]):
			var node = get_node("VisualBubble_" + str(bone) + "_" + str(i))
			node.spawn()
	pass

	for joint in limb_to_joints[limb]:
		var node = get_node("Bubble_" + str(joint))
		node.spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var best_id = -1
	var best_score
	var current_valid = false
	if self.kinect_node != null:
		for i in range(6):
			var b = self.kinect_node.get_body(i) as KinectBody
			if !b.valid:
				continue
			if i == current_body:
				current_valid = true
			var pos = b.get_joint_position(KinectBody.JointID_SpineBase)
			var score = (Vector2(pos.x, pos.z) - Vector2(0.0, -2.5)).length()
			if best_id == -1 || score < best_score:
				best_id = i
				best_score = score

		# couldn't find no body
		if best_id == -1:
			return
		if current_body == -1 || !current_valid:
			current_body = best_id
			body_timer = Time.get_ticks_usec()
		elif best_id == prev_best_candidate:
			# Test timer
			if Time.get_ticks_usec() >= body_timer:
				current_body = best_id
				# Assign new current body
		else:
			body_timer = Time.get_ticks_usec() + 2000000 # 2 seconds
		prev_best_candidate = best_id

		assert(current_body != -1)


		var body = self.kinect_node.get_body(current_body)

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
			#scene_pos.z += 22.0
			scene_pos.z = 3.0;

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
			for i in range(bone_densities[bone_index]):
				var bubble = self.get_node("VisualBubble_" + str(bone_index) + "_" + str(i))

				var pos = a.lerp(b, bubble.tangent_offset);
				var tangent = (b - a).normalized();
				var bitangent = Vector3(-tangent.y, tangent.x, 0)
				bubble.target_position = pos + bitangent * bubble.bitangent_offset * (player_size / 5.0);
