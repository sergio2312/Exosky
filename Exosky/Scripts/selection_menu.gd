extends Control
var selector_exoplaneta = preload("res://Nodes/option_button.tscn")
@onready var optionButton = %OptionButton

func _ready():
    add_elements()

func add_elements():
    for i in range(10):
        optionButton.add_item("Exoplaneta_"+str(i))

func _on_button_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/Game3D.tscn")
