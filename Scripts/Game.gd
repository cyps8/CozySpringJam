extends CanvasLayer

@export var potIns: PackedScene

func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass

func SpawnPot():
	var newPot: PlantPot = potIns.instantiate()
	newPot.grabbed = true
	newPot.mouseOffset = newPot.size / 2
	newPot.GenerateClickMask()
	add_child(newPot)
