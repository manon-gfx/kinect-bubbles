extends Control


var score = 0
var bubbles_popped = []

func _ready() -> void:
	$GameOver.visible = false
	

func _on_bubble_popped(bubble_name) -> void:
	if bubble_name not in bubbles_popped:
		score += 1
		$ScoreLabel.text = "Score: %s" % score
		bubbles_popped.append(bubble_name)

func _on_spike_touched(spike_name) -> void:
	$ScoreLabel.text = "OUCH"

func show_game_over() -> void:
	$GameOver.visible = true
	
