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
var spawn_anim = "spawn_sky"

onready var tw = get_node("Tween")
onready var anim = get_node("AnimationPlayer")
onready var pl = get_tree().get_root().get_node("World/player")

# Called when the node enters the scene tree for the first time.
func _ready():
	tim = get_node("Timer")
	
	anim.play(spawn_anim)

func on_hit(damage):
	hp -= damage
	$damageAnim.play("damaged")
	if hp <= 0:
		#probably do something fancier than just deleting itself
		get_tree().get_root().get_node("World").guy_dead()
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#move_and_slide((pouncePos - position)* speed *delta)
	move_and_slide(pouncePos* speed *delta)


func _on_Timer_timeout():
	#print(state)
	match state:
		0:
			anim.play("idle") #maybe should be walking
			pouncePos = Vector2((randf()*2)-1, (randf()*2)-1)
			pouncePos = pouncePos.normalized()
			speed = 5000
			state = 1
			tim.set_wait_time((randf()*1) + 1)
			tim.start()
		1:
			speed = 0
			anim.play("shake")
			state = 2
		2:
			#tw.interpolate_property(self, "speed", 0, SPEED_MAX, STATE_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
			speed = 50000
			pouncePos = pl.position - position
			pouncePos = pouncePos.normalized()
			#tw.start()
			#tim.stop()
			anim.play("pounce") #, -1, 0.7)
			tim.set_wait_time(0.7)
			tim.start()
			state = 3
		3:
			speed = 0
			anim.play("idle")
			tim.set_wait_time(0.5)
			tim.start()
			state = 0


func _on_AnimationPlayer_animation_finished(anim_name):
	if "spawn" in anim_name:
		var t = Timer.new()
		t.set_wait_time(randf())
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		tim.wait_time = STATE_TIME
		tim.start()
