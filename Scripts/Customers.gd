extends Control

class_name Customers

static var ins: Customers

@export var requests: Array[Request]
@export var customer: PackedScene

@export var currentCustomers: Array[Customer]

func _ready():
	ins = self
	NewCustomer()

func CheckMouse() -> Customer:
	for cus in currentCustomers:
		if cus.mouse:
			return cus
	return null

func NewCustomer():
	var newCustomer: Customer = customer.instantiate()
	newCustomer.request = requests[randi() % requests.size()]
	newCustomer.Ask()
	add_child(newCustomer)

	currentCustomers.append(newCustomer)
