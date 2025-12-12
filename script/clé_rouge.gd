extends Area2D

@export var cle_rouge : String = "cle_03"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.ajouter_cle(cle_rouge)
		print("Clé ajoutée :", cle_rouge, " | Inventaire =", body.cles)
		$"SonCléOr".play()
		await $"SonCléOr".finished
		queue_free()
