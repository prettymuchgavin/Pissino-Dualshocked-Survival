extends Node3D

var maxEnemies = 1
var currentEnemies = 0
var killedEnemies = 0

signal startGame

func _ready():
	$playerSpawner.spawnPlayer()

func _process(delta):
	$ROUNDS.text = "ROUND "+str(Global.currentRound)

func newRound():
	killedEnemies = 0
	currentEnemies = 0
	maxEnemies *= 2
	Global.currentRound += 1
	$ROUNDS/AnimationPlayer.play("anim", false)

func _on_weapon_pick_up_pickedup():
	$music.play()
	$ROUNDS/AnimationPlayer.play("anim")
	emit_signal("startGame")


func _on_player_killed_something():
	killedEnemies += 1
	if killedEnemies == maxEnemies:
		newRound()


