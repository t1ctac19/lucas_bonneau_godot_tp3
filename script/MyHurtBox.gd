class_name MyHurtBox
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	monitoring = true
	monitorable = true

func _on_area_entered(area: Area2D) -> void:
	if area is MyHitBox:
		var hitbox = area as MyHitBox
		if owner and owner.has_method("take_damage"):
			print(owner.name, "a été touché par", area.owner.name)
			owner.take_damage(hitbox.damage)
		
