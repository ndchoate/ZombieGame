extends Camera2D


var target = null


func _physics_process(delta):
	# is_instance_valid checks if the node has been freed or not
	if target and is_instance_valid(target):
		position = target.position
