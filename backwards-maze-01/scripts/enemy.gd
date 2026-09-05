# Script for enemy 
extends CharacterBody3D
var dbugPrints = false # Variable that prints to the Output tab for debugging


var player = null

var movementSpeed = 4.0 # Determines movement speed

# Animations 
@onready var animations: AnimatedSprite3D = $AnimatedSprite3D
# Pathfinding
@export var player_path : NodePath
@onready var navAgentNode = $NavigationAgent3D

func _ready() -> void:
	player = get_node(player_path)
	
func _physics_process(delta: float) -> void:
	

	# Pathfinding
	#velocity = Vector3.ZERO
	navAgentNode.set_target_position(player.global_transform.origin)
	if dbugPrints:
		print("enemy: navAgentNodeNode", navAgentNode)
	var nextNavPoint = navAgentNode.get_next_path_position()
	velocity = (nextNavPoint - global_transform.origin).normalized() * movementSpeed
	#animations.animation("idle")
	#look_at(Vector3(player.global_position.x, global_pop))
	move_and_slide()
