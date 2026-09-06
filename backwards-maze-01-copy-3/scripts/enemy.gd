# Script for enemy 
extends CharacterBody3D
var dbugPrints = false # Variable that prints to the Output tab for debugging


var player = null

var isMoving = false
const movementSpeed = 5.0 # Determines movement speed
const ATTACK_RANGE = 5
# Animations 
@onready var animations: AnimatedSprite3D = $AnimatedSprite3D
# Pathfinding
@export var player_path : NodePath
@onready var navAgentNode = $NavigationAgent3D

func _ready() -> void:
	player = get_node(player_path)
	
func _physics_process(delta: float) -> void:
	

	# Pathfinding
	if isMoving:
		velocity = Vector3.ZERO
		navAgentNode.set_target_position(player.global_transform.origin)
		if dbugPrints:
			print("enemy: navAgentNodeNode", navAgentNode)
		var nextNavPoint = navAgentNode.get_next_path_position()
		velocity = (nextNavPoint - global_transform.origin).normalized() * movementSpeed
	else:
		velocity.x = 0
		velocity.y = 0
	# Animation conditions
	if _player_is_in_range():
		animations.play("attack")
	else:
		animations.play("walk")
	
	move_and_slide()
	
# Helper function that checks if player is in range	
func _player_is_in_range():
	# returns a bool of if player is within attack range
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	#return global_position.distance_to(player.global_postion) < ATTACK_RANGE

func _player_is_hit():
	player.hit()
