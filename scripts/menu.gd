extends Node2D




func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")


func _on_multiplayer_pressed():
	Global.coop = true
	get_tree().change_scene_to_file("res://scenes/intro.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
