extends TextureButton

class_name PlantPot

var grabbed: bool = false

var mouseOffset: Vector2 = Vector2.ZERO

var firstDrop = true

var onTable: Table = null

var lastPos: Vector2

var depth: float = 0.0

var plantRef: Plant

func _ready():
	pivot_offset = Vector2(size.x / 2, size.y)

func _process(_delta):
	if grabbed: 
		position = get_global_mouse_position() - mouseOffset
	if firstDrop && Input.is_action_just_released("Interact"):
		FirstDrop()
		firstDrop = false
	
	TableRay()

	if onTable:
		if Input.is_action_pressed("Interact"):
			UpdateScale()

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
	Game.ins.SortPots()

func Plant(area: Area2D):
	if plantRef:
		return
	if area.is_in_group("Plant"):
		plantRef = area
		plantRef.Planted()
		plantRef.get_parent().remove_child(plantRef)
		add_child(plantRef)
		plantRef.position = $PlantZone.position
		$PlantZone.queue_free()