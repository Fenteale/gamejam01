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

var motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Dumb")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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
	var rel_pos = get_viewport().get_mouse_position() - position
	print("Dumb")
	print(get_viewport().get_mouse_position())
	print(position)
	an.rotation_degrees = atan(rel_pos.y / rel_pos.x)
	
