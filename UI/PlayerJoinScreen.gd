extends Control

onready var player1Label = $"GridContainer/Player1Container/Label"
onready var player1Texture = $"GridContainer/Player1Container/TextureRect"

onready var player2Label = $"GridContainer/Player2Container/Label"
onready var player2Texture = $"GridContainer/Player2Container/TextureRect"

onready var player3Label = $"GridContainer/Player3Container/Label"
onready var player3Texture = $"GridContainer/Player3Container/TextureRect"

onready var player4Label = $"GridContainer/Player4Container/Label"
onready var player4Texture = $"GridContainer/Player4Container/TextureRect"

onready var playerLabels = [player1Label, player2Label, player3Label, player4Label]
onready var playerTextures = [player1Texture, player2Texture, player3Texture, player4Texture]

onready var localPlayerMap = $"/root/LocalPlayerMap"

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


func add_device_to_local_player_map(device_id):
	var assigned_player_id = localPlayerMap.add_device(device_id)
	if assigned_player_id != null:
		# Player successfully added. Show avatar
		var playerLabel = playerLabels[assigned_player_id - 1]
		var playerTexture = playerTextures[assigned_player_id - 1]
		
		playerLabel.hide()
		playerTexture.show()


func remove_device_from_local_player_map(device_id):
	var removed_player_id = localPlayerMap.remove_device(device_id)
	if removed_player_id != null:
		# Player successfully removed. Hide avatar, show label
		var playerLabel = playerLabels[removed_player_id - 1]
		var playerTexture = playerTextures[removed_player_id - 1]
		
		playerLabel.show()
		playerTexture.hide()
