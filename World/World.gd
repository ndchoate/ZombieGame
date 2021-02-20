extends Node2D


onready var local_player_map = $"/root/LocalPlayerMap"

onready var player1 = $"YSort/Player"
onready var player2 = $"YSort/Player2"
onready var player3 = $"YSort/Player3"
onready var player4 = $"YSort/Player4"


func _ready():
	# TODO: Combine the map of local and online players, then do this+
	for player_id in local_player_map.playerToDevice.keys():
		if local_player_map.playerToDevice[player_id] == null:
			destroy_player(player_id)
			

func destroy_player(player_id):
	if player_id == "player1":
		player1.queue_free()
	elif player_id == "player2":
		player2.queue_free()
	elif player_id == "player3":
		player3.queue_free()
	elif player_id == "player4":
		player4.queue_free()
