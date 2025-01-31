extends Node3D

var target_position = Vector3.ZERO;
var speed_limit = 1000.0

var tangent_offset = 0.0
var bitangent_offset = 0.0
var target_scale = 1.0

var delayed_pop_time: int = -1;
var play_sound = 0

const SPEED = 100.0;

func pop(time_offset: float, play_sound: int) -> void:
	self.play_sound = play_sound
	self.delayed_pop_time = Time.get_ticks_usec() + (time_offset * 1000000.0)

func spawn() -> void:
	set_scale(Vector3.ZERO)
	$AnimatedSprite3D.play("default")

func _ready() -> void:
	pass

# func smoothstep(edge0: float, edge1: float, x: float): float {
#    # Scale, and clamp x to 0..1 range
#    x = ((x - edge0) / (edge1 - edge0)).clampf(0.0, 1.0);
#    return x * x * (3.0f - 2.0f * x);
# }

func _process(delta: float) -> void:
	if delayed_pop_time >= 0 && Time.get_ticks_usec() > delayed_pop_time:
		if play_sound:
			$AudioStreamPlayer.pitch_scale = 1.6 - scale.x # 0.7 to 1.5
			$AudioStreamPlayer.play()
		$AnimatedSprite3D.play("pop")
		delayed_pop_time = -1

	var real_target_scale = target_scale
	var kinect_player = self.get_parent()
	if kinect_player.name == "KinectPlayer": # WTF Godot
		real_target_scale = target_scale * kinect_player.player_size

	set_scale(scale.lerp(Vector3(real_target_scale, real_target_scale, real_target_scale), delta))

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

	var new_pos = self.position.lerp(target_position, clamp(delta * real_speed, 0.0, 1.0))
	self.set_position(new_pos)
	pass
