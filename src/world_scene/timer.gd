extends Node3D

@onready var timer_label = $CanvasLayer/TimerLabel

func _ready():
	# Sincronizamos con Global al empezar
	Global.tiempo_restante = Global.tiempo_maximo

func perder_por_tiempo():
	# 1. Soltamos el ratón primero
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# 2. Luego cambiamos a la escena de Game Over
	get_tree().change_scene_to_file("res://src/scene/over_scene/game_over.tscn")
	
	
	

func _process(delta):
	if Global.tiempo_restante > 0:
		# Restamos el tiempo directamente en el Global
		Global.tiempo_restante -= delta
		actualizar_ui_tiempo()
	else:
		perder_por_tiempo()

func actualizar_ui_tiempo():
	var minutos = int(Global.tiempo_restante) / 60
	var segundos = int(Global.tiempo_restante) % 60
	timer_label.text = "[ %02d : %02d ]" % [minutos, segundos]
	
	# Colores de alerta
	if Global.tiempo_restante < 60:
		timer_label.modulate = Color.YELLOW
	if Global.tiempo_restante < 30:
		timer_label.modulate = Color.RED if Engine.get_frames_drawn() % 30 < 15 else Color.WHITE
