extends Control

var score = 0

func _ready() -> void:
	$GameOver.visible = false
	
func _on_bubble_popped(increment_score) -> void:
	if increment_score:
		score += 1
		$ScoreLabel.text = "Score: %s" % score

func _on_spike_touched(spike_name) -> void:
	$ScoreLabel.text = "OUCH"

func show_game_over() -> void:
	$GameOver.visible = true
	
