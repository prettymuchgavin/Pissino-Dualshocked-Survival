extends Node3D

@export var enemies : Array[PackedScene]
@export var rootScene : Node3D

func _ready():
	$Sprite3D.hide()
	rootScene.connect("startGame", startSpawning)

func spawnEnemy():
	var enemy = enemies.pick_random().instantiate()
	rootScene.call_deferred("add_child", enemy)
	enemy.transform.origin = position

func startSpawning():
	$spawnTimer.start(1)

func stopSpawning():
	$spawnTimer.stop()


func _on_spawn_timer_timeout():
	if rootScene.maxEnemies == rootScene.currentEnemies:
		return
	spawnEnemy()
	rootScene.currentEnemies += 1
