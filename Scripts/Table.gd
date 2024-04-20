extends Area2D

class_name Table

@export var depthFront: float = 0
@export var depthBack: float = 1

var extents: Vector2

func _ready():
	var poly: CollisionPolygon2D = $poly

	extents.x = poly.polygon[0].y
	extents.y = poly.polygon[0].y

	for i in range(1, poly.polygon.size()):
		if poly.polygon[i].y > extents.y:
			extents.y = poly.polygon[i].y
		elif poly.polygon[i].y < extents.x:
			extents.x = poly.polygon[i].y

func GetDepthAtHeight(pos: float) -> float:
	return depthFront + (depthBack - depthFront) * (extents.y - pos) / (extents.y - extents.x)