class_name SelectionMenu

extends Control
var selector_exoplaneta = preload("res://Nodes/option_button.tscn")
var array_archivos = []
@onready var optionButton = %OptionButton

static var rutaSeleccionada = ""
func _ready():
    add_elements()

func add_elements():
    #for i in range(10):
        #optionButton.add_item("Exoplaneta_"+str(i))
    var dir = DirAccess.open("res://Data/Exoplanets")
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name !="":
            if not dir.current_is_dir():
                array_archivos.append(file_name)
                optionButton.add_item(str(file_name).replace("_"," ").get_slice(".txt",0))
            file_name = dir.get_next()
    else:
        print("ERROR, THERE ARE NOT EXOPLANETS") 
        optionButton.add_item("ERROR, THERE ARE NOT EXOPLANETS")

func _on_button_pressed() -> void:
    var ruta_seleccionada = "res://Data/Exoplanets//"+str(array_archivos[optionButton.get_selected_id()])
    print("Ruta Seleccionada: "+str(ruta_seleccionada))
    
    rutaSeleccionada=ruta_seleccionada
    get_tree().change_scene_to_file("res://Scenes/Game3D.tscn")
