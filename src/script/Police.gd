extends CharacterBody3D

@export_group("Configuración")
@export var ruta_padre : Node3D # Arrastra aquí el nodo que tiene los Marker3D
@export var es_cientifico : bool = false # Si es falso, actúa como policía
@export var radio_vision_base : float = 18.0
@export var velocidad_patrulla : float = 5.0

var puntos_ruta : Array[Vector3] = []
var indice_actual : int = 0
var puede_hacer_danio : bool = true 
var jugador_objetivo : Node3D = null

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var alerta_icon = $AlertaIcon # Asegúrate de que este nodo exista en tu escena

func _ready():
	# Evitamos el error de "Out of bounds" esperando un frame
	await get_tree().process_frame 
	
	if ruta_padre:
		for hijo in ruta_padre.get_children():
			if hijo is Marker3D:
				puntos_ruta.append(hijo.global_position)
	
	# Buscamos al jugador por su grupo
	jugador_objetivo = get_tree().get_first_node_in_group("jugador")

func _physics_process(delta):
	# Si no hay ruta configurada, no hacemos nada para evitar errores
	if puntos_ruta.is_empty(): 
		return 

	# --- DIFICULTAD DINÁMICA ---
	var radio_actual = radio_vision_base
	if Global.dificultad == "easy":
		radio_actual = 15.0  # Te ven mucho menos
	elif Global.dificultad == "hard":
		radio_actual = 26.0  # Te ven desde muy lejos
	var vel_persecucion = 7.0
	
	# Si queda poco tiempo, se vuelven más peligrosos
	if Global.tiempo_restante < 120:
		radio_actual = radio_vision_base * 1.5
		vel_persecucion = 9.0

	var destino = puntos_ruta[indice_actual]
	var viendo_jugador = false

	# --- LÓGICA DE DETECCIÓN ---
	if jugador_objetivo:
		var dist = global_position.distance_to(jugador_objetivo.global_position)
		if dist < radio_actual:
			destino = jugador_objetivo.global_position
			viendo_jugador = true
			if puede_hacer_danio:
				aplicar_danio_tiempo()

	# --- CONTROL DEL ICONO DE ALERTA ---
	if alerta_icon:
		alerta_icon.visible = viendo_jugador # Se muestra solo si te ve

	# --- MOVIMIENTO ---
	# Pasamos las variables correctas a la función de movimiento
	_mover_npc(destino, viendo_jugador, vel_persecucion)

func aplicar_danio_tiempo():
	puede_hacer_danio = false
	var castigo = 0.0
	
	# --- LÓGICA DE DAÑO POR DIFICULTAD ---
	if Global.dificultad == "easy":
		castigo = 25.0 if es_cientifico else 20.0
	elif Global.dificultad == "normal":
		castigo = 35.0 if es_cientifico else 30.0
	elif Global.dificultad == "hard":
		castigo = 50.0 if es_cientifico else 45.0
	
	Global.restar_tiempo(castigo)
	
	# Efecto visual (opcional si ya lo tienes)
	# emit_signal("hacer_danio", castigo) 
	
	await get_tree().create_timer(1.0).timeout 
	puede_hacer_danio = true

func _mover_npc(dest, persiguiendo, v_p):
	var vel = v_p if persiguiendo else velocidad_patrulla
	var dir = (dest - global_position).normalized()
	
	# Aplicamos movimiento solo en X y Z (suelo)
	velocity.x = dir.x * vel
	velocity.z = dir.z * vel
	
	# Girar el sprite según la dirección
	if dir.x < 0: 
		sprite.flip_h = true
	elif dir.x > 0: 
		sprite.flip_h = false
	
	move_and_slide()
	
	# Si está patrullando y llega al punto, pasa al siguiente
	if not persiguiendo and global_position.distance_to(dest) < 1.5:
		indice_actual = (indice_actual + 1) % puntos_ruta.size()
