extends Area2D

@export var cle_or : String = "cle_02"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		
		body.ajouter_cle(cle_or)
		
		print("Clé ajoutée :", cle_or, " | Inventaire =", body.cles)

		$"SonCléOr".play()
		await $"SonCléOr".finished
		
		queue_free()
