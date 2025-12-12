extends Area2D

@export var cle_bleu : String = "cle_01"
@export var prochain_niveau: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimationDoor
@onready var collider: CollisionShape2D = $CollisionDoor

var is_open = false

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	var player = InfosJeu.player
	if player == null:
		return

	if player.has_method("has_key"):
		var has = player.has_key(cle_bleu)
		if has:
			_open_and_transition(player)
		return

	if "cles" in player:
		if cle_bleu in player.cles:
			_open_and_transition(player)
		return


func _open_and_transition(player: Node) -> void:
	if is_open:
		return
	is_open = true
	sprite.play("ouvert")
	await sprite.animation_finished
	collider.disabled = true

	var main = get_tree().current_scene
	if not main:
		return

	var container = main.get_node_or_null("NiveauContainer")
	if container == null:
		return

	for c in container.get_children():
		c.queue_free()

	main.niveau_courrant = prochain_niveau
	main.charger_niveau(prochain_niveau)
