extends Node3D

@export var playerScene : PackedScene
@export var rootNode : Node3D

@export var playerNum = 1

func _ready():
	$Sprite3D.hide()

func spawnPlayer():
	var player = playerScene.instantiate()
	rootNode.call_deferred("add_child", player)
	player.transform.origin = position
	player.playerNum = playerNum
	player.connect("killedSomething", rootNode._on_player_killed_something)
