extends Node3D

var popup = preload("res://Scenes/PopupScene.tscn")
#Popup list_popup = Popup[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        get_tree().change_scene_to_file("res://Scenes/menu_pause.tscn")
    if Input.is_key_pressed(KEY_SPACE):
        add_child(popup.instantiate())
