extends TextureButton

var grabbed: bool = false

var mouseOffset: Vector2 = Vector2.ZERO

var defaultPos: Vector2
var defaultSize: Vector2

var depth: float = 0.0

func _ready():
	defaultPos = position
	defaultSize = size
	GenerateClickMask()
	pivot_offset = Vector2(size.x / 2, size.y)

func Pickup():
	z_index = 10
	grabbed = true
	mouseOffset = get_global_mouse_position() - position 

func _process(_delta):
	if grabbed: 
		position = get_global_mouse_position() - mouseOffset
		Use()
	else:
		rotation = 0.0

	TableRay()

	if onTable:
		if Input.is_action_pressed("Interact"):
			UpdateScale()

func Use():
	if potsInZone.size() > 0:
		rotation = deg_to_rad(-75.0)
	else:
		rotation = 0.0

func Drop():
	z_index = 0
	grabbed = false
	position = defaultPos
	size = defaultSize

func GenerateClickMask():
	var img = texture_normal.get_image()
	var data = img
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(data)
	texture_click_mask = bitmap

var potsInZone: Array[PlantPot]

func PotEnter(area: Area2D):
	if area.is_in_group("Pot"):
		potsInZone.append(area.get_parent())

func PotExit(area: Area2D):
	if area.is_in_group("Pot"):
		potsInZone.erase(area.get_parent())

var onTable: Table = null

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