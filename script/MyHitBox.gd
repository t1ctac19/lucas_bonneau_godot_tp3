class_name MyHitBox
extends Area2D

@export var damage: int = 10

func _ready() -> void:
	monitoring = true
	monitorable = true
