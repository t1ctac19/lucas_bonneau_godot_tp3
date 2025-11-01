extends Area2D

@export var clé_bleu : String = "clé_01"


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_clé(clé_bleu)
		print("Clé ajoutée :", clé_bleu, " | Inventaire =", body.clés)
		$"SonCléBleu".play()
		await $"SonCléBleu".finished
		
		queue_free()
