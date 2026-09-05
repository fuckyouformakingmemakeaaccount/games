extends CharacterBody3D

var player = null

const SPEED = 4.0

@export var player_path : NodePath

@onready var navAgent = $NavigationAgent3D
func _ready() -> void:
	player = get_node(player_path)
	
func _physics_process(delta: float) -> void:
	# MOVEMENT
	velocity = Vector3.ZERO
	navAgent.set_target_position(player.global_transform.origin)
	if true:
		print("enemy: navAgent", navAgent)
	var nextNavPoint = navAgent.get_next_path_position()
	velocity = (nextNavPoint - global_transform.origin).normalized() * SPEED
	move_and_slide()
