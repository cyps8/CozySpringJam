extends TextureButton

class_name PlantPot

var grabbed: bool = false

var mouseOffset: Vector2 = Vector2.ZERO

var firstDrop = true

var onTable: Table = null

var lastPos: Vector2

var depth: float = 0.0

var plantRef: Plant

var stage = -1

var conditionsMet: bool = false

var timeToGrow = 60.0

@export var stages: Array[Texture2D]

func _ready():
	pivot_offset = Vector2(size.x / 2, size.y)

func _process(dt):
	if grabbed: 
		position = get_global_mouse_position() - mouseOffset
	if firstDrop && Input.is_action_just_released("Interact"):
		FirstDrop()
		firstDrop = false
	
	TableRay()

	if onTable:
		$Shadow.visible = true
		if Input.is_action_pressed("Interact"):
			UpdateScale()
	else:
		$Shadow.visible = false

	if stage >= 0 && stage < 3 && plantRef:
		TryGrow(dt)
		UpdateStage()

func UpdateStage():
	match stage:
		0:
			if conditionsMet:
				$Stage.texture = stages[1]
			else:
				$Stage.texture = stages[0]
		1:
			if conditionsMet:
				$Stage.texture = stages[3]
			else:
				$Stage.texture = stages[2]
		2:
			if conditionsMet:
				$Stage.texture = stages[5]
			else:
				$Stage.texture = stages[4]
		3:
			$Stage.texture = stages[6]

func TryGrow(dt: float):
	CheckConditions()
	if conditionsMet:
		timeToGrow -= dt * Game.ins.timeSpeed
		if timeToGrow <= 0.0:
			stage += 1
			plantRef.GrowToStage(stage)
			conditionsMet = false
			timeToGrow = 60.0

func CheckConditions():
	conditionsMet = true
	if plantRef.growConditions.GetConditionAtStage(stage, GrowConditions.Condition.WATER):
		conditionsMet = false

func GenerateClickMask():
	var img = texture_normal.get_image()
	var data = img
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(data)
	texture_click_mask = bitmap

func FirstDrop():
	if !onTable:
		queue_free()
	grabbed = false
	lastPos = position

func Pickup():
	mouseOffset = get_global_mouse_position() - position
	grabbed = true

func Drop():
	var tryGrab = Customers.ins.CheckMouse()
	if tryGrab:
		if tryGrab.TryGrabPot():
			return
	if !onTable:
		position = lastPos
		TableRay()
		UpdateScale()
	grabbed = false
	lastPos = position

func TableRay():
	var space_state = get_world_2d().direct_space_state
	var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.position = global_position + Vector2(size.x / 2, (size.y) * scale.y)
	var result = space_state.intersect_point(query)
	if result:
		if result[0].collider.is_in_group("Table"):
			onTable = result[0].collider
	else:
		onTable = null
		scale = Vector2(1.0, 1.0)

func UpdateScale():
	depth = onTable.GetDepthAtHeight(global_position.y + size.y)
	scale = Vector2(1.0, 1.0) - (Vector2(depth, depth) * 0.5)
	Game.ins.SortObjs()

func Plant(area: Area2D):
	if plantRef:
		return
	stage = 0
	if area.is_in_group("Plant"):
		plantRef = area
		plantRef.Planted()
		plantRef.get_parent().remove_child(plantRef)
		add_child(plantRef)
		plantRef.position = $PlantZone.position + Vector2(0, 10)

func _exit_tree():
	if Game.ins.currentPlants.has(self):
		Game.ins.currentPlants.remove_at(Game.ins.currentPlants.find(self))
