extends Node2D


#var NUM_ENEMIES = 10
var NUM_ENEMIES = 1
var NUM_ENEMIES_MAX_IN_ROOM = 3
var enemiesleft # = NUM_ENEMIES
var bad_inst
var player
var countdown #= NUM_ENEMIES
var roundNum = 0

var pow1
var pow2

onready var windowTimer = get_node("windowTimer")
onready var pw_inst = preload("res://powerup.tscn")
var windowOcc = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	enemiesleft = NUM_ENEMIES
	countdown = NUM_ENEMIES
	windowOcc = false
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
		

func _process(delta):
	if $RoundOverText.visible:
		$RoundOverText.text = "TIME 'TILL NEXT ROUND: " + str($roundTimer.time_left).pad_decimals(0)

func guy_dead():
	
	countdown -= 1
	print(countdown)
	if enemiesleft > 0:
		spawn_badguy()
	enemiesleft -= 1
	if countdown <= 0:
		NUM_ENEMIES += 1
		roundNum += 1
		$RoundText.text = "Round " + str(roundNum)
		if (roundNum % 3) == 0:
			NUM_ENEMIES_MAX_IN_ROOM += 1
		var pow_group = Node2D.new() 
		pow1 = pw_inst.instance()
		pow1.type = (randi()%4) + 1
		pow1.position = Vector2(460, 320)
		pow_group.add_child(pow1)
		pow2 = pw_inst.instance()
		if $player.hp == $player.MAX_HP:
			pow2.type = (randi() % 4) + 1
			while pow2.type == pow1.type:
				pow2.type = (randi() % 4) + 1
		pow2.position = Vector2(830, 320)
		pow_group.add_child(pow2)
		add_child(pow_group)
		$roundTimer.start()
		$RoundOverText.visible = true
		

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
			
			
	if roundNum > 3:
		bad.hp = 3
	if roundNum > 7:
		bad.hp = 4
	add_child(bad)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func remove_powerups():
	if is_instance_valid(pow1):
		pow1.queue_free()
	if is_instance_valid(pow2):
		pow2.queue_free()

func _on_windowTimer_timeout():
	windowOcc = false


func _on_roundTimer_timeout():
	$RoundOverText.visible = false
	remove_powerups()
	_ready()
