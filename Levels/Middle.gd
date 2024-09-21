extends Marker2D

signal middle

# Called when the node enters the scene tree for the first time.
func _ready():
	position = ($"../Timothy".position + $"../Timothy2".position) / 2
	middle.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = ($"../Timothy".position + $"../Timothy2".position) / 2
	middle.emit()
