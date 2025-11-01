extends Area2D

@export var clé_bleu: String = "clé_01"
@export var prochain_niveau: String = "res://scene/niveau_02.tscn"

@onready var sprite: AnimatedSprite2D = $AnimationDoor
@onready var collider: CollisionShape2D = $CollisionDoor

var is_open = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	print("✅ Joueur détecté, vérif clé...")

	if not ("clés" in body):
		print("❌ Le joueur n’a pas de liste 'clés'")
		return

	if clé_bleu in body.clés:
		print("✅ Clé trouvée ! Ouverture...")
		open()
	else:
		print("❌ Le joueur n’a pas cette clé :", clé_bleu)

func open():
	if is_open:
		return

	is_open = true
	sprite.play("ouvert")
	await sprite.animation_finished
	collider.disabled = true

	print("✅ Chargement du prochain niveau :", prochain_niveau)

	var next = load(prochain_niveau).instantiate()

	var container = get_tree().current_scene.get_node("NiveauContainer")

	# Supprime l'ancien niveau
	for c in container.get_children():
		c.queue_free()

	container.add_child(next)
