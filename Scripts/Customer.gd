extends Panel

class_name Customer

var request: Request

var defaultPos: Vector2

var timeToReturn: float

var returning = false

var complete = false

func _ready():
	defaultPos = position

func _process(_delta):
	Mouse()
	if mouse && Input.is_action_just_released("Interact"):
		if Game.ins.TryTakePlant():
			GotPlant()
	if returning && Game.ins.time > timeToReturn:
		Return()

func Ask():
	$Label.text = request.text

func ReturnLaterPressed():
	if returning:
		return
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", defaultPos + Vector2(-500, 0), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

	returning = true

	timeToReturn = Game.ins.time + 3.0
	if timeToReturn > 120.0:
		timeToReturn -= 120.0

func Return():
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", defaultPos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	returning = false

var mouse = false

func Mouse():
	var mousePos = get_global_mouse_position()
	mouse = mousePos.x > global_position.x && mousePos.y > global_position.y && mousePos.x < global_position.x + size.x && global_position.y < position.y + size.y

func GotPlant():
	if complete:
		return
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", defaultPos + Vector2(-500, 0), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

	complete = true