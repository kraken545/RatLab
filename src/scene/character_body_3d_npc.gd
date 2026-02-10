extends CharacterBody3D

@export var ruta_padre : Node3D 
@export var velocidad := 2.0

var puntos : Array[Vector3] = []
var indice := 0

func _ready():
	# Esperamos un segundo para que el mundo se estabilice
	await get_tree().create_timer(0.5).timeout
	
	if ruta_padre:
		for hijo in ruta_padre.get_children():
			if hijo is Marker3D:
				# Guardamos la posición REAL en el mundo
				puntos.append(hijo.global_position)
		
		if puntos.size() > 0:
			# Teletransportamos al NPC al inicio de su ruta de forma segura
			global_position = puntos[0] + Vector3(0, 1, 0)
			print("NPC listo en ruta: ", ruta_padre.name)

func _physics_process(delta):
	if puntos.size() == 0: return

	# Gravedad simple
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	var objetivo = puntos[indice]
	var direccion = objetivo - global_position
	direccion.y = 0 # No queremos que el NPC intente volar o enterrarse

	if direccion.length() > 0.7:
		velocity.x = direccion.normalized().x * velocidad
		velocity.z = direccion.normalized().z * velocidad
	else:
		# Llegamos al punto, pasamos al siguiente
		indice = (indice + 1) % puntos.size()
	
	move_and_slide()
