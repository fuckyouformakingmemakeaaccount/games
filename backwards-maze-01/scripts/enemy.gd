# Script for enemy 
extends CharacterBody3D
var dbugPrints = false # Variable that prints to the Output tab for debugging


var player = null

const movementSpeed = 5.0 # Determines movement speed
const ATTACK_RANGE = 2.5
# Animations 
@onready var animations: AnimatedSprite3D = $AnimatedSprite3D
# Pathfinding
@export var player_path : NodePath
@onready var navAgentNode = $NavigationAgent3D

func _ready() -> void:
	player = get_node(player_path)
	
func _physics_process(delta: float) -> void:
	

	# Pathfinding
	velocity = Vector3.ZERO
	navAgentNode.set_target_position(player.global_transform.origin)
	if dbugPrints:
		print("enemy: navAgentNodeNode", navAgentNode)
	var nextNavPoint = navAgentNode.get_next_path_position()
	velocity = (nextNavPoint - global_transform.origin).normalized() * movementSpeed
	
	# Conditions
	if animations.a:
		pass
	
	move_and_slide()
	
# Helper function that checks if player is in range	
func _target_in_range():
	# returns a bool of if player is within attack range
	return global_position.distance_to(player.global_postion) < ATTACK_RANGE
