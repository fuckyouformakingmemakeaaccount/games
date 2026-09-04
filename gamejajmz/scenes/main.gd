extends Node2D
#enemies have to be individually linked up, multiple times if there are multiple enemies in a level. 
var score: int = 0
# what scoore will be after player's death
var scoreAfterDeath: int = score
var level: int = 1
var current_level_root: Node = null
var moreThan1Level = true
var noLongerCallSetupFrom_ready = true
#@onready var playerVar: CharacterBody2D = $"moew"

@onready var score_label: Label = $"HUD/Score Panel/Score Label"
@onready var FPS_counter_label: Label = $"FPS Counter Panel/Score Label"
@onready var level_root: Node2D = $levelRoot

func _ready() -> void:
	# setup the level
	
	current_level_root = get_node("levelRoot")
	print("current_level_root: ",current_level_root.name)
	if noLongerCallSetupFrom_ready:
		_load_level(level)
	else:
		_setup_level(current_level_root)
func _process(delta: float) -> void:
	pass
#------------------
# LEVEL MANAGEMENT
#------------------

# func for loading a level at the level number
func _load_level(level_number: int) -> void:
	# Deletes current_level_root if any exists
	if current_level_root:
		current_level_root.queue_free()
		print("die level")
	
	# Change level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	print("level_path: ",level_path)
	# Current level root becomes new level. Instantiiates level0 (?)
	current_level_root = load(level_path).instantiate()
	#adds as a child of main node
	add_child(current_level_root)
	current_level_root.name = "level_root"
	
	if noLongerCallSetupFrom_ready:
		_setup_level(current_level_root)
	
	

# This function takes level details from the level node 
# level_root was originally $levelRoot. so we pass level_root as an argument
func _setup_level(level_root) -> void:# doesnt return anything, so -> void
	
	# Connect exits. $levelRoot is dragged in from the node in question 
	var exits = level_root.get_node_or_null("Exit")#.get_node_or_null() is a method of smth which fetches a node by NodePath.
	if exits:
		print("exits: ", exits)
		exits.body_entered.connect(_on_exit_hitbox_entered)
	
	# Connect pretzels. $levelRoot is dragged in from the node in question 
	var pretzels = level_root.get_node_or_null("Pretzels")#.get_node_or_null() is a method of smth which fetches a node by NodePath.
	if pretzels:# If the Enemies node which i just made to house every enemy has nodes in it:
		# Iterate thru each child node of "pretzels" as "pretzel"
		for pretzel in pretzels.get_children():
			#Only works if script is on root node of "Pretzek" scene, not a child
			pretzel.collected.connect(increase_score)
			
			
	# Connect enemies $levelRoot is dragged in from the node in question 
	var enemies = level_root.get_node_or_null("Enemies")#.get_node_or_null() is a method of smth which fetches a node by NodePath.
	if enemies:# If the Enemies node which i just made to house every enemy has nodes in it:
		# Iterate thru each child node of "enemies" as "enemy"s 
		for enemy in enemies.get_children():
			enemy.player_hit.connect(_on_player_hit)
			
			
# --------------------------------
#####     SIGNAL HANDLERZ     ####
# --------------------------------
func _on_player_hit(player):
	player.die()
	#print("_on_player_died body: ",body.name)
	print(player.name," hit (collided with)")
	print(player.name," should die")
	await get_tree().create_timer(1).timeout
	score = scoreAfterDeath
	_load_level(level)
	
	# Resets score on hud
	score_label.text = "  : %s" % score
	
	
# handles collision between player and exit
func _on_exit_hitbox_entered(hitbox: Node2D) -> void:
	if hitbox.name == "Player":
		print("yay")
		hitbox.playerCanMove = false
		level += 1
		print(hitbox.name, " has hit the exit. It is now level ", level)
		
		# makes it so player's score is kept to what the score was upon entering this level
		scoreAfterDeath = score
		call_deferred("_load_level", level)
		# Changed from "_load_level(level)" to 
	else:
		print("hitbox.name: ", hitbox.name)
	
# --------------------------------
#####     SCORE     ####
# --------------------------------
func increase_score() -> void:
	pass
	score += 1
	print("Score:",score)
	#_load_level(level)
	# Changes Score Label text from 0 to score. This is how you let labels access variables :3
	score_label.text = "  : %s" % score
	
