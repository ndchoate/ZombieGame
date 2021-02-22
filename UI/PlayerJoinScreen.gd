extends Control

onready var player1Label = $"GridContainer/Player1Container/Label"
onready var player1Texture = $"GridContainer/Player1Container/TextureRect"
onready var player1NotReady = $"Player1NotReady"
onready var player1Ready = $"Player1Ready"

onready var player2Label = $"GridContainer/Player2Container/Label"
onready var player2Texture = $"GridContainer/Player2Container/TextureRect"
onready var player2NotReady = $"Player2NotReady"
onready var player2Ready = $"Player2Ready"

onready var player3Label = $"GridContainer/Player3Container/Label"
onready var player3Texture = $"GridContainer/Player3Container/TextureRect"
onready var player3NotReady = $"Player3NotReady"
onready var player3Ready = $"Player3Ready"

onready var player4Label = $"GridContainer/Player4Container/Label"
onready var player4Texture = $"GridContainer/Player4Container/TextureRect"
onready var player4NotReady = $"Player4NotReady"
onready var player4Ready = $"Player4Ready"

onready var player_labels = [player1Label, player2Label, player3Label, player4Label]
onready var player_textures = [player1Texture, player2Texture, player3Texture, player4Texture]
onready var player_not_ready_labels = [player1NotReady, player2NotReady, player3NotReady, player4NotReady]
onready var player_ready_labels = [player1Ready, player2Ready, player3Ready, player4Ready]

# Player ready statuses
enum {
	NO_PLAYER,
	PLAYER_NOT_READY,
	PLAYER_READY
}

onready var player_ready_statuses = [NO_PLAYER, NO_PLAYER, NO_PLAYER, NO_PLAYER]

onready var local_player_map = $"/root/LocalPlayerMap"

# Online specific attributes
const DEFAULT_PORT = 10567

# Max number of players.
const MAX_PEERS = 4

var peer = null


func _ready():
	host_game("Player 1")


func _input(event):
	var device_id = event.get_device()
	
	if event.is_action_pressed("start_controller"):
		add_device_to_local_player_map(device_id)
			
	if event.is_action_pressed("enter_keyboard"):
		# A device_id of -1 here will signify the keyboard
		device_id = -1
		add_device_to_local_player_map(device_id)
	
	if event.is_action_pressed("back_controller"):
		remove_device_from_local_player_map(device_id)
			
	if event.is_action_pressed("esc_keyboard"):
		# A device_id of -1 here will signify the keyboard
		device_id = -1
		remove_device_from_local_player_map(device_id)
		
	var all_players_ready = check_player_ready_statuses()
	if all_players_ready:
		print("All players ready!")
		create_input_actions_for_players()
		get_tree().change_scene("res://GameView.tscn")


"""
RPC function for remote players to join a game
"""
remote func remote_player_join():
	pass
	

"""
Host a lobby for other plays to join online
"""
func host_game(new_player_name):
	# player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(peer)


func add_device_to_local_player_map(device_id):
	var assigned_player_id = local_player_map.get_player_id_from_device_id(device_id)
	if assigned_player_id == null:
		# Player is joining
		assigned_player_id = local_player_map.add_device(device_id)
		if assigned_player_id != null:
			# Player successfully added. Show avatar
			var player_label = player_labels[assigned_player_id - 1]
			var player_texture = player_textures[assigned_player_id - 1]
			var player_not_ready_label = player_not_ready_labels[assigned_player_id - 1]
			
			player_label.hide()
			player_texture.show()
			player_not_ready_label.show()
			
			player_ready_statuses[assigned_player_id - 1] = PLAYER_NOT_READY
	else:
		# Player was already added. They pressed start again, so ready up
		var player_not_ready_label = player_not_ready_labels[assigned_player_id - 1]
		var player_ready_label = player_ready_labels[assigned_player_id - 1]
		
		player_not_ready_label.hide()
		player_ready_label.show()
		
		player_ready_statuses[assigned_player_id - 1] = PLAYER_READY


func remove_device_from_local_player_map(device_id):
	var player_id = local_player_map.get_player_id_from_device_id(device_id)
	if player_id != null:
		var player_ready_status = player_ready_statuses[player_id - 1]
		var player_label = player_labels[player_id - 1]
		var player_texture = player_textures[player_id - 1]
		var player_not_ready_label = player_not_ready_labels[player_id - 1]
		var player_ready_label = player_ready_labels[player_id - 1]
		
		if player_ready_status == PLAYER_READY:
			# Player was ready to play. 
			player_ready_label.hide()
			player_not_ready_label.show()
			
			player_ready_statuses[player_id - 1] = PLAYER_NOT_READY 
		else:
			# Player ready status should be PLAYER_NOT_READY. Remove player
			var removed_player_id = local_player_map.remove_device(device_id)
			if removed_player_id != null:
				# Player successfully removed. Hide avatar, show label, and set
				# ready status
				player_label.show()
				player_texture.hide()
				player_not_ready_label.hide()
				
				player_ready_statuses[player_id - 1] = NO_PLAYER 


func check_player_ready_statuses():
	var player_statuses = []
	for status in player_ready_statuses:
		if status != NO_PLAYER:
			player_statuses.append(status)
	
	if len(player_statuses) == 0:
		return false
	
	var all_players_ready = true
	for status in player_statuses:
		if status == PLAYER_NOT_READY:
			all_players_ready = false

	return all_players_ready
	
	
func create_input_actions_for_players():
	var players = local_player_map.playerToDevice.keys()
	for player_id in players:
		var device_id = local_player_map.playerToDevice[player_id]
		
		if device_id != null:
			print("Creating input actions for " + player_id + " with device ID " 
				+ str(device_id))
			if device_id != -1:
				# device_id is for a gamepad
				create_up_action_gamepad(player_id, device_id)
				create_down_action_gamepad(player_id, device_id)
				create_left_action_gamepad(player_id, device_id)
				create_right_action_gamepad(player_id, device_id)
			else:
				# device_id is for the one keyboard allowed
				# TODO: figure out how to support multiple keyboards?
				create_up_action_keyboard(player_id)
				create_down_action_keyboard(player_id)
				create_left_action_keyboard(player_id)
				create_right_action_keyboard(player_id)


func create_up_action_gamepad(player_id, device_id):
	var action = player_id + "_up"
	InputMap.add_action(action)
	var ev = InputEventJoypadMotion.new()
	ev.axis = JOY_AXIS_1
	ev.axis_value = -0.1  # Ranges from -1.0 to 1.0. How high/low should this be?
	ev.set_device(device_id)
	InputMap.action_add_event(action, ev)


func create_down_action_gamepad(player_id, device_id):
	var action = player_id + "_down"
	InputMap.add_action(action)
	var ev = InputEventJoypadMotion.new()
	ev.axis = JOY_AXIS_1
	ev.axis_value = 0.1
	ev.set_device(device_id)
	InputMap.action_add_event(action, ev)


func create_left_action_gamepad(player_id, device_id):
	var action = player_id + "_left"
	InputMap.add_action(action)
	var ev = InputEventJoypadMotion.new()
	ev.axis = JOY_AXIS_0
	ev.axis_value = -0.1
	ev.set_device(device_id)
	InputMap.action_add_event(action, ev)


func create_right_action_gamepad(player_id, device_id):
	var action = player_id + "_right"
	InputMap.add_action(action)
	var ev = InputEventJoypadMotion.new()
	ev.axis = JOY_AXIS_0
	ev.axis_value = 0.1
	ev.set_device(device_id)
	InputMap.action_add_event(action, ev)


func create_up_action_keyboard(player_id):
	var action = player_id + "_up"
	InputMap.add_action(action)
	var ev = InputEventKey.new()
	ev.scancode = KEY_W
	InputMap.action_add_event(action, ev)


func create_down_action_keyboard(player_id):
	var action = player_id + "_down"
	InputMap.add_action(action)
	var ev = InputEventKey.new()
	ev.scancode = KEY_S
	InputMap.action_add_event(action, ev)


func create_left_action_keyboard(player_id):
	var action = player_id + "_left"
	InputMap.add_action(action)
	var ev = InputEventKey.new()
	ev.scancode = KEY_A
	InputMap.action_add_event(action, ev)


func create_right_action_keyboard(player_id):
	var action = player_id + "_right"
	InputMap.add_action(action)
	var ev = InputEventKey.new()
	ev.scancode = KEY_D
	InputMap.action_add_event(action, ev)
