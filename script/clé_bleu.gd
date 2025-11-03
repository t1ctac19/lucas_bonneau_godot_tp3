extends Area2D

@export var cle_bleu : String = "cle_01"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		
		body.ajouter_cle(cle_bleu)
		
		print("Clé ajoutée :", cle_bleu, " | Inventaire =", body.cles)

		$SonCléBleu.play()
		await $SonCléBleu.finished
		
		queue_free()
