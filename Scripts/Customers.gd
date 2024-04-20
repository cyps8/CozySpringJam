extends Control

@export var requests: Array[Request]
@export var customer: PackedScene

func _ready():
	NewCustomer()

func NewCustomer():
	var newCustomer: Customer = customer.instantiate()
	newCustomer.request = requests[randi() % requests.size()]
	newCustomer.Ask()
	add_child(newCustomer)
