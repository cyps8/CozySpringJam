extends CanvasLayer

class_name Game

static var ins: Game

var objs: Node2D

@export var potIns: Array[PackedScene]

@export var plantIns: Array[PackedScene]

var day: int

var time: float

var clock: Sprite2D
var hour: Sprite2D
var minute: Sprite2D

func _init():
	ins = self

func _ready():
	randomize()
	objs = $SortedObjects
	clock = $Clock
	hour = $Clock/Hour
	minute = $Clock/Minute
	time = 60.0
	day = 1
	$Day.text = "DAY " + str(day)

func _process(delta):
	time += delta
	if time > 120.0:
		time -= 120.0
		day += 1
		$Day.text = "DAY " + str(day)
	UpdateClock()

func SpawnPot(potId: int):
	var newPot: PlantPot = potIns[potId].instantiate()
	newPot.grabbed = true
	newPot.GenerateClickMask()
	newPot.mouseOffset = newPot.size / 2
	$objs.add_child(newPot)

func SpawnPlant(plantId: int):
	var newPlant: Plant = plantIns[plantId].instantiate()
	newPlant.grabbed = true
	add_child(newPlant)

func SortObjs():
	for obj in objs.get_children():
		var proceed: bool = true
		while proceed:
			if obj.get_index() == 0:
				proceed = false
			else:
				if obj.depth > objs.get_child(obj.get_index() - 1).depth:
					objs.move_child(obj, obj.get_index() - 1)
				else:
					proceed = false

func UpdateClock():
	hour.rotation = deg_to_rad(720.0 * (time/ 120.0))
	minute.rotation = deg_to_rad(12.0 * 720.0 * (time/ 120.0))