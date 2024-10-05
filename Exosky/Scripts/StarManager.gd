extends Node

# Called when the node enters the scene tree for the first time.
var starBlueprint = preload("res://Nodes/star.tscn")
var starList: Array[StarObject]

func _ready():
    import_resources_data()
    show_stars()
    
func import_resources_data():   
    var file = FileAccess.open("res://Data/RandomStars.txt", FileAccess.READ)
    while !file.eof_reached():
        var data_set = file.get_csv_line(";")
        if (data_set.size()>1):
            var star:StarObject =StarObject.new()
            var vector:Vector3 =Vector3(data_set[0].to_float(),data_set[1].to_float(),data_set[2].to_float());
            vector = vector.normalized()
            star.pos = vector
            star.radius = data_set[3].to_float()
            starList.append(star);
    file.close()

func show_stars():   
    for currentStar in starList:
        var x:Node3D = starBlueprint.instantiate()
        x.position=currentStar.pos*100
        print(x.position)
        $".".add_child(x)
       
        
