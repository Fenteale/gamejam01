extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var obtainable = false
var type = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.frame = type


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_entered(body):
	if obtainable:
		match type:
			0:
				body.add_hp(1)
			1:
				body.add_damage(1)
			2:
				body.add_pierce()
			3:
				body.decrease_reload(0.75)
			4:
				body.add_speed()

		get_tree().get_root().get_node("World").remove_powerups(true)


func _on_Timer_timeout():
	obtainable = true
	$Sprite.modulate = Color(1, 1, 1, 1)
