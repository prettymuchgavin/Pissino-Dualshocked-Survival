extends CharacterBody3D

@onready var animatedSprite = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var raycast = $RayCast3D
@onready var shootsound = $gunShot

const SPEED = 5.0
const MOUSE_SENS = 0.5

signal killedSomething


var reloading = false
var playerNum = 1
var can_shoot = true
var has_weapon = false
var dead = false
var ammo = 10
var canMove = true


var currentWeapon = "empty"

func _ready():
	if name == "Player2":
		playerNum = 2
		$DirectionalSprite.texture = load("res://assets/shart/playerSprites/idle/sprite_sheet.png")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)

func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS

func _process(delta):
	$CanvasLayer/ammo.text = "AMMO: "+str(ammo)
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	if dead:
		return
	if Input.is_action_just_pressed("shoot"+str(playerNum)):
		if can_shoot == true and has_weapon == true and reloading == false:
			shoot()
	if Input.is_action_just_pressed("reload"+str(playerNum)):
		if ammo < 10 and can_shoot == true:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var randomChanceOfRomance = rng.randi_range(0, 5)
			if randomChanceOfRomance < 5:
				animatedSprite.play("gunReload")
				$reloadNormal.play()
			elif randomChanceOfRomance == 5:
				animatedSprite.play("gunReloadFuni")
				$reloadFuni.play()
			reloading = true
	if Input.is_action_just_pressed("taunt"+str(playerNum)):
		if canMove == true:
			canMove = false
			$Camera3D/tauntCam.current = true
			$Camera3D/tauntEffect.show()
			$Camera3D/tauntEffect.play("default")
			$Camera3D/tauntSFX.play()
			$DirectionalSprite.hide()
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var taunt = rng.randi_range(1, 3)
			$taunts.show()
			$taunts.play("taunt"+str(taunt))
			$CanvasLayer/GunBase.hide()

func _physics_process(delta):
	if dead or !canMove:
		return
	velocity.y -= 10
	var input_dir = Input.get_vector("move_left"+str(playerNum), "move_right"+str(playerNum), "move_forwards"+str(playerNum), "move_backwards"+str(playerNum))
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func shoot():
	if ammo == 0:
		animatedSprite.play("gunShootFail")
	else:
		ammo -= 1
		can_shoot = false
		shootsound.play()
		animatedSprite.play("gunShoot")
		if raycast.is_colliding() and raycast.get_collider().has_method("kill"):
			raycast.get_collider().kill()
			emit_signal("killedSomething")

func shootAnimDone():
	can_shoot = true
	$CanvasLayer/GunBase/AnimatedSprite2D.play("gunIdle")

func killPlayer():
	dead = true
	$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CanvasLayer/GunBase.hide()
	$CanvasLayer/DeathScreen/gameOver.play()
	$Camera3D2.current = true
	$CanvasLayer/DeathScreen/Panel/Label2.text = "SURVIVED TILL ROUND "+str(Global.currentRound)
	get_tree().paused = true

func getItem(weapon:String):
	if weapon == "gun":
		$grabGun.play()
		animatedSprite.play("gunPickup")
		currentWeapon = "gun"


func _on_animated_sprite_2d_animation_finished():
	if animatedSprite.animation == "gunShoot":
		shootAnimDone()
	elif animatedSprite.animation == "gunPickup":
		animatedSprite.play("gunIdle")
		has_weapon = true
	elif animatedSprite.animation == "gunReload" or animatedSprite.animation == "gunReloadFuni":
		ammo += 10 - ammo
		animatedSprite.play("gunIdle")
		reloading = false


func _on_taunt_sfx_finished():
	canMove = true
	$Camera3D/tauntEffect.hide()
	$Camera3D.current = true
	$Camera3D/tauntCam.current = false
	$taunts.hide()
	$CanvasLayer/GunBase.show()
