extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	$".".max_value = $"../../../Player 2 Spawn".get_child(0).health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = $"../../../Player 1 Spawn".get_child(0).health
