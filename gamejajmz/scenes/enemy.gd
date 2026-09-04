extends CharacterBody2D
@onready var enemy_animations: AnimatedSprite2D = $enemyAnimations
var affectedByGravity = false

#creates a signal to announce a player's death
signal player_hit


# COLLISION
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Orc has hit ",body.name )
	if body.name == "TileMapLayer" or body.name == "Bricks" or body.name == "Enemy":
		direction *= -1
		print(" and turned around!")
	
	elif body.name == "Player" and body.playerIsAlive == true:
		# Emits a "player died" signal to be recieved at level root and sent to player
		print("Orc has hit ",body.name)
		emit_signal("player_hit",body)
	
	
const SPEED = 100.0
var direction = -1
func _ready() -> void:
	pass # replace w funcs

# PHYSICS
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta
	if affectedByGravity:# is_on_floor is a method inherit of CharacterBody2D
		
		if not is_on_floor():
			position.y += 250 * delta
		else:
			print("on floor")
		if affectedByGravity:                 # is_on_floor is a method inherit of CharacterBody2D
			velocity += get_gravity() * delta
# have sprite face direction :3
	if direction == 1.0:
		enemy_animations.flip_h = false
	elif direction == -1.0:
		enemy_animations.flip_h = true
			
			
	


func _on_timer_timeout() -> void:
	#direction *= -1
	pass

# when
