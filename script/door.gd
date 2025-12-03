extends Area2D

@export var cle_bleu : String = "cle_01"
@export var prochain_niveau: String = "res://scene/niveau_02.tscn"

@onready var sprite: AnimatedSprite2D = $AnimationDoor
@onready var collider: CollisionShape2D = $CollisionDoor

var is_open = false

func _ready():
	print("✅ Porte prête :", name)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("▶ body_entered reçu :", body, " (", typeof(body), ")")
	var player = _find_player_node(body)
	if player == null:
		print("❌ Aucun joueur valide trouvé à partir du body reçu.")
		return

	print("▶ Player résolu :", player.name)

	if player.has_method("has_key"):
		var has = player.has_key(cle_bleu)
		print("▶ player.has_key(", cle_bleu, ") ->", has)
		if has:
			_open_and_transition(player)
		return

	if "cles" in player:
		print("▶ Inventaire du player :", player.cles)
		if cle_bleu in player.cles:
			_open_and_transition(player)
		else:
			print("❌ Clé manquante :", cle_bleu)
		return

	print("❌ Le player n'a ni has_key() ni la propriété 'cles'.")


func _find_player_node(start_node: Node) -> Node:
	var n = start_node

	if n == null:
		return null

	if n.is_in_group("player"):
		return n

	while n != null:
		if n.is_in_group("player"):
			return n
		if n.has_method("has_key"):
			return n
		if "cles" in n:
			return n
		n = n.get_parent()
	return null

func _open_and_transition(player: Node) -> void:
	if is_open:
		print("⚠ Déjà ouvert")
		return
	is_open = true
	print("✅ Ouverture : animation ->", sprite.name)
	sprite.play("ouvert")
	await sprite.animation_finished
	collider.disabled = true
	print("✅ Animation finie, préparation du changement de niveau")

	var main = get_tree().current_scene
	if not main:
		print("❌ main introuvable via current_scene")
		return

	var container = main.get_node_or_null("NiveauContainer")
	if container == null:
		print("❌ NiveauContainer introuvable dans Main")
		return

	print("✅ Suppression ancien niveau")
	for c in container.get_children():
		c.queue_free()

	var next = load(prochain_niveau).instantiate()
	main.niveau_courrant = prochain_niveau
	container.add_child(next)
	print("✅ Nouveau niveau ajouté :", prochain_niveau)
