extends CanvasLayer

class_name Game

static var ins: Game

var objs: Node2D

@export var potIns: Array[PackedScene]

@export var plantIns: Array[PackedScene]

@export var currentPlants: Array[PlantPot]

var day: int

var time: float

var clock: Sprite2D
var hour: Sprite2D
var minute: Sprite2D

var timeShader: Material

var timeSpeed = 1.0

var musicPlayer: AudioStreamPlayer

@export var dayMusic: Array[AudioStream]
var nextDay: int = 0
@export var nightMusic: Array[AudioStream]
var nextNight: int = 0

var playingDay: bool = true

func _init():
	ins = self

func _ready():
	randomize()
	objs = $SortedObjects
	clock = $Clock
	hour = $Clock/Hour
	minute = $Clock/Minute
	time = 100.0
	day = 1
	$Day.text = "DAY " + str(day)

	timeShader = get_tree().get_first_node_in_group("TimeShader").material
	musicPlayer = get_tree().get_first_node_in_group("MusicPlayer")

func _process(delta):
	time += delta * timeSpeed
	if time > 240.0:
		time -= 240.0
		day += 1
		$Day.text = "DAY " + str(day)
		for cus in Customers.ins.currentCustomers:
			if cus.nextDay > 0:
				cus.nextDay -= 1
	UpdateClock()
	UpdateTimeShader()
	Music()

func SpawnPot(potGroup: int):
	var potId: int = 0
	var rand: int = randi() % 3
	match potGroup:
		0:
			match rand:
				0:
					potId = 0
				1:
					potId = 1
				2:
					potId = 6
		1:
			match rand:
				0:
					potId = 3
				1:
					potId = 4
				2:
					potId = 9
		2:
			match rand:
				0:
					potId = 5
				1:
					potId = 7
				2:
					potId = 10
		3:
			potId = 2
		4:
			potId = 8

	var newPot: PlantPot = potIns[potId].instantiate()
	newPot.grabbed = true
	newPot.GenerateClickMask()
	newPot.mouseOffset = newPot.size / 2
	objs.add_child(newPot)

	currentPlants.append(newPot)

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
	hour.rotation = deg_to_rad(720.0 * (time/ 240.0))
	minute.rotation = deg_to_rad(12.0 * 720.0 * (time/ 240.0))

func TryTakePlant() -> bool:
	for plant in currentPlants:
		if plant.grabbed && plant.stage == 3:
			plant.grabbed = false
			plant.queue_free()
			currentPlants.remove_at(currentPlants.find(plant))
			return true
	return false

func ChangeSpeed(val: int):
	match val:
		0:
			timeSpeed = 1.0
		1:
			timeSpeed = 2.0
		2:
			timeSpeed = 4.0

func UpdateTimeShader():
	var nightPercentage: float = 0.0
	if time < 40.0 || time > 200.0:
		nightPercentage = 1.0
	elif time < 80:
		nightPercentage = 1.0 - (time - 40.0) / 40.0
	elif time > 160.0:
		nightPercentage = (time - 160.0) / 40.0
	timeShader.set_shader_parameter("night", nightPercentage)
	timeShader.set_shader_parameter("brightness", 1.0 - (nightPercentage * 0.1))

func Music():
	if playingDay && time > 175.0:
		FadeToMusic(nightMusic[nextNight])
		nextNight += 1
		if nextNight >= nightMusic.size():
			nextNight = 0
		playingDay = false
	elif !playingDay && time > 55.0 && time < 175.0:
		FadeToMusic(dayMusic[nextDay])
		nextDay += 1
		if nextDay >= dayMusic.size():
			nextDay = 0
		playingDay = true

func FadeToMusic(stream: AudioStream):
	var fadeTween: Tween = create_tween()
	fadeTween.tween_method(FadeLinear, 1.0, 0.0, 3.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	fadeTween.tween_callback(SwapSong.bind(stream))
	fadeTween.tween_method(FadeLinear, 0.0, 1.0, 3.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func FadeLinear(val: float):
	musicPlayer.volume_db = linear_to_db(val)

func SwapSong(stream: AudioStream):
	musicPlayer.stream = stream
	musicPlayer.play()