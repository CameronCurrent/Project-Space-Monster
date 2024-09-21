extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Player One Health Bar".max_value = $"../../Player 1 Spawn".get_child(0).health
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"Player One Health Bar".value = $"../../Player 1 Spawn".get_child(0).health
	$"Player One Meter".value = $"../../Player 1 Spawn".get_child(0).meter
	$"../../Player 1 Spawn".get_child(0).meter = $"Player One Meter".value
		

