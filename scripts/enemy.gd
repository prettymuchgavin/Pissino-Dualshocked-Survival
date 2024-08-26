extends CharacterBody3D

@export var move_speed = 5.0
@export var attack_range = 2.0

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
var dead = false
var meleeCurrent = false

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	var dir = player.global_position - global_position
	if !is_on_floor():
		dir.y = -100.0
	dir = dir.normalized()
	velocity = dir * move_speed
	move_and_slide()
	look_at(player.position)
	attempt_to_kill_player()

func attempt_to_kill_player():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state. intersect_ray(query)
	if result.is_empty():
		player.killPlayer()

func kill():
	dead = true
	queue_free()

func melee():
	meleeCurrent = true
	velocity.y = 400
	velocity.x = 1000
	move_and_slide()
