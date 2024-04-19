extends TextureButton

class_name PlantPot

var grabbed: bool = false

var mouseOffset: Vector2 = Vector2.ZERO

var firstDrop = true

func _process(_delta):
	if grabbed: 
		position = get_global_mouse_position() - mouseOffset
	if firstDrop && Input.is_action_just_released("Interact"):
		FirstDrop()
		firstDrop = false

func GenerateClickMask():
	var img = texture_normal.get_image()
	var data = img
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(data)
	texture_click_mask = bitmap

func Pickup():
	mouseOffset = get_global_mouse_position() - position
	grabbed = true

func Drop():
	grabbed = false

func FirstDrop():
	grabbed = false