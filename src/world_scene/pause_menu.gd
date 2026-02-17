extends CanvasLayer

@onready var container = $MenuContainer

func _ready():
	# Al empezar, nos aseguramos de que el ratón esté atrapado para la cámara
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Si el jugador pulsa la tecla ESC (mapeada como "ui_cancel" por defecto)
	if event.is_action_pressed("pause"): 
		toggle_pause()

func toggle_pause():
	# Alternamos la visibilidad del menú
	container.visible = !container.visible
	
	if container.visible:
		# Si el menú se ve, liberamos el ratón para poder hacer clic
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Opcional: pausar el tiempo del juego
		# get_tree().paused = true 
	else:
		# Si cerramos el menú, volvemos a atrapar el ratón
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		# get_tree().paused = false


func _on_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Cambiamos a la escena del menú (ajusta la ruta según tu proyecto)
	get_tree().change_scene_to_file("res://src/world_scene/menu.tscn")
