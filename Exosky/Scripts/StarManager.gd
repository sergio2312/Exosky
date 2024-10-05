extends Node3D

# Called when the node enters the scene tree for the first time.

Array

func _ready():
 import_resources_data()
 
var example_dict = {}

func import_resources_data():
 var file = FileAccess.open("res://Resources/RandomStars.txt", FileAccess.READ)
 while !file.eof_reached():
  var data_set = Array(file.get_csv_line())
  example_dict[example_dict.size()] = data_set
 
 file.close()
 print(example_dict)
