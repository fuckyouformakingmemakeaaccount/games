extends CharacterBody2D

@export var speed = 10
@export var input_direction = Input.get_vector("left", "right", "up", "down")
@export var last_direction = "none"
var attacking = false
func attack():
	attacking = true
	#play_anim
	print("Player attacks")
	attacking = false


func get_input():
	# Vector2 can be used to represent 2D coordinates or any other pair of numeric values.
	input_direction = Input.get_vector("left", "right", "up", "down") #(negative_x, positive_x, negative_y, positive_y, deadzone: float = -1.0)
	#last_direction = input_direction
	velocity = input_direction * speed
	if Input.is_action_pressed("attack"):
		attack()
		

func _physics_process(delta):
	get_input()
	move_and_slide()
