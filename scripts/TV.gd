extends Control

func startTV():
	show()
	$AnimatedSprite2D.play("intro")

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "intro":
		$AnimatedSprite2D.play("default")
		$ScoreStuff.show()
