extends MeshInstance3D

var kinect_node = null;

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.kinect_node != null:
		var body = self.kinect_node.get_body(0) as KinectBody
		set_position(body.get_joint_position(KinectBody.JointID_Head))

	pass
