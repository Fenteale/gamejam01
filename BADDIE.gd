extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hp = 2
var state = 0
const SPEED = 50000
const STATE_TIME = 1
var tim
var moveVec = Vector2(0, 0)

onready var tw = get_node("Tween")

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
	move_and_slide(moveVec* delta)


func _on_Timer_timeout():
	print(state)
	match state:
		0:
			state = 1
		1:
			#tw.interpolate_method(self, "move_and_slide", Vector2(0,0), Vector2(SPEED, 0), 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tw.interpolate_property(self, "moveVec", Vector2(0, 0), Vector2(SPEED, 0), STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
			tw.start()
			tim.stop()
			state = 2
			
		3:
			state = 4
		4:
			tw.interpolate_property(self, "moveVec", Vector2(0, 0), Vector2(-SPEED, 0), STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
			tw.start()
			tim.stop()
			state = 5


func _on_Tween_tween_completed(object, key):
	print(object)
	print(key)
	if object == self and key == ":moveVec":
		print("In there")
		match state:
			2:
				tw.interpolate_property(self, "moveVec", Vector2(SPEED, 0), Vector2(0,0), STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
				tw.start()
				state = 3
				tim.start()
			5:
				tw.interpolate_property(self, "moveVec", Vector2(-SPEED, 0), Vector2(0,0), STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
				tw.start()
				state = 0
				tim.start()
				
