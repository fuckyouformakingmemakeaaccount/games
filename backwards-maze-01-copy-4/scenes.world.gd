extends Node3D
@onready var hit: ColorRect = $UI/Hit


func _on_player_hit() -> void:
	pass

# Handle player taking damage
func _on_player_player_has_been_hit() -> void:
	hit.visible = true
	
	
	pass # Replace with function body.
