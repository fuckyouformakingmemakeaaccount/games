extends CharacterBody2D

#@onready var pretzel_sprite_2d: Sprite2D = $PretzelSprite2D
var hasBeenCollected = false
# SOUNDS
@onready var pretzel_pickup_sound: AudioStreamPlayer2D = $PretzelPickupSound

signal collected

func getCollected():
	hasBeenCollected = true
	#print("Pretzel has hit ",body.name)
	
	# makes sprite invisible
	$PretzelSprite2D.visible = false
	pretzel_pickup_sound.play()
	
# COLLISION
func _on_area_2d_body_entered(body: Node2D) -> void:
	if hasBeenCollected:
		return
	if body.name == "Player" and body.playerIsAlive == true:
		# Emits a "player died" signal to be recieved at level root and sent to player
		getCollected()
		collected.emit()
