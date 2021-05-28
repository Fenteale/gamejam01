extends Node2D


const NUM_ENEMIES = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var bad_inst = preload("res://BADDIE.tscn")
	for i in range(NUM_ENEMIES):
		var bad = bad_inst.instance()
		bad.position = Vector2((randi() % 1200) + 10, (randi() % 600) + 10)
		add_child(bad)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
