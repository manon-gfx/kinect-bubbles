extends Area3D



func _on_body_entered(body: Node) -> void:
	if body.is_in_group("bubble"):
			body.pop()

	if body.is_in_group("spiky_object"):
		print("Spiky object!!")
		body.touched_spike()
		$AnimatedSprite3D.play("pop")
