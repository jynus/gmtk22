extends CenterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Timer_timeout():
	$container/next_button.disabled = false


func _on_next_button_pressed():
	get_tree().quit()
