extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hp = 2
var state = 0
const SPEED = 5000
var tim

# Called when the node enters the scene tree for the first time.
func _ready():
	tim = get_node("Timer")
	tim.start()

func on_hit(damage):
	hp -= 1
	if hp <= 0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		0:
			pass
		1:
			move_and_slide(Vector2(SPEED*delta, 0))
		2:
			pass
		3:
			move_and_slide(Vector2(-SPEED*delta, 0))


func _on_Timer_timeout():
	match state:
		0:
			state = 1
		1:
			state = 2
		2:
			state = 3
		3:
			state = 0
