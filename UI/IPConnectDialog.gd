extends AcceptDialog


onready var ipAddressTextBox = $"LineEdit"

var peer = null


func _on_IPConnectDialog_confirmed():
	# TODO: Call the server's "join" function
	print(ipAddressTextBox.get_text())
	
	
# TODO: Either make a join_game method here that will connect to the server,
#	create a singleton or something that you can call that method from,
#	or create a join_game method on the PlayerJoinScreen and call it from here
