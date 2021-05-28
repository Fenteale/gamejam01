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

const SPEED = 40000
const RELOAD_TIME = 1
const MAX_HP = 3
var hp = MAX_HP
var shots = 6
var isDying = false

var motion = Vector2()
onready var poolyaScene = preload("res://poolya.tscn")
onready var reloadInd = get_node("reload_ind")
onready var Iframe = get_node("IFrames")
onready var anim = get_node("AnimationPlayer")
var reloadText
var hpText

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("reload_ind").visible = false
	reloadText = get_tree().get_root().get_node("World/ReloadText")
	reloadText.text = str(shots)
	hpText = get_tree().get_root().get_node("World/HP")
	hpText.text = str(hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if hp <= 0:
		get_tree().change_scene("res://gambeover.tscn")
	
	
	var moveState = NO_MOVEMENT
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
			tw.interpolate_property(reloadInd, "rotation_degrees", 0, 360, RELOAD_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tw.start()
	
	
	match moveState:
		MOVE_UP:
			motion.y = -1
			motion.x = 0
		MOVE_DOWN:
			motion.y = 1
			motion.x = 0
		MOVE_LEFT:
			motion.y = 0
			motion.x = -1
		MOVE_RIGHT:
			motion.y = 0
			motion.x = 1
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
			
	motion = motion.normalized() * SPEED * delta
	
	move_and_slide(motion)
	
	var an = get_node("aimer")
	#var rel_pos = get_viewport().get_mouse_position() - position
	#an.rotation_degrees = atan(rel_pos.y / rel_pos.x)
	an.look_at(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("ui_accept"):
		if shots > 0:
			print("Spawning thing")
			var poolya = poolyaScene.instance()
			poolya.position = position
			poolya.rotation = an.rotation
			get_tree().get_root().add_child(poolya)
			shots -= 1
			reloadText.text = str(shots)
	an.rotation_degrees += 45
	


func _on_Timer_timeout():
	reloadInd.visible = false
	shots = 6
	reloadText.text = str(shots)


func _on_hurtme_body_entered(body):
	if Iframe.is_stopped():
		isDying = true
		hp -= 1
		hpText.text = str(hp)
		anim.play("Flashing")
		Iframe.start()


func _on_IFrames_timeout():
	if isDying == true:
		hp -= 1
		hpText.text = str(hp)
		anim.play("Flashing")
		Iframe.start()
	else:
		anim.play("Idle")


func _on_hurtme_body_exited(body):
	isDying = false
