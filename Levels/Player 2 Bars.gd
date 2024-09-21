extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Player Two Health Bar".max_value = $"../../Player 2 Spawn".get_child(0).health
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"Player Two Health Bar".value = $"../../Player 2 Spawn".get_child(0).health
	$"Player Two Meter".value = $"../../Player 2 Spawn".get_child(0).meter
	$"../../Player 2 Spawn".get_child(0).meter = $"Player Two Meter".value
