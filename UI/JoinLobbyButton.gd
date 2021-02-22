extends MenuButton


func _on_MenuButton_pressed():
	var ipConnectDialog = get_node("../../../IPConnectDialog")
	ipConnectDialog.popup()
	
