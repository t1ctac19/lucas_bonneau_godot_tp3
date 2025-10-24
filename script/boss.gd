extends CharacterBody2D
class_name Boss

@onready var son_attaque: AudioStreamPlayer2D = $sword_attack
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const VITESSE = 300
const GRAVITE = 900

var suit_joueur := false
var direction := Vector2.RIGHT
var vie := 150
var mort := false
var taking_damage := false
var is_dealing_damage := false
var peut_attaquer := true
var temps_recharge_attaque := 2.0
var distance_attaque := 100
var damage_to_deal := 20

func _ready():
	direction = [Vector2.RIGHT, Vector2.LEFT].pick_random()

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += GRAVITE * delta

	var player = get_parent().get_node("personnage_principal")
	if not player:
		return

	var distance = global_position.distance_to(player.global_position)
	suit_joueur = distance < 300

	if mort:
		return

	if suit_joueur:
		direction = (player.global_position - global_position).normalized()
		sprite.flip_h = direction.x < 0

		if distance <= distance_attaque and peut_attaquer and !is_dealing_damage:
			attaquer(player)
		elif !is_dealing_damage:
			move_towards_player()
	else:
		patrol()

	handle_animation()
	move_and_slide()

func move_towards_player():
	if mort or taking_damage:
		velocity.x = 0
		return
	velocity.x = direction.x * VITESSE

func patrol():
	if taking_damage or is_dealing_damage:
		velocity.x = 0
		return
	velocity.x = direction.x * VITESSE

func attaquer(player):
	is_dealing_damage = true
	peut_attaquer = false
	velocity.x = 0
	sprite.play("attaque")

	# Joue le son au début du coup
	if son_attaque:
		son_attaque.play()

	# Attente avant le coup effectif
	await get_tree().create_timer(0.4).timeout

	# Vérifie si le joueur est toujours à portée
	if global_position.distance_to(player.global_position) <= distance_attaque:
		if player.has_method("prendre_degats"):
			player.prendre_degats(damage_to_deal)

	is_dealing_damage = false

	# Temps de recharge avant la prochaine attaque
	await get_tree().create_timer(temps_recharge_attaque).timeout
	peut_attaquer = true

func handle_animation():
	if mort:
		sprite.play("mort")
	elif taking_damage:
		sprite.play("hurt")
	elif is_dealing_damage:
		sprite.play("attaque")
	else:
		sprite.play("marche")

func handle_death():
	queue_free()

func _on_direction_timer_timeout():
	if !suit_joueur:
		direction = [Vector2.RIGHT, Vector2.LEFT].pick_random()
