class_name Enemie04
extends CharacterBody2D

@onready var hitbox_shape = $MyHitBox/CollisionHit
@onready var son_attaque: AudioStreamPlayer = $sword_attack
@onready var sprite: AnimatedSprite2D = $SpriteEnemie
@onready var son_mort: AudioStreamPlayer = $son_mort
@onready var animation_vie: AnimatedSprite2D = $SpriteEnemie/BarreDeVie
@onready var hitbox: Area2D = $MyHitBox

const VITESSE = 300
const GRAVITE = 900

var suit_joueur = false
var direction = Vector2.RIGHT
var vie = 100
var mort = false
var taking_damage = false
var is_dealing_damage = false
var peut_attaquer = true
var temps_recharge_attaque = 1.5
var distance_attaque = 100
var damage_to_deal = 20

func _ready():
	if not hitbox.area_entered.is_connected(_on_hitbox_entered):
		hitbox.area_entered.connect(_on_hitbox_entered)

func _physics_process(delta):
	if mort:
		return

	if not is_on_floor():
		velocity.y += GRAVITE * delta

	var player = get_tree().current_scene.get_node("personnage_principal")
	if not player:
		return

	var distance = global_position.distance_to(player.global_position)
	suit_joueur = distance < 300

	if suit_joueur:
		direction = (player.global_position - global_position).normalized()
		sprite.flip_h = direction.x < 0

		if distance <= distance_attaque and peut_attaquer and not is_dealing_damage:
			attaquer(player)
		elif not is_dealing_damage:
			move_towards_player()
	else:
		patrol()

	handle_animation()
	move_and_slide()
	
func handle_animation():
	if mort:
		sprite.play("mort")
	elif taking_damage:
		sprite.play("hurt")
	elif is_dealing_damage:
		sprite.play("attaque")
	else:
		sprite.play("marche")

func move_towards_player():
	if taking_damage:
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

	sprite.flip_h = (player.global_position.x < global_position.x)

	hitbox_shape.disabled = false

	await get_tree().create_timer(0.4).timeout

	hitbox_shape.disabled = true

	is_dealing_damage = false
	await get_tree().create_timer(temps_recharge_attaque).timeout
	peut_attaquer = true

func _on_hitbox_entered(area):
	if mort:
		return
	if area.is_in_group("player_hurtbox"):
		var player = area.get_owner()
		if player.has_method("prendre_degats"):
			player.prendre_degats(damage_to_deal)

func take_damage(dmg):
	if mort:
		return
	vie -= dmg
	barre_de_vie()
	if vie <= 0:
		mourir()

func mourir():
	mort = true
	sprite.play("mort")
	son_mort.play()
	await sprite.animation_finished
	queue_free()

func barre_de_vie():
	if vie >= 100:
		animation_vie.play("100%")
	elif vie >= 80:
		animation_vie.play("80%")
	elif vie >= 60:
		animation_vie.play("60%")
	elif vie >= 40:
		animation_vie.play("40%")
	elif vie >= 20:
		animation_vie.play("20%")
	else:
		animation_vie.play("0%")


func _on_direction_timer_timeout() -> void:
	pass # Replace with function body.
