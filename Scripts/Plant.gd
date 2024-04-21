extends Area2D

class_name Plant

var grabbed: bool = false

var plantSprite: Sprite2D

var blossomSprite: Sprite2D

@export var stages: Array[Texture] = []

@export var blossom: Texture

@export var growConditions: GrowConditions

func _ready():

	plantSprite = $Sprite
	blossomSprite = $Sprite/Blossom
	plantSprite.texture = stages[0]

func Planted():
	grabbed = false
	collision_layer = 0
	collision_mask = 0

	var tween: Tween = create_tween()
	tween.tween_property(plantSprite, "scale", Vector2(0.4, 0.4), 3.0)

func GrowToStage(stage: int):
	if stage <= stages.size() - 1:
		plantSprite.texture = stages[stage]
		var tween: Tween = create_tween()
		tween.tween_property(plantSprite, "scale", Vector2(0.4 + (0.3 * stage), 0.4 + (0.3 * stage)), 3.0)
	else:
		Blossom()

func Blossom():
	blossomSprite.visible = true
	blossomSprite.material.set_shader_parameter("color", Color.from_hsv(randf(), 0.75, 1.0, 1.0))

func _process(_delta):
	if grabbed && Input.is_action_just_released("Interact"):
		queue_free()

	if grabbed: 
		position = get_global_mouse_position()
