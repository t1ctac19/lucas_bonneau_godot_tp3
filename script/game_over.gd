extends CanvasLayer

func _ready():
	visible = false


func afficher():
	visible = true
	get_tree().paused = true

func _on_start_button_pressed():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://scene/main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
