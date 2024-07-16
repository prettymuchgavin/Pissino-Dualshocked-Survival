extends Control


func _input(event):
	if Input.is_action_just_pressed("exit"):
		if $"../../".dead == false:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			show()
			$AnimationPlayer.play("pause")
			get_tree().paused = true
			$AudioStreamPlayer.play()
			$TextureRect/resume.disabled = false
			$TextureRect/quit.disabled = false


func _on_resume_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationPlayer.play("unpause")
	$AudioStreamPlayer.stop()
	get_tree().paused = false
	$TextureRect/resume.disabled = true
	$TextureRect/quit.disabled = true


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "unpause":
		hide()
