extends Node

# Called when the node enters the scene tree for the first time.
var starBlueprint = preload("res://Nodes/star.tscn")
var starList: Array[StarObject]
var starListNodes: Array[Node]
@export var scaleFactorMult:float = 1
@export var scaleFactorAdd:float = 0

@export var clamping:Vector2 = Vector2(0,100)
@export var distance:float = 100

func _ready():
    starListNodes.clear()
    import_resources_data()
    show_stars()
    
#func _process(delta: float) -> void:
    #show_stars()
    
func import_resources_data():   
    var file = FileAccess.open("res://Data/prueba.txt", FileAccess.READ)
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
        x.position=currentStar.pos*distance
        var fScale = currentStar.radius * scaleFactorMult + scaleFactorAdd
        var vScale = Vector3.ONE*fScale
        x.scale = vScale
        starListNodes.append(x)
        $".".add_child(x)

func _on_button_pressed() -> void:
    get_tree().quit()
    
    
func show_south():
    for star in starListNodes:
        star.visible=(star.position.y <0)
func show_north():
    for star in starListNodes:
        star.visible=(star.position.y >0)
func show_all():
    for star in starListNodes:
        star.visible=true
