extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var roundNum = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("gambe_over")
	get_tree().get_root().get_node("World").queue_free()
	$ColorRect/RichTextLabel2.text = "You got to round " + str(roundNum)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
