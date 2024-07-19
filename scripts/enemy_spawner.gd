extends Node3D

@export var enemies : Array[PackedScene]
@export var rootScene : Node3D

var rng = RandomNumberGenerator.new()
func _ready():
	#$Sprite3D.hide()
	rootScene.connect("startGame", startSpawning)

func spawnEnemy():
	var enemy = enemies.pick_random().instantiate()
	rootScene.call_deferred("add_child", enemy)
	enemy.transform.origin = position

func startSpawning():
	rng.randomize()
	var randomTime = rng.randi_range(0.1, 3)
	$spawnTimer.start(randomTime)

func stopSpawning():
	$spawnTimer.stop()


func _on_spawn_timer_timeout():
	if rootScene.maxEnemies == rootScene.currentEnemies:
		stopSpawning()
		return
	spawnEnemy()
	rootScene.currentEnemies += 1
