extends Node2D # O Node3D, dependiendo de cómo sea tu raíz

func _on_button_pressed():
	# 1. Resetear el tiempo en el Global para que no empiece en 0
	Global.tiempo_restante = Global.tiempo_maximo
	
	# 2. Cargar la escena del mundo de nuevo
	# Asegúrate de que esta ruta sea la correcta de tu nivel
	var ruta_nivel = "res://src/world_scene/world.tscn"
	
	if ResourceLoader.exists(ruta_nivel):
		get_tree().change_scene_to_file(ruta_nivel)
	else:
		get_tree().change_scene_to_file("res://src/world_scene/menu.tscn")
		# Si el nivel principal no está ahí, volvemos al menú
		


func _on_button_2_pressed() -> void:
	Global.tiempo_restante = Global.tiempo_maximo
	get_tree().change_scene_to_file("res://src/world_scene/menu.tscn")
