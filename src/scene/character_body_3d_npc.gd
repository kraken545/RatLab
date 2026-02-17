extends CharacterBody3D

# Asegúrate de que este nombre coincida con lo que ves en el Inspector
@export var ruta_padre : Node3D 
@export var velocidad : float = 3.0

var puntos : Array[Vector3] = []
var indice : int = 0

func _ready():
	# Esperamos a que la escena cargue totalmente
	await get_tree().process_frame
	
	if ruta_padre:
		# Buscamos los Marker3D dentro del nodo asignado
		for hijo in ruta_padre.get_children():
			if hijo is Marker3D:
				puntos.append(hijo.global_position)
		
		if puntos.size() > 0:
			# Colocamos al personaje en el primer punto para evitar saltos
			global_position = puntos[0]
			print("Ruta cargada con ", puntos.size(), " puntos.")
	else:
		print("Error: ¡Olvidaste asignar la ruta en el Inspector!")

func _physics_process(delta):
	if puntos.size() == 0:
		return

	# Gravedad básica
	if not is_on_floor():
		velocity.y -= 20.0 * delta

	# 1. Calcular dirección al punto actual
	var objetivo = puntos[indice]
	var direccion = objetivo - global_position
	direccion.y = 0 # Ignoramos la altura para que no intente volar

	# 2. Movimiento
	if direccion.length() > 0.5:
		velocity.x = direccion.normalized().x * velocidad
		velocity.z = direccion.normalized().z * velocidad
		
		# Opcional: Rotar el personaje hacia donde camina
		# look_at(global_position + direccion, Vector3.UP) 
	else:
		# 3. Cambio de punto cuando está cerca
		indice = (indice + 1) % puntos.size()
	
	move_and_slide()
