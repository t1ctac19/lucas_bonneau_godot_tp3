extends Area2D

var nouvelle_vie = 100
@onready var animation_alchemist: AnimatedSprite2D = $AnimationAlchemist

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	


func _on_body_entered(body):
	if body.is_in_group("player"):
		if "vie" in body and body.vie < 100:
			body.vie = nouvelle_vie
			body.barre_de_vie()
		animation_alchemist.play("work")
		await animation_alchemist.animation_finished
		animation_alchemist.play("idle")
		
