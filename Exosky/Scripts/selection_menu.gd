extends Control
var selector_exoplaneta = preload("res://Scenes/option_button.tscn")
@onready var optionButton = %OptionButton

func _ready():
    add_elements()
    
func add_elements():
    for i in range(10):
        optionButton.add_item("Exoplaneta_"+str(i))
     
