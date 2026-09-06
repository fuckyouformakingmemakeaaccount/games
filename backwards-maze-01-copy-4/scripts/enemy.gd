# Script for enemy 
extends CharacterBody3D
var dbugPrints = false # Variable that prints to the Output tab for debugging


var player = null

var isMoving = true
const movementSpeed = 4 # Determines movement speed
const ATTACK_RANGE = 1.5
# Animations 
@onready var animations: AnimatedSprite3D = $AnimatedSprite3D
# Pathfinding
@export var player_path : NodePath
@onready var navAgentNode = $NavigationAgent3D
@onready var footsteps: AudioStreamPlayer3D = $FootstepsPlayer3D
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
		footsteps.stop()
		animations.play("quickattack")
		_hit_finished()
	else:
		animations.play("walk")
	
	move_and_slide()
	
# Helper function that checks if player is in range	
func _player_is_in_range():
	# returns a bool of if player is within attack range
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	#return global_position.distance_to(player.global_postion) < ATTACK_RANGE

func _hit_finished():
	
	player.isHit()
	#print("zombie has hit player")
	


func _on_animated_sprite_3d_animation_finished(e):
	if animations.animation == e:
		print("true")
		return true
		#if _player_is_in_range():
		#	
		#	_hit_finished()
		#	animations.animation = "idle"	


func _on_animated_sprite_3d_animation_looped() -> void:
	if animations.animation == "walk":
		footsteps.play()
