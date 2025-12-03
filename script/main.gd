extends Node2D

signal player_attaque

@export var premier_niveau: String = "res://scene/niveau_01.tscn"
@onready var niveau_container: Node = $NiveauContainer
var niveau_courrant = premier_niveau

var pos_start_niveau1 = Vector2(-1756, 300)
var pos_start_niveau2 = Vector2(4800, 576)
var pos_start_niveau3 = Vector2(13440, 576)

var niveau_charge = null

func _ready():
	charger_niveau(premier_niveau)
	print("▶ Main est prêt")

func charger_niveau(path: String):
	var player = null
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]


	print("------ CHARGEMENT NIVEAU ------")
	print("👤 Joueurs AVANT chargement:", players.size())
	for p in players:
		print("   →", p.name, " parent:", p.get_parent().name)

	# Chargement
	niveau_charge = load(path).instantiate()
	niveau_container.add_child(niveau_charge)

	players = get_tree().get_nodes_in_group("player")
	print("👤 Joueurs APRÈS chargement:", players.size())
	for p in players:
		print("   →", p.name, " parent:", p.get_parent().name)
	
	


	if player:
		niveau_charge.add_child(player)
	else:

		var new_players = get_tree().get_nodes_in_group("player")
		if new_players.size() > 0:
			player = new_players[0]

	if player and not player.is_connected("player_attaque", Callable(self, "on_player_attaque")):
		player.connect("player_attaque", Callable(self, "on_player_attaque"))
		print("✅ Signal player_attaque connecté !")
