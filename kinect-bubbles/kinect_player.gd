extends Node3D

var kinect_node = null;
var player_size = 5
var joint_radius = 0.1
var joint_factors = [2.0, 1.0, 0.5, 2.0,
					1.0, 1.0, 1.0, 2.0,
 					1.0, 1.0, 1.0, 2.0,
					1.0, 1.0, 1.0, 2.0,
					1.0, 1.0, 1.0, 2.0,
					1.0, 1.0, 1.0, 1.0, 1.0]

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
#
#enum KinectHandState {
	#KinectHandState_Unknown = 0,
	#KinectHandState_NotTracked = 1,
	#KinectHandState_Open = 2,
	#KinectHandState_Closed = 3,
	#KinectHandState_Lasso = 4,
#};


var kinect_body_node = preload("res://kinect_body_node/kinect_body_node.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root.get_child(0)

	for child in root.get_children():
		print(child.name)
		if child.is_class("KinectNode"):
			self.kinect_node = child as KinectNode
			break

	if self.kinect_node == null:
		print("failed to find the kinect node :(")
	else:
		for joint_id in range(KinectBody.JointID_Count):
			var joint = kinect_body_node.instantiate()
			joint.name = "Joint" + str(joint_id)
			add_child(joint)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.kinect_node != null:
		var body = self.kinect_node.get_body(0) as KinectBody

		for joint_id in range(KinectBody.JointID_Count):
			var kin_pos = body.get_joint_position(joint_id)
			var scene_pos = kin_pos * player_size
			var joint = self.get_node("Joint" + str(joint_id))
			joint.set_position(scene_pos)

