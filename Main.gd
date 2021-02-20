extends Node

# Implemented this using an awesome KidsCanCode tutorial:
# https://www.youtube.com/watch?v=QsfG8J50hP8&feature=emb_title

onready var game_view = $"GameView"

onready var viewport_container1 = $"GameView/ViewportContainer1"
onready var viewport_container2 = $"GameView/ViewportContainer2"
onready var viewport_container3 = $"GameView/ViewportContainer3"
onready var viewport_container4 = $"GameView/ViewportContainer4"

onready var viewport1 = $"GameView/ViewportContainer1/Viewport"
onready var viewport2 = $"GameView/ViewportContainer2/Viewport"
onready var viewport3 = $"GameView/ViewportContainer3/Viewport"
onready var viewport4 = $"GameView/ViewportContainer4/Viewport"

onready var camera1 = $"GameView/ViewportContainer1/Viewport/Player1Camera"
onready var camera2 = $"GameView/ViewportContainer2/Viewport/Player2Camera"
onready var camera3 = $"GameView/ViewportContainer3/Viewport/Player3Camera"
onready var camera4 = $"GameView/ViewportContainer4/Viewport/Player4Camera"

onready var world = $"GameView/ViewportContainer1/Viewport/World"

onready var local_player_map = $"/root/LocalPlayerMap"


func _ready():
	viewport2.world_2d = viewport1.world_2d
	viewport3.world_2d = viewport1.world_2d
	viewport4.world_2d = viewport1.world_2d
	
	camera1.target = world.get_node("YSort/Player")
	camera2.target = world.get_node("YSort/Player2")
	camera3.target = world.get_node("YSort/Player3")
	camera4.target = world.get_node("YSort/Player4")
	
	var local_players_count = 0
	for player_id in local_player_map.playerToDevice.keys():
		if local_player_map.playerToDevice[player_id] != null:
			local_players_count += 1
			
			enable_player_camera(player_id)
	
	if local_players_count > 1:
#		var viewport_containers = [viewport_container1, viewport_container2, 
#								viewport_container3, viewport_container4]
#
#		for i in range(0, local_players_count):
#			viewport_containers[i].show()
		pass
	else:
		game_view.columns = 1
	
	# The tutorial had their world laid out in a TileMap node. Need to figure out
	# if you should do things that way, or find a different way to set camera
	# limits
	#set_camera_limits()


func enable_player_camera(player_id):
	if player_id == "player1":
		viewport_container1.show()
	elif player_id == "player2":
		viewport_container2.show()
	elif player_id == "player3":
		viewport_container3.show()
	elif player_id == "player4":
		viewport_container4.show()


func set_camera_limits():
	var map_limits = world.get_used_rect()
	var map_cellsize = world.cell_size
	for cam in [camera1, camera2]:
		cam.limit_left = map_limits.position.x * map_cellsize.x
		cam.limit_right = map_limits.end.x * map_cellsize.x
		cam.limit_top = map_limits.position.y * map_cellsize.y
		cam.limit_bottom = map_limits.end.y * map_cellsize.y
