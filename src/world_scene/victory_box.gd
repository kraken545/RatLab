extends Area3D

# Definimos la ruta de la escena de victoria
var ruta_win = "res://src/scene/win/Win.tscn" 

func _ready():
	# Conectamos la señal "body_entered" (cuerpo entró) a nosotros mismos
	# Esto le dice al Area: "Avisa cuando el jugador me toque"
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Verificamos si lo que entró es el jugador (usando el grupo que creamos)
	if body.is_in_group("jugador"):
		ganar_partida()

func ganar_partida():
	if ResourceLoader.exists(ruta_win):
		get_tree().change_scene_to_file(ruta_win)
	else:
		print("ERROR: No se encuentra la escena de victoria en: ", ruta_win)
