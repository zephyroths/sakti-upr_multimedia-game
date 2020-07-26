extends Button

func _ready():
	pass # Replace with function body.

func _on_button_run_mouse_entered():
	$run.play("default")

func _on_button_run_mouse_exited():
	$run.stop()
	$run.frame = 0
