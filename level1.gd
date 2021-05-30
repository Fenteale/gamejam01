extends Node2D


const NUM_ENEMIES = 10
const NUM_ENEMIES_MAX_IN_ROOM = 3
var enemiesleft = NUM_ENEMIES
var bad_inst
var player

onready var windowTimer = get_node("windowTimer")
var windowOcc = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	bad_inst = preload("res://BADDIE.tscn")
	player = get_node("player")
	
	var tospawn
	if NUM_ENEMIES > NUM_ENEMIES_MAX_IN_ROOM:
		tospawn = NUM_ENEMIES_MAX_IN_ROOM
	else:
		tospawn = NUM_ENEMIES
	
	enemiesleft -= tospawn
	
	for i in range(tospawn):
		spawn_badguy()

func guy_dead():
	enemiesleft -= 1
	if enemiesleft > 0:
		spawn_badguy()

func spawn_badguy():
	var bad = bad_inst.instance()
	var state = -1
	while state < 0:
		state = randi() % 2
		print(state)
		match state:
			1:
				if windowTimer.is_stopped() == true and windowOcc == false:
					print("Spawning window?")
					windowTimer.start()
					windowOcc = true
				else:
					print("Cant spawn in window")
					state = -1
			0:
				state = 0
	match state:
		0:
			bad.position = Vector2((randi() % 970) + 80, (randi() % 240) + 300)
			while abs((bad.position - player.position).length()) < 100:
				bad.position = Vector2((randi() % 970) + 80, (randi() % 240) + 300)
			bad.spawn_anim = "spawn_sky"
		1:
			#warning: mega jank inbound
			var lengths = [Vector2(850, 600), Vector2(515 ,600), Vector2(200 ,600)]
			var candidate = lengths[0]
			if (candidate - player.position).length() < (lengths[1] - player.position).length():
				candidate = lengths[1]
			if (candidate - player.position).length() < (lengths[2] - player.position).length():
				candidate = lengths[2]
			bad.position = candidate
			bad.spawn_anim = "spawn_window_bottom"
			
			
	add_child(bad)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_windowTimer_timeout():
	windowOcc = false
