extends Node3D

@export var weaponType:String

signal pickedup

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		body.getItem(weaponType)
		emit_signal("pickedup")
		queue_free()
