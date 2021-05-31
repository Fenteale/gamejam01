extends KinematicBody2D

enum {
	NO_MOVEMENT,
	MOVE_LEFT,
	MOVE_UPLEFT,
	MOVE_UP,
	MOVE_UPRIGHT,
	MOVE_RIGHT,
	MOVE_DOWNRIGHT,
	MOVE_DOWN,
	MOVE_DOWNLEFT
}

enum {
	LOOK_UP,
	LOOK_RIGHT,
	LOOK_LEFT,
	LOOK_DOWN
}

var MAX_SPEED # = 20000
const DODGE_SPEED = 40000
var RELOAD_TIME #= 1
const MAX_HP = 3
var hp # = MAX_HP
var shots # = 6
var isDying #= false
var speed #= MAX_SPEED
var damage #= 1
var pierce = 0

var motion = Vector2()
onready var poolyaScene = preload("res://poolya.tscn")
onready var reloadInd = get_node("aimer/reload_ind")
onready var Iframe = get_node("IFrames")
onready var anim = get_node("AnimationPlayer")
var reloadText
var hpText
var moveState

# Called when the node enters the scene tree for the first time.
func _ready():
	MAX_SPEED = 20000
	RELOAD_TIME = 1
	hp = MAX_HP
	shots = 6
	isDying = false
	speed = MAX_SPEED
	damage = 1
	
	get_node("aimer/reload_ind").visible = false
	reloadText = get_tree().get_root().get_node("World/ReloadText")
	reloadText.text = str(shots)
	hpText = get_tree().get_root().get_node("World/HP")
	hpText.frame = hp
	$aimer.frame = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hp <= 0:
		var gmbovr = preload("res://gambeover.tscn").instance()
		gmbovr.roundNum = get_tree().get_root().get_node("World").roundNum
		get_tree().get_root().add_child(gmbovr)
		
	
	if $RollTimer.is_stopped():
		moveState = NO_MOVEMENT
		if Input.is_action_pressed("ui_up"):
			moveState = MOVE_UP
	 
		if Input.is_action_pressed("ui_down"):
			moveState = MOVE_DOWN


		if Input.is_action_pressed("ui_left"):
			if Input.is_action_pressed("ui_up"):
				moveState = MOVE_UPLEFT
			elif Input.is_action_pressed("ui_down"):
				moveState = MOVE_DOWNLEFT
			else:
				moveState = MOVE_LEFT
	 
		if Input.is_action_pressed("ui_right"):
			if Input.is_action_pressed("ui_up"):
				moveState = MOVE_UPRIGHT
			elif Input.is_action_pressed("ui_down"):
				moveState = MOVE_DOWNRIGHT
			else:
				moveState = MOVE_RIGHT
		
		if Input.is_action_just_pressed("reload"):
			var tim = get_node("Timer")
			if tim.is_stopped():
				shots = 0
				reloadText.text = str(shots)
				reloadInd.visible = true
				tim.wait_time = RELOAD_TIME
				tim.start()
				var tw = get_node("Tween")
				tw.interpolate_property(reloadInd, "global_rotation", 0, 4*PI, RELOAD_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				tw.start()
		
		if Input.is_action_just_pressed("roll"):
			speed = DODGE_SPEED
			$RollAnim.play("roll")
			$RollTimer.start()
	
	match moveState:
		MOVE_UP:
			motion.y = -1
			motion.x = 0
			$Sprite.play("up")
		MOVE_DOWN:
			motion.y = 1
			motion.x = 0
			$Sprite.play("down")
		MOVE_LEFT:
			motion.y = 0
			motion.x = -1
			$Sprite.play("left")
		MOVE_RIGHT:
			motion.y = 0
			motion.x = 1
			$Sprite.play("right")
		MOVE_UPLEFT:
			motion.y = -1
			motion.x = -1
		MOVE_UPRIGHT:
			motion.y = -1
			motion.x = 1
		MOVE_DOWNLEFT:
			motion.y = 1
			motion.x = -1
		MOVE_DOWNRIGHT:
			motion.y = 1
			motion.x = 1
		NO_MOVEMENT:
			motion.y = 0
			motion.x = 0
			$Sprite.play("default")
			
	motion = motion.normalized() * speed * delta
	
	move_and_slide(motion)
	
	var an = get_node("aimer")
	#var rel_pos = get_viewport().get_mouse_position() - position
	#an.rotation_degrees = atan(rel_pos.y / rel_pos.x)
	an.look_at(get_viewport().get_mouse_position())
	var spriteToPlay = LOOK_RIGHT
	var degParsed = an.rotation_degrees
	
	degParsed = int(degParsed) % 360
	if degParsed < 0:
		degParsed = 360 + degParsed
	
	if degParsed >= 315 or degParsed < 45:
		spriteToPlay = LOOK_RIGHT
		an.flip_v = false
		an.play("right")
		if $ShootDelay.is_stopped():
			an.frame = 2
	elif degParsed >= 45 and degParsed < 135:
		spriteToPlay = LOOK_DOWN
		an.flip_v = false
		an.play("down")
		if $ShootDelay.is_stopped():
			an.frame = 2
	elif degParsed >= 135 and degParsed < 225:
		spriteToPlay = LOOK_LEFT
		an.flip_v = true
		an.play("right")
		if $ShootDelay.is_stopped():
			an.frame = 2
	else:
		an.flip_v = false
		spriteToPlay = LOOK_UP
		an.play("up")
		if $ShootDelay.is_stopped():
			an.frame = 2
	
	if Input.is_action_pressed("ui_accept") and $RollTimer.is_stopped() and $ShootDelay.is_stopped():
		if shots > 0:
			print("Spawning thing")
			var poolya = poolyaScene.instance()
			poolya.position = position
			poolya.rotation = an.rotation
			poolya.DAMAGE = damage
			poolya.pierce = pierce
			get_tree().get_root().add_child(poolya)
			shots -= 1
			reloadText.text = str(shots)
			$ShootDelay.start()
			an.stop()
			match spriteToPlay:
				LOOK_RIGHT:
					an.play("up")
					an.play("right")
				LOOK_UP:
					an.play("right")
					an.play("up")
				LOOK_DOWN:
					an.play("up")
					an.play("down")
				LOOK_LEFT:
					an.play("up")
					an.play("right")
			an.playing = true
	#an.rotation_degrees += 45
	


func _on_Timer_timeout():
	reloadInd.visible = false
	shots = 6
	reloadText.text = str(shots)


func _on_hurtme_body_entered(body):
	if Iframe.is_stopped() and $RollTimer.is_stopped():
		if body.has_meta("invuln") and body.invuln == true:
			return
		isDying = true
		hp -= 1
		hpText.frame = hp
		anim.play("Flashing")
		Iframe.start()


func _on_IFrames_timeout():
	if isDying == true:
		hp -= 1
		hpText.frame = hp
		anim.play("Flashing")
		Iframe.start()
	else:
		anim.play("Idle")


func _on_hurtme_body_exited(body):
	isDying = false


func _on_RollTimer_timeout():
	speed = MAX_SPEED

func add_hp(added_hp):
	#old code
	#hp += added_hp
	hp = MAX_HP
	hpText.frame = hp
	
func add_damage(added_dmg):
	damage += added_dmg

func decrease_reload(re_dec):
	RELOAD_TIME *= re_dec
	
func add_speed():
	MAX_SPEED += 5000
	speed = MAX_SPEED

func add_pierce():
	pierce += 1
