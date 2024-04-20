extends CanvasLayer

class_name Game

static var ins: Game

var pots: Node2D

@export var potIns: Array[PackedScene]

@export var plantIns: Array[PackedScene]

func _init():
	ins = self

func _ready():
	randomize()
	pots = $Pots

func SpawnPot(potId: int):
	var newPot: PlantPot = potIns[potId].instantiate()
	newPot.grabbed = true
	newPot.GenerateClickMask()
	newPot.mouseOffset = newPot.size / 2
	$Pots.add_child(newPot)

func SpawnPlant(plantId: int):
	var newPlant: Plant = plantIns[plantId].instantiate()
	newPlant.grabbed = true
	add_child(newPlant)

func SortPots():
	for pot in pots.get_children():
		var proceed: bool = true
		while proceed:
			if pot.get_index() == 0:
				proceed = false
			else:
				if pot.depth > pots.get_child(pot.get_index() - 1).depth:
					pots.move_child(pot, pot.get_index() - 1)
				else:
					proceed = false
