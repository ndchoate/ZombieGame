extends KinematicBody2D

export var ID = 1
export var ACCELERATION = 500
export var MAX_SPEED = 200
export var ROLL_SPEED = 125
export var FRICTION = 800

# Create the state machine
enum {
	MOVE,
	ATTACK
}

var state = MOVE

var velocity = Vector2.ZERO

onready var sprite = $Sprite

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Animation tree won't be active until the game actually starts
	animationTree.active = true


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	
	# Think of the math here as you're moving a joystick and it's creating a vector
	# on a grid
	input_vector.x = Input.get_action_strength("right%s" % ID) - Input.get_action_strength("left%s" % ID)
	input_vector.y = Input.get_action_strength("down%s" % ID) - Input.get_action_strength("up%s" % ID)
	
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		
		# TODO: Remove this once you get a proper sprite sheet
		# Flip the sprite for left/right running animation
		if input_vector.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# TODO: Remove this once you get a proper sprite sheet
		# Set the sprite back to normal after done moving
		sprite.flip_h = false
		
		animationState.travel("Idle")
		
		# This adds friction for when we stop moving
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
