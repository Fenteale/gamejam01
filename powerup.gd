extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var obtainable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if obtainable:
		body.add_hp(1)

		get_tree().get_root().get_node("World").remove_powerups()


func _on_Timer_timeout():
	obtainable = true
	$Sprite.modulate = Color(1, 1, 1, 1)
