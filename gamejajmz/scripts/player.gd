extends CharacterBody2D

@onready var player_animations: AnimatedSprite2D = $PlayerAnimations
# ^dragging PlayerAnimations in with ctrl
var playerDirection = "left"
var playerLevel = {
	"level": 1,
	"jumping": 1,
	"jumpingExperience": 0,
	"jumpingExperienceNeeded": 100,
	"walking": 1,
	"walkingExperience": 0,
	"walkingExperienceNeeded": 1000,
	"running": 1,
	"runningExperience": 0,
	"runningExperienceNeeded": 2000
	}
var playerInitialSpeed = 80.0
var playerAcceleration = 1.25
var playerAccelerationWhenRunning = 1.35
var playerAccelerationLinear = 15
var playerDecelerationSpeed = 175
var playerDecelerationInAirSpeed = 15#playerDecelerationSpeed / 2
var playerCurrentSpeed = 0
var playerInitialUpperSpeed = 300.0
var playerUpperSpeedwhenRunning = 350
var  playerUpperSpeed = playerInitialUpperSpeed 
var playerJumpVelocity = -800.0
var playerIsMoving = false #wtf jjust happened?
var playerIsAlive = true
var playerWillAccelerate = true
var playerWillDecelerate = true
var playerCoyoteTime
var playerReleasedJumpMultiplier = 0.5
var playerLastDirectionPressed = null
var playerCanRun = false
var playerRunning = false
var playerHasVariableJumpHeight = true
# what? uh to-do: fix. just makes u go sklower
var playerAccelerationisLinear = true
var playerCanMove = true
var playerIsDead = false
var playerMovinginDirection = null
var playerTimesJumpedThisLevel = 0
var playerTimeWalkingThisLevel = 0
var playerTimeRunningThisLevel = 0

@export var playerLettingGoMaintainsSpeed = false
var dbug = true
# chetas
var infiniJumpCheat = false

# SOUNDS
@onready var jump_sound: AudioStreamPlayer2D = $Sounds/JumpSound
@onready var death_sound: AudioStreamPlayer2D = $Sounds/DeathSound


func die():
	playerIsAlive = false
	print("moew :3 player has died. poor thing (:")
	player_animations.animation = "die"
	death_sound.play()
	
# Process Physics, runs every frame
func _physics_process(delta: float) -> void:
	# Add the gravity.
	# get_gravity() is from PhysicsBody2D
	if not is_on_floor():# is_on_floor is a method inherit of CharacterBody2D
		velocity += get_gravity() * delta
		
#------------
# ANIMATIONS
#------------
	#have sprite face direction :3	
	if playerDirection == "right":
		
		player_animations.flip_h = false
	elif playerDirection == "left":
		playerDirection = "left"
		player_animations.flip_h = true
			
	# checks if player is alive and returns, ie stops rest of func code
	if dbug == true:
			if Input.is_action_just_pressed("Meow (Debug)"):
				print("\n")
				print("Dubub menu (v.04)")
				print("player velocity:", velocity)
				print("playerIsMoving:", playerIsMoving)
				print("playerCurrentSpeed:", playerCurrentSpeed)
				print("playerDirection:", playerDirection)
				print("playerRunning:", playerRunning)	
				print("playerLastDirectionPressed: ", playerLastDirectionPressed)
				print("playerMovinginDirection: ", playerMovinginDirection)
				print("playerTimesJumpedThisLevel: ", playerTimesJumpedThisLevel)
				
	if playerCanMove:
		if playerIsAlive:
			#return
		# Checks if the player is moving with the "playerIsMoving" variable by checking if velocity.x,
		# the player's horizontal velocity is less or greater than nothing, and plays corresponding animations.
			if velocity.x != 0:
				playerIsMoving = true
			else:
				playerIsMoving = false
			
			if playerIsMoving == true:
				player_animations.animation = "walks"
			else:
				# Sets 
				playerCurrentSpeed = 0
				player_animations.animation = "idle"
				
			#to-do: make jump animation
			
#---------------------
#        INPUT
#---------------------
		
		# Handle jump.playerCurrentSpeed = playerInitialSpeed
			#Checks if player is on floor.
			if is_on_floor() or infiniJumpCheat == true:
				if Input.is_action_just_pressed("Jump"):
					if playerHasVariableJumpHeight:
						velocity.y = playerJumpVelocity
					else:
						velocity.y = playerJumpVelocity
					
					# Increased Number of Times Jumped variable 
					playerTimesJumpedThisLevel += 1	
					# Handle Jump Leveling
					playerLevel.set("jumpingExperience", playerLevel["jumpingExperience"]+1)
					print("playerLevel[jumpingExperience]:",playerLevel["jumpingExperience"])
					if playerLevel["jumpingExperience"] >= playerLevel["jumpingExperienceNeeded"]:
						playerLevel["level"] += 1
						if dbug:
							print("playerLevel: ", playerLevel["level"])
						playerLevel["jumpingExperience"] = 0
						playerLevel["jumpingExperienceNeeded"] *= 1.5
						playerJumpVelocity *= 1.01* playerLevel["jumping"]
						print("playerJumpVelocity: ",playerJumpVelocity)
					#for x in playerLevel:
					#	print("playerLevel:",x)
					# plays a jump sfx :3
					jump_sound.play(.14)
			# If player is not on floor
			else:
				# If Player releases jump key, velocity will be timed by playerReleasedJumpMultiplier
				if Input.is_action_just_released("Jump"):
					velocity.y *= playerReleasedJumpMultiplier
				
			# Get the input direction and handle the movement/deceleration.
			# makes a var named "playerMovinginDirection" that returns -1 if player is pressing left and 1 if player is pressing right
			var playerMovinginDirection = Input.get_axis("Left", "Right")  
			# if either left or right is pressed
			if Input.is_action_just_pressed("Left"):
				playerLastDirectionPressed = "left"
			elif Input.is_action_just_pressed("Right"):
				playerLastDirectionPressed = "right"
			if playerMovinginDirection:
				# Checks if player is holding "Run" key, shift on keyboad
				if Input.is_action_pressed("Run"):
					if playerCanRun:
						playerRunning = true
				elif Input.is_action_just_released("Run"):
					playerRunning = false
				
				if playerRunning == true:
					playerUpperSpeed = playerUpperSpeedwhenRunning
					await get_tree().create_timer(1.0)
					playerTimeRunningThisLevel += 1
					if dbug:
						print("playerTimeRunningThisLevel: ",playerTimeRunningThisLevel)
				else:
					playerUpperSpeed = playerInitialUpperSpeed
				if playerWillAccelerate:
					#if dbug:
						#print("playerWillAccelerate")
					# Sets playerCurrentSpeed to LowerSpeed after player presses direction
					if playerCurrentSpeed < playerInitialSpeed:
						#if dbug:
							#print("And, playerCurrentSpeed < playerInitialSpeed.")
						playerCurrentSpeed = playerInitialSpeed
						#if dbug:
							#print("So we will make playerCurrentSpeed = playerInitialSpeed")
							
						#while(playerInitialSpeed < playerUpperSpeed):	
					elif playerCurrentSpeed < playerUpperSpeed:
						#print("And, playerCurrentSpeed < playerUpperSpeed")
						if playerAccelerationisLinear:
							#print("And, playerAccelerationisLinear")
							playerCurrentSpeed += playerAccelerationLinear
						else:
							# Makes playerCurrentSpeed, which velocity.x will soon be set to,
							# be multiplied by playerAcceleration until reaching playerUpperSpeed 
							playerCurrentSpeed *= playerAcceleration
					elif playerCurrentSpeed > playerUpperSpeed:
						playerCurrentSpeed = playerUpperSpeed
						#while playerCurrentSpeed < playerUpperSpeed:
						#	playerCurrentSpeed *= playerAcceleration
						#while playerCurrentSpeed < playerUpperSpeed:
						#	playerCurrentSpeed *= playerAcceleration
				else:
				# horizontal velocity becomes playerCurrentSpeed, negative if left
					playerCurrentSpeed = playerUpperSpeed
					
				#Set playerDirection to "left" or "right" depending on if velocity.x is positive or negative
				if playerDirection == "left":
					if velocity.x>0:
						playerDirection = "right"
				elif playerDirection == "right":
					if velocity.x<0:
						playerDirection = "left"
				if Input.is_action_just_pressed("Left") and Input.is_action_just_pressed("Right"):
					print("meow")
				velocity.x = playerMovinginDirection * playerCurrentSpeed
				
			else:
				
				if playerWillDecelerate:
					if playerCurrentSpeed >= playerInitialSpeed:
						# Fixed :to-do: fix bug where moving player for abt a frame causes endless movement
						# ^ Changed "if playerCurrentSpeed > playerInitialSpeed:" to "if playerCurrentSpeed >= playerInitialSpeed:"
						if is_on_floor():
							velocity.x = move_toward(velocity.x, 0, playerDecelerationSpeed)
						elif not is_on_floor():
							velocity.x = move_toward(velocity.x, 0, playerDecelerationInAirSpeed)
				
				else:
					#velocity.x = move_toward(velocity.x, 0, playerDecelerationSpeed)
					playerCurrentSpeed = playerInitialSpeed
		
		
		
			move_and_slide()
		elif playerIsAlive == false:
			if not is_on_floor():
				velocity += get_gravity() * delta
	else:
		player_animations.animation = "idle"
		#pass
# Deletes player after death animation
func _on_player_animations_animation_looped() -> void:
	if player_animations.animation == "die":
		queue_free()
		playerIsDead = true
	if player_animations.animation == "walks":
		playerTimeWalkingThisLevel += 2
		if dbug:
			print("playerTimeWalkingThisLevel: ", playerTimeWalkingThisLevel)
