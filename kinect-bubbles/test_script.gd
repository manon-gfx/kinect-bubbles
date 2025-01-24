extends KinectNode


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var result = self.test(1.5)
	#print(result)
		
	var body = self.get_body() as KinectBody
	if body.valid:
		print(body.left_hand_state)
	pass
	
