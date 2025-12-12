extends Area2D

@export var cle_or : String = "cle_03"
@export var prochain_niveau: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimationDoor
@onready var collider: CollisionShape2D = $CollisionDoor

var is_open = false

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if is_open:
		return

	var player = _find_player(body)
	if player == null:
		return

	var has_key := false
	if player.has_method("has_key"):
		has_key = player.has_key(cle_or)
	elif "cles" in player:
		has_key = cle_or in player.cles

	if has_key:
		_open_and_transition(player)


func _find_player(n):
	while n:
		if n.is_in_group("player"):
			return n
		n = n.get_parent()
	return null

func _open_and_transition(player: Node) -> void:
	if is_open:
		return
	is_open = true

	sprite.play("ouvert")
	await sprite.animation_finished
	collider.disabled = true


	var main = get_tree().current_scene

	if main == null:
		return

	var victory = main.get_node_or_null("Victory")
	if victory == null:
		return

	victory.visible = true

	get_tree().paused = true
