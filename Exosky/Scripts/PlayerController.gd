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

#func _process(delta):
    #handle_movement(delta)
#
#func handle_movement(delta):
    ## Dirección del movimiento
    #var direction = Vector3()
#
    ## Detecta la entrada del teclado para el movimiento
    #if Input.is_action_pressed("ui_up"):
        #direction -= transform.basis.z
    #if Input.is_action_pressed("ui_down"):
        #direction += transform.basis.z
    #if Input.is_action_pressed("ui_left"):
        #direction -= transform.basis.x
    #if Input.is_action_pressed("ui_right"):
        #direction += transform.basis.x
#
    ## Normaliza la dirección para evitar movimientos diagonales más rápidos
    #direction = direction.normalized()
#
    ## Calcula la velocidad de movimiento
    #velocity.x = direction.x * speed
    #velocity.z = direction.z * speed
#
    ## Gravedad
    #if is_on_ground:
        #if Input.is_action_just_pressed("ui_jump"):
            #velocity.y = jump_speed
    #else:
        #velocity.y += gravity * delta
#
    ## Mueve al jugador
    #velocity = move_and_slide(velocity, Vector3.UP)
    #is_on_ground = is_on_floor()
