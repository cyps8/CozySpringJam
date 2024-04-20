extends Area2D

class_name Plant

var grabbed: bool = false

var plantSprite: Sprite2D

var blossomSprite: Sprite2D

@export var stages: Array[Texture] = []

@export var blossom: Texture

func _ready():

	plantSprite = $Sprite
	blossomSprite = $Sprite/Blossom
	plantSprite.texture = stages[0]

func Planted():
	grabbed = false
	collision_layer = 0
	collision_mask = 0

	var tween: Tween = create_tween()
	tween.tween_property(plantSprite, "scale", Vector2(0.9, 0.9), 3.0)
	tween.tween_interval(3.0)
	tween.tween_property(plantSprite, "scale", Vector2(0.95, 0.95), 1.0)
	tween.tween_callback(func(): plantSprite.texture = stages[1])
	tween.tween_interval(3.0)
	tween.tween_property(plantSprite, "scale", Vector2(1.0, 1.0), 1.0)
	tween.tween_callback(func(): plantSprite.texture = stages[2])
	tween.tween_callback(Blossom)

func Blossom():
	blossomSprite.visible = true
	blossomSprite.material.set_shader_parameter("color", Color.from_hsv(randf(), 0.75, 1.0, 1.0))

func _process(_delta):
	if grabbed && Input.is_action_just_released("Interact"):
		queue_free()

	if grabbed: 
		position = get_global_mouse_position()
