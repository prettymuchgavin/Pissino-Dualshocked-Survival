extends Node3D

var maxEnemies = 1
var currentEnemies = 0
var killedEnemies = 0

var currentRound = 1


func spawnEnemy():
	if currentEnemies == maxEnemies:
		return
	currentEnemies += 1
	var enemyScene = preload("res://scenes/enemy.tscn")
	var enemy = enemyScene.instantiate()
	add_child(enemy)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomPos = rng.randi_range(1,5)
	enemy.transform.origin = get_node("enemySpawners/"+str(randomPos)).position

func _on_spawn_timer_timeout():
	spawnEnemy()

func _process(delta):
	$ROUNDS.text = "ROUND "+str(currentRound)
	$Player/CanvasLayer/DeathScreen/Panel/Label2.text = "YOU MADE IT TO ROUND "+str(currentRound)

func newRound():
	killedEnemies = 0
	currentEnemies = 0
	maxEnemies *= 2
	currentRound += 1
	$ROUNDS/AnimationPlayer.play("anim", false)

func _on_weapon_pick_up_pickedup():
	$music.play()
	$enemySpawners/spawnTimer.start()
	spawnEnemy()
	$ROUNDS/AnimationPlayer.play("anim")


func _on_player_killed_something():
	killedEnemies += 1
	if killedEnemies == maxEnemies:
		newRound()
