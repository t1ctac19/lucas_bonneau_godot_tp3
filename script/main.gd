extends Node2D

@export var premier_niveau: String = "res://scenes/niveaux/Niveau_01.tscn"
@onready var niveau_container: Node = $NiveauContainer

func _ready():
	print("▶ Main est prêt")
	
	if not has_node("NiveauContainer"):
		print("❌ ERREUR : NiveauContainer pas trouvé dans Main")
		return
	
	print("✅ NiveauContainer trouvé")
	charger_niveau(premier_niveau)

func charger_niveau(path: String):
	if not FileAccess.file_exists(path):
		print("❌ ERREUR : Niveau introuvable :", path)
		return

	var niveau = load(path).instantiate()
	niveau_container.add_child(niveau)
	print("✅ Niveau chargé :", path)
