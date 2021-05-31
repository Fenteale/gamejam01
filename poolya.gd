extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED = 1000
var DAMAGE = 1
var pierce = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var moveVec = Vector2(cos(rotation), sin(rotation))
	#moveVec.RIGHT.rotate(rotation)
	position += moveVec.normalized() * SPEED * delta
#	pass


func _on_KinematicBody2D_body_entered(body):
	#DO when the bullet hits the bad guy
	#print("BADDIE DETECTED")
	#body.queue_free()
	if body.has_method("on_hit"):
		body.on_hit(DAMAGE)
		if pierce <= 0:
			queue_free()
		else:
			pierce -= 1
	else:
		queue_free()


func _on_Timer_timeout():
	$Sprite.visible = true
