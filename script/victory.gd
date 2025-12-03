extends CanvasLayer

@onready var start_button = $StartButton
@onready var quit_button = $QuitButton

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	start_button.pressed.connect(_on_restart)
	quit_button.pressed.connect(func(): get_tree().quit())

func _on_restart():
	print("🔄 Restart depuis Victory")
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://scene/main.tscn")
