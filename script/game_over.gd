extends CanvasLayer

func _ready():
	visible = false
	print("GameOver READY")
	print("Process mode:", process_mode)

	process_mode = Node.PROCESS_MODE_ALWAYS
	print("Nouveau process mode:", process_mode)


func afficher():
	visible = true
	get_tree().paused = true

	$StartButton.process_mode = Node.PROCESS_MODE_ALWAYS
	$QuitButton.process_mode = Node.PROCESS_MODE_ALWAYS


func _on_start_button_pressed():
	print("CLICK START")
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://scene/main.tscn")


func _on_quit_button_pressed():
	print("CLICK QUIT")
	get_tree().quit()
