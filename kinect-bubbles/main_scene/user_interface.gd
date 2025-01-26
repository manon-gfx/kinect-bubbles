extends Control


var score = 0
var bubbles_popped = []

func _ready() -> void:
	$VBoxContainer.visible = false
	

func _on_bubble_popped(bubble_name) -> void:
	if bubble_name not in bubbles_popped:
		score += 1
		$ScoreLabel.text = "Score: %s" % score
		bubbles_popped.append(bubble_name)

func _on_spike_touched(spike_name) -> void:
	#$ScoreLabel.text = "OUCH" # Anneriet: zodat je score te zien blijft in het game over scherm
	pass

func show_game_over() -> void:
	$VBoxContainer.visible = true
	

### Anneriet: dit is de try again button
### Connected to Button pressed() signal
func _on_try_again() -> void:
	get_tree().reload_current_scene() 
	#$VBoxContainer.visible = false
