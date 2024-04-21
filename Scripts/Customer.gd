extends Panel

class_name Customer

var request: Request

var defaultPos: Vector2

var timeToReturn: float

var returning = false

var complete = false

var nextDay = 0

func _ready():
	defaultPos = position

func _process(_delta):
	Mouse()
	if returning && Game.ins.time > timeToReturn && nextDay == 0:
		Return()

func TryGrabPot() -> bool:
	if mouse:
		if Game.ins.TryTakePlant():
			ReturnLaterPressed(10.0)
			return true
	return false

func Ask():
	$Label.text = request.text

func ReturnLaterPressed(time: float = 180.0):
	if returning:
		return

	returning = true

	var tween: Tween = create_tween()
	tween.tween_property(self, "position", defaultPos + Vector2(600, 0), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

	timeToReturn = Game.ins.time + time
	if timeToReturn > 240.0:
		nextDay += 1
		timeToReturn -= 240.0

func Return():
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", defaultPos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(func(): returning = false)

var mouse = false

func Mouse():
	var mousePos = get_global_mouse_position()
	var zone: Control = $HandInZone
	mouse = mousePos.x > zone.global_position.x && mousePos.y > zone.global_position.y && mousePos.x < zone.global_position.x + zone.size.x && mousePos.y < zone.global_position.y + zone.size.y

func GotPlant():
	if complete:
		return
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", defaultPos + Vector2(600, 0), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

	complete = true