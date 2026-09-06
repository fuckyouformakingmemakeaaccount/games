extends Node3D
@onready var hit: ColorRect = $UI/Hit


func _on_player_hit() -> void:
	pass

# Handle player taking damage
func _on_player_player_has_been_hit() -> void:
	hit.visible = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
	pass # Replace with function body.
