extends Resource

@export var pos: Vector3
@export var radius: float

# Si deseas añadir un método para manejar estos datos
func print_data():
	print("Position: ", pos)
	print("Weight: ", radius)
