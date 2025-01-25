extends Node3D

var target_position = Vector3.ZERO;
var speed_limit = 1000.0

var tangent_offset = 0.0
var bitangent_offset = 0.0

const SPEED = 25.0;

func pop() -> void:
	$AnimatedSprite3D.play("pop")
func spawn() -> void:
	$AnimatedSprite3D.play("default")

func _ready() -> void:
	pass

# func smoothstep(edge0: float, edge1: float, x: float): float {
#    # Scale, and clamp x to 0..1 range
#    x = ((x - edge0) / (edge1 - edge0)).clampf(0.0, 1.0);
#    return x * x * (3.0f - 2.0f * x);
# }

func _process(delta: float) -> void:
	var speed = SPEED;
	#var diff = target_position - self.position
	#var direction = diff.normalized()

	var real_speed = speed * scale.x
	# var l = diff.length() + 1.0;
	# var magic = l * l;
	var magic = 1.0

	# smoothstep(0.0, 1.0, diff.length())
#
	#var velocity = diff.normalized() * magic * real_speed;
	#if diff.length() > speed_limit:
		#velocity = diff.normalized() * speed_limit

	# self.set_position(self.position.lerp + velocity * delta)

	var new_pos = self.position.lerp(target_position, delta * real_speed)
	self.set_position(new_pos)
	pass
