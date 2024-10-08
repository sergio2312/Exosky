extends Node

var pairComplete:bool = false
var lastPos:Vector3
var currentPoints:Array[Vector3]=[]
var constellation:Array[Node]=[]
@onready var meshLine = preload("res://Scenes/line.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    lastPos=Vector3.ZERO
    currentPoints.clear()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func add_Point(vPos:Vector3):
    if(lastPos==vPos): return
    lastPos=vPos
    currentPoints.append(vPos)
    
    if(currentPoints.size()==2):
        constellation.append(createLine(currentPoints[0],currentPoints[1],Color.WHITE,50))
        currentPoints.clear()
        lastPos=Vector3.ZERO
        $"..".lastCollider=null
    
func clear_points():
    cleanup()
    currentPoints.clear()
    
#func draw_current_constellation():
    #if(currentPoints.size()>=2):
        #for i in range(currentPoints.size() - 1):  # i tomará los valores de 0 a 4
            #constellation.append(createLine(currentPoints[i],currentPoints[i+1],Color.WHITE,50))

func cleanup():
    for x in constellation:
        x.queue_free()
    constellation.clear()
        
func createLine(a, b, _color, thickness) -> Node:
    var line = meshLine.instantiate()
    %StarManager.add_child(line)
    line.scale = Vector3(0.01*thickness, 0.01*thickness, a.distance_to(b)/2)
    line.look_at_from_position((a+b)/2, b, Vector3.UP)
    return line
    
