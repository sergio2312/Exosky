extends Control
var selector_exoplaneta = preload("res://Scenes/option_button.tscn")
@onready var optionButton = $MarginContainer/VBoxContainer/OptionButton2

func _on_play_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/Menu_select_exoplanet.tscn")

func _on_quit_pressed() -> void:
    get_tree().quit()

func _ready():
    add_elements()
    
func add_elements():
    #for i in range(10):
        #optionButton.clear()
        #
        #optionButton.add_item("Exoplaneta_"+str(i))
    pass
     
