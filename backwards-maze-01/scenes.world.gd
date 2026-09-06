extends Node3D
@onready var hit: ColorRect = $UI/Hit
@onready var maze_floor: MeshInstance3D = $EnemyNavigationRegion3D/level/Maze_Floor


func _on_player_hit() -> void:
	pass

# Handle player taking damage
func _on_player_player_has_been_hit() -> void:
	hit.visible = true
	
	# remove collision of maze floor when player ddies, giving the illusion of falling back into maze
	for child in maze_floor.get_children():
		child.queue_free()
		
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
	pass # Replace with function body.
