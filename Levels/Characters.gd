extends Node2D

var player_one
var player_two

# Called when the node enters the scene tree for the first time.
func _ready():
	player_one = $"Player 1 Spawn".get_child(0)
	player_one.player = 1
	player_one.define_player()
	player_two = $"Player 2 Spawn".get_child(0)
	player_two.player = 2
	player_two.define_player()
	player_one.opp = player_two
	player_two.opp = player_one

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MidCamera.position = (player_one.global_position + player_two.global_position) / 2
