extends Panel

class_name Customer

var request: Request

func Ask():
	$Label.text = request.text