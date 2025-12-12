class_name MyHurtBox
extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is MyHitBox:
		var hitboxautre: MyHitBox = area
		if owner and owner.has_method("take_damage"):
			owner.take_damage(hitboxautre.damage)
	
