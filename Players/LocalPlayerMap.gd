extends Node


onready var playerToDevice = {
	"player1": null,
	"player2": null,
	"player3": null,
	"player4": null
}


"""
Add a device to the local co-op player map. At the time of this writing, these
will only be controllers

Returns - (int) the player ID that the device was assigned to
"""
func add_device(device_id):
	print("Adding player mapping for device ID: " + str(device_id))
	if playerToDevice["player1"] == null:
		playerToDevice["player1"] = device_id
		return 1
	if playerToDevice["player2"] == null:
		playerToDevice["player2"] = device_id
		return 2
	elif playerToDevice["player3"] == null:
		playerToDevice["player3"] = device_id
		return 3
	elif playerToDevice["player4"] == null:
		playerToDevice["player4"] = device_id
		return 4
	else:
		print("Max number of players reached")
		return null


"""
Remove a device to the local co-op player map. At the time of this writing, these
will only be controllers

Returns - (int) the ID of the player that was removed
"""
func remove_device(device_id):
	var player1DeviceId = playerToDevice.get("player1")
	var player2DeviceId = playerToDevice.get("player2")
	var player3DeviceId = playerToDevice.get("player3")
	var player4DeviceId = playerToDevice.get("player4")
	
	if device_id == player1DeviceId:
		playerToDevice["player1"] = null
		return 1
	elif device_id == player2DeviceId:
		playerToDevice["player2"] = null
		return 2
	elif device_id == player3DeviceId:
		playerToDevice["player3"] = null
		return 3
	elif device_id == player4DeviceId:
		playerToDevice["player4"] = null
		return 4
	else:
		print("Player ID for device " + str(device_id) + " not found")
		return null


func get_player_id_from_device_id(device_id):
	var players = playerToDevice.keys()
	for player in players:
		if playerToDevice.get(player) == device_id:
			if player == "player1":
				return 1
			elif player == "player2":
				return 2
			elif player == "player3":
				return 3
			elif player == "player4":
				return 4
			else:
				print("Player ID for device " + str(device_id) + " not found")
				return null
	
	return null
