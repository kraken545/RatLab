extends CharacterBody3D

@export_group("Movimiento NPC")
@export var speed := 5.0
@export var zip_speed := 25.0
@export var gravity := 20.0

@export_group("Rutas")
@export var ruta_suelo : Node3D  # Arrastra el nodo con Marker3Ds del suelo
@export var ruta_arboles : Node3D # Arrastra el nodo con Marker3Ds de los árboles

var is_zipping := false
var zip_target_pos := Vector3.ZERO
var original_collision_mask : int
var puntos_suelo : Array[Vector3] = []
var puntos_arboles : Array[Vector3] = []
var indice_suelo := 0
var esperando := false
var objetivo_actual : Vector3

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	original_collision_mask = collision_mask
	
	# 1. Cargar puntos del suelo
	if ruta_suelo:
		for hijo in ruta_suelo.get_children():
			if hijo is Marker3D: 
				puntos_suelo.append(hijo.global_position)
	
	# 2. Cargar puntos de los árboles
	if ruta_arboles:
		for hijo in ruta_arboles.get_children():
			if hijo is Marker3D: 
				puntos_arboles.append(hijo.global_position)
	
	# Establecer el primer objetivo
	if puntos_suelo.size() > 0:
		objetivo_actual = puntos_suelo[0]

func _physics_process(delta):
	if is_zipping:
		_process_zip(delta)
		return

	# Gravedad manual
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	# Movimiento hacia el marcador actual
	var distancia = global_position.distance_to(objetivo_actual)
	
	if distancia < 1.0:
		_decidir_proxima_accion()
	else:
		var direccion = (objetivo_actual - global_position).normalized()
		velocity.x = direccion.x * speed
		velocity.z = direccion.z * speed
		
		# Girar sprite según dirección
		if direccion.x < 0: sprite.flip_h = true
		elif direccion.x > 0: sprite.flip_h = false

	move_and_slide()

func _decidir_proxima_accion():
	if esperando: return
	esperando = true
	
	# Pausa para que no parezca un robot
	await get_tree().create_timer(randf_range(1.0, 3.0)).timeout 
	
	# 30% de probabilidad de saltar a un árbol
	if randf() < 0.3 and puntos_arboles.size() > 0:
		_saltar_a_arbol()
	else:
		# Pasar al siguiente marcador de suelo
		if puntos_suelo.size() > 0:
			indice_suelo = (indice_suelo + 1) % puntos_suelo.size()
			objetivo_actual = puntos_suelo[indice_suelo]
	
	esperando = false

func _saltar_a_arbol():
	# Elige un Marker3D de la lista de árboles al azar
	zip_target_pos = puntos_arboles[randi() % puntos_arboles.size()]
	is_zipping = true
	collision_mask = 0 # Desactivar colisiones para el vuelo

func _process_zip(delta):
	var dir = (zip_target_pos - global_position).normalized()
	velocity = dir * zip_speed
	global_position += velocity * delta # Movimiento directo
	
	if global_position.distance_to(zip_target_pos) < 0.8:
		is_zipping = false
		collision_mask = original_collision_mask
		# Al bajar del árbol, vuelve al último punto de suelo conocido
		if puntos_suelo.size() > 0:
			objetivo_actual = puntos_suelo[indice_suelo]
