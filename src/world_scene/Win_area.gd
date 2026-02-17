extends Area3D


# Called when the node enters the scene tree for the first time.
func _on_area_escape_body_entered(body):
	if body.is_in_group("jugador"):
		get_tree().change_scene_to_file("res://src/scene/win/Win.tscn")
