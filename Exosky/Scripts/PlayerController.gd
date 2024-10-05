extends Node3D

@export var mouse_sensitivity = 0.3
var speed = 10
var YAngle = 0 # Rotación en el eje Y
var XAngle = 0 # Rotación en el eje X
#
## La cámara
@onready var camera = %Camera

func _ready():
    # Oculta el cursor y bloquea el ratón al centro de la pantalla
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
func _input(event):
    # Detecta la entrada del ratón
    if event is InputEventMouseMotion:
        YAngle -= event.relative.x * mouse_sensitivity
        XAngle -= event.relative.y * mouse_sensitivity
        # Limitar la rotación en el eje X (pitch) para evitar giros completos
        XAngle = clamp(XAngle, -90, 90)
        # Aplica la rotación al nodo principal (rotación en Y)
        rotation_degrees.y = YAngle
        # Aplica la rotación en X a la cámara (rotación en X)
        camera.rotation_degrees.x = XAngle
