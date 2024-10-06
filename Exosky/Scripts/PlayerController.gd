extends Node3D

@export var mouse_sensitivity = 0.1
@export var FOVRange = Vector2(10,75)
@export var SensitivityRange = Vector2(0.3,0.1)
@export var fovChangeSpeed = 1
@export var progressSpeed = 1
@export var moveSpeed = 30
@export var planetradius = 50

var vPos =Vector3.UP
var sensitivity = 10
var speed = 10
var YAngle = 0 # Rotación en el eje Y
var XAngle = 0 # Rotación en el eje X
var currentFov = 75
var progressZoom = 0
var lastCollider = null
var camera_rotation = Vector2.ZERO # Rotación en el eje X

#
## La cámara
@onready var camera = %Camera
@onready var rayCast = %RayCast3D
@onready var cursor = %Cursor

func _ready():
    # Oculta el cursor y bloquea el ratón al centro de la pantalla
    vPos =Vector3.UP
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    %Camera.make_current()
    %DownView.clear_current()
    %TopView.clear_current()
    progressZoom=0
    
    
func _input(event):
    ## Detecta la entrada del ratón
    if(get_viewport().get_camera_3d() != %Camera): 
        rotation_degrees.y = 0
    else:
        if event is InputEventMouseMotion:
            YAngle -= event.relative.x * sensitivity
            XAngle -= event.relative.y * sensitivity
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
    
    #if Input.is_action_pressed("forward"):
        #global_position+=dir * moveSpeed * delta
    #if Input.is_action_pressed("backward"):
        #global_position-=dir * moveSpeed * delta
    if Input.is_action_pressed("increase_FOV"):
        progressZoom += progressSpeed * delta
    if Input.is_action_pressed("decrease_FOV"):
        progressZoom -= progressSpeed * delta
        
    if (rayCast.is_colliding() && (lastCollider != rayCast.get_collider()) && Input.is_action_just_pressed("click")):
        lastCollider = rayCast.get_collider()
        $ConstellationManager.add_Point(lastCollider.global_position)
        
    if Input.is_key_pressed(KEY_1):
        %StarManager.show_north()
        %Camera.clear_current()
        %DownView.clear_current()
        %TopView.make_current()
        %North.visible=true
        %South.visible=false
        %"3D".visible=false
        
    if Input.is_key_pressed(KEY_2):
        %StarManager.show_south()
        %Camera.clear_current()
        %DownView.make_current()
        %TopView.clear_current()
        %North.visible=false
        %South.visible=true
        %"3D".visible=false
        
    if Input.is_key_pressed(KEY_3):
        %StarManager.show_all()
        %Camera.make_current()
        %DownView.clear_current()
        %TopView.clear_current()
        %North.visible=false
        %South.visible=false
        %"3D".visible=true
        
    progressZoom = clamp(progressZoom, 0, 1)
    currentFov = lerp(FOVRange.y,FOVRange.x,progressZoom);
    sensitivity = lerp(SensitivityRange.x,SensitivityRange.y,progressZoom);
    camera.fov = currentFov
    
func is_mouse_over() -> bool:
    return rayCast.is_colliding()
