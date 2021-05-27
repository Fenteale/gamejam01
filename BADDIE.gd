extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hp = 2
var state = 0
const SPEED_MAX = 500
const STATE_TIME = 1
var speed = 0
var tim
var pouncePos = Vector2(0,0)

onready var tw = get_node("Tween")
onready var anim = get_node("AnimationPlayer")
onready var pl = get_tree().get_root().get_node("World/player")

# Called when the node enters the scene tree for the first time.
func _ready():
	tim = get_node("Timer")
	tim.wait_time = STATE_TIME
	tim.start()

func on_hit(damage):
	hp -= damage
	if hp <= 0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide((pouncePos - position)* speed *delta)


func _on_Timer_timeout():
	print(state)
	match state:
		0:
			anim.play("idle")
			state = 7
		1:
			#tw.interpolate_method(self, "move_and_slide", Vector2(0,0), Vector2(SPEED, 0), 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			#tw.interpolate_property(self, "moveVec", Vector2(0, 0), Vector2(SPEED, 0), STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
			tw.interpolate_property(self, "speed", 0, SPEED_MAX, STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
			pouncePos = pl.position
			tw.start()
			tim.stop()
			anim.play("pounce", -1, 0.7)
			state = 2
			
		3:
			anim.play("idle")
			state = 6
		4:
			tw.interpolate_property(self, "speed", 0, -SPEED_MAX, STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
			pouncePos = pl.position
			tw.start()
			tim.stop()
			anim.play("pounce", -1, 0.7)
			state = 5
		6:
			anim.play("shake")
			state = 4
		7:
			anim.play("shake")
			state = 1


func _on_Tween_tween_completed(object, key):
	if object == self and key == ":speed":
		match state:
			2:
				tw.interpolate_property(self, "speed", speed, 0, STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
				tw.start()
				state = 0 #used to be 3, but we dont move back now
				tim.start()
			5:
				tw.interpolate_property(self, "speed", speed, 0, STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
				tw.start()
				state = 0
				tim.start()
				
