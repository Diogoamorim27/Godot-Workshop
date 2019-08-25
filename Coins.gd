extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_tree().get_nodes_in_group("player")[0]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Coins: " + String(player.coins)
#	pass
