extends Node

# Implemented this using an awesome KidsCanCode tutorial:
# https://www.youtube.com/watch?v=QsfG8J50hP8&feature=emb_title

onready var viewport_container1 = $"GridContainer/ViewportContainer1"
onready var viewport_container2 = $"GridContainer/ViewportContainer2"
onready var viewport_container3 = $"GridContainer/ViewportContainer3"
onready var viewport_container4 = $"GridContainer/ViewportContainer4"

onready var viewport1 = $"GridContainer/ViewportContainer1/Viewport"
onready var viewport2 = $"GridContainer/ViewportContainer2/Viewport"
onready var viewport3 = $"GridContainer/ViewportContainer3/Viewport"
onready var viewport4 = $"GridContainer/ViewportContainer4/Viewport"

onready var camera1 = $"GridContainer/ViewportContainer1/Viewport/Player1Camera"
onready var camera2 = $"GridContainer/ViewportContainer2/Viewport/Player2Camera"
onready var camera3 = $"GridContainer/ViewportContainer3/Viewport/Player3Camera"
onready var camera4 = $"GridContainer/ViewportContainer4/Viewport/Player4Camera"

onready var world = $"GridContainer/ViewportContainer1/Viewport/World"


func _ready():
	viewport2.world_2d = viewport1.world_2d
	viewport3.world_2d = viewport1.world_2d
	viewport4.world_2d = viewport1.world_2d
	
	camera1.target = world.get_node("YSort/Player")
	camera2.target = world.get_node("YSort/Player2")
	camera3.target = world.get_node("YSort/Player3")
	camera4.target = world.get_node("YSort/Player4")
	
	#viewport_container3.hide()
	#viewport_container4.hide()
	
	# The tutorial had their world laid out in a TileMap node. Need to figure out
	# if you should do things that way, or find a different way to set camera
	# limits
	#set_camera_limits()


func set_camera_limits():
	var map_limits = world.get_used_rect()
	var map_cellsize = world.cell_size
	for cam in [camera1, camera2]:
		cam.limit_left = map_limits.position.x * map_cellsize.x
		cam.limit_right = map_limits.end.x * map_cellsize.x
		cam.limit_top = map_limits.position.y * map_cellsize.y
		cam.limit_bottom = map_limits.end.y * map_cellsize.y
