extends Node3D

@export var mouse_sensitivity = 0.1
@export var FOVRange = Vector2(10,75)
@export var fovChangeSpeed = 1
@export var moveSpeed = 100

var speed = 10
var YAngle = 0 # Rotación en el eje Y
var XAngle = 0 # Rotación en el eje X
var currentFov = 75
var lastCollider = null

#
## La cámara
@onready var camera = %Camera
@onready var rayCast = %RayCast3D
@onready var cursor = %Cursor

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

func _process(delta):
    if is_mouse_over():
        cursor.modulate=Color.GREEN
    else:
        cursor.modulate=Color.RED
    
    var dir = -%Camera.global_basis.z
    if Input.is_action_pressed("forward"):
        global_position+=dir * moveSpeed * delta
    if Input.is_action_pressed("backward"):
        global_position-=dir * moveSpeed * delta
    if Input.is_action_pressed("increase_FOV"):
        currentFov += fovChangeSpeed * delta
    if Input.is_action_pressed("decrease_FOV"):
        currentFov -= fovChangeSpeed * delta
    if (lastCollider != rayCast.get_collider()) && is_mouse_over() && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        lastCollider = rayCast.get_collider()
        $ConstellationManager.add_Point(lastCollider.global_position)
        
    currentFov = clamp(currentFov, FOVRange.x, FOVRange.y)
    camera.fov = currentFov

func is_mouse_over() -> bool:
    return rayCast.is_colliding()

    
