extends CharacterBody2D
class_name Personnage

signal player_attaque

@export var vitesse_marche = 500.0
@export var vitesse_course = 750.0
@export_range(0, 1) var acceleration = 0.2
@export_range(0, 1) var deceleration = 0.2
@export var tomber = 20

@export var force_saut = -600
@export_range(0, 1) var deceleration_saut_relacher = 0.5

@onready var sprite = $perso_principal
@onready var son_attaque = $sword_attack
@onready var son_mort = $son_mort
@onready var animation_vie = $perso_principal/BarreDeVie
@onready var vie = 100
@onready var victory_scene =("res://scene/victory.tscn")

var is_attacking = false
var nombre_saut = 0
var damage_to_deal = 20
var can_move = true
var est_mort = false
var en_train_de_prendre_degats = false

var victoire = false

var cles: Array = []

func _physics_process(delta: float) -> void:
	if est_mort:
		return
		
	if en_train_de_prendre_degats:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		nombre_saut = 0

	if Input.is_action_just_pressed("saut") and (is_on_floor() or is_on_wall()) and nombre_saut <= 1:
		velocity.y = force_saut
		nombre_saut += 1
	
	if Input.is_action_just_released("saut") and velocity.y < 0:
		velocity.y *= deceleration_saut_relacher
	
	var vitesse
	if Input.is_action_pressed("course"):
		vitesse = vitesse_course
	else:
		vitesse = vitesse_marche
		
	var direction := Input.get_axis("gauche", "droite")
	
	if direction != 0:
		sprite.flip_h = (direction == -1)
	
	if direction:
		velocity.x = move_toward(velocity.x ,direction * vitesse, vitesse * acceleration )
	else:
		velocity.x = move_toward(velocity.x, 0, vitesse_marche * deceleration)
		
	if is_attacking:
		velocity.x = 0

	update_animation(direction)
	move_and_slide()


func update_animation(direction):
	if Input.is_action_just_pressed("katana") and not is_attacking:
		start_attack()

	if is_attacking:
		if not sprite.is_playing():
			reset_attack()
		return
	else:
		$perso_principal/HitBox/CollisionHit.disabled = true

	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("course")
	else:
		if velocity.y < -tomber:
			sprite.play("saut")
			
		elif velocity.y > tomber:
			sprite.play("tombe")
		else:
			sprite.play("saut")


func start_attack():
	if is_on_floor():
		is_attacking = true
		emit_signal("player_attaque")
		$perso_principal/HitBox/CollisionHit.disabled = false
		sprite.play("attaque_01")
		son_attaque.play()

func reset_attack():
	is_attacking = false


func take_damage(damage_to_deal):
	if est_mort: 
		return

	vie -= damage_to_deal
	en_train_de_prendre_degats = true
	sprite.play("take_hit")
	barre_de_vie()

	await sprite.animation_finished
	en_train_de_prendre_degats = false

	if vie <= 0:
		mourir()

func mourir():
	est_mort = true
	sprite.play("mort")
	son_mort.play()

	await sprite.animation_finished
	
	var go = get_tree().current_scene.get_node("GameOver")
	go.afficher()

	var main = get_tree().current_scene
	var container = main.get_node("NiveauContainer")

	for child in container.get_children():
		child.queue_free()
		
	
	cles = []
	vie = 100
	barre_de_vie()
	
	if main.niveau_courrant == "res://scene/niveau_01.tscn":
		global_position = main.pos_start_niveau1
	
	if main.niveau_courrant == "res://scene/niveau_02.tscn":
		global_position = main.pos_start_niveau2
	
	if main.niveau_courrant == "res://scene/niveau_03.tscn":
		global_position = main.pos_start_niveau3
	
	est_mort = false
	
func changer_niveau(scene: PackedScene):
	var main = get_tree().current_scene
	main.charger_niveau(scene)

func barre_de_vie():
	print("vie =", vie)
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
		
		
func ajouter_cle(cle_name: String):
	if cle_name not in cles:
		cles.append(cle_name)
		print("Clé obtenue :", cle_name)

func has_key(cle_name: String) -> bool:
	return cle_name in cles
	
	
func _on_entered_victory():
	get_tree().change_scene_to_packed(victory_scene)

func win():
	if victoire:
		return
	victoire = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	victory_scene.visible = true
	get_tree().paused = true
