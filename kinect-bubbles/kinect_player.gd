extends Node3D

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
	else:
		for joint_id in range(KinectBody.JointID_Count):			
			var mesh = SphereMesh.new()
			mesh.radius = 0.1
			mesh.height = 0.2

			var joint = MeshInstance3D.new()
			joint.name = "Joint" + str(joint_id)
			joint.mesh = mesh
			add_child(joint)
			
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.kinect_node != null:
		var body = self.kinect_node.get_body(0) as KinectBody
		
		for joint_id in range(KinectBody.JointID_Count):
			var pos = body.get_joint_position(joint_id)			
			var joint = self.get_node("Joint" + str(joint_id))
			joint.set_position(pos)
			
