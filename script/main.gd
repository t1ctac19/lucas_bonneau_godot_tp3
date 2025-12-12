extends Node2D


@export var premier_niveau: PackedScene
@export var deuxième_niveau: PackedScene
@export var troisième_niveau: PackedScene

@onready var personnage_principal: Personnage = $personnage_principal
@onready var niveau_container: Node = $NiveauContainer
var niveau_courrant = premier_niveau

var pos_start_niveau1 = Vector2(-1756, 300)
var pos_start_niveau2 = Vector2(4800, 576)
var pos_start_niveau3 = Vector2(13440, 576)

var niveau_charge = null

func _ready():
	charger_niveau(premier_niveau)
	print("Main est prêt")
	InfosJeu.player = personnage_principal
	

func charger_niveau(scene: PackedScene):
	var player = personnage_principal

	niveau_charge = scene.instantiate()
	niveau_container.add_child(niveau_charge)

	if player:
		player.get_parent().remove_child(player)
		niveau_charge.add_child(player)
