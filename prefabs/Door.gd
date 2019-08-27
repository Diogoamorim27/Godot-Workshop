extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var open  = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("no_key")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Key_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("has_key")
		open = true
	pass # Replace with function body.


func _on_Door_body_entered(body):
	if body.name == "Player" and open:
		get_tree().change_scene("res://niveis/End.tscn")
