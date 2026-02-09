extends CharacterBody3D

@export var speed := 6.5
@export var jump_force := 10.0
@export var gravity := 20.0
@export var zip_speed := 25.0 # Un poco más rápido para que se sienta mejor
@export var max_zip_distance := 50.0 
@export_group("Supervivencia")
@export var vida := 100.0
@export var hambre := 100.0
@export var hambre_consumo_rate := 1.0 # Cuánto hambre baja por segundo

var timer_danio := 0.0 # Para contar los 30 segundos
var velocidad_actual := 6.5

var is_zipping := false
var zip_target_pos := Vector3.ZERO
var original_collision_mask : int

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	# Guardamos las colisiones originales del mono
	original_collision_mask = collision_mask

func _physics_process(delta):
	hambre = clamp(hambre - hambre_consumo_rate * delta, 0, 100)

	# 2. CALCULAR VELOCIDAD SEGÚN EL HAMBRE
	var multiplicador_velocidad = 1.0
	
	if hambre <= 0:
		multiplicador_velocidad = 0.4 # Extra lento (40% de velocidad)
		_procesar_danio_por_hambre(delta)
	elif hambre <= 50:
		multiplicador_velocidad = 0.7 # Un poco lento (70% de velocidad)
	
	velocidad_actual = speed * multiplicador_velocidad

	if is_zipping:
		_process_zip(delta)
		return # Saltamos el resto del movimiento normal

	# Movimiento Normal
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0: velocity.y = 0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	if Input.is_action_just_pressed("zip_action"):
		attempt_to_zip()

	var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var input_z = Input.get_action_strength("backward") - Input.get_action_strength("forward")

	velocity.x = input_x * speed
	velocity.z = input_z * speed

	if input_x < 0 or input_z > 0: sprite.flip_h = true
	elif input_x > 0 or input_z < 0: sprite.flip_h = false

	if Input.is_action_just_pressed("zip_action"):
		attempt_to_zip()

	move_and_slide()
	
# Función para bajar vida cada 30 segundos
func _procesar_danio_por_hambre(delta):
	timer_danio += delta
	if timer_danio >= 30.0:
		vida = clamp(vida - 1, 0, 100)
		timer_danio = 0.0
		print("¡Hambre extrema! Vida restante: ", vida)
		
func attempt_to_zip():
	var targets = get_tree().get_nodes_in_group("Climbable")
	var nearest = null
	var dist_min = max_zip_distance

	for t in targets:
		var d = global_position.distance_to(t.global_position)
		if d < dist_min:
			dist_min = d
			nearest = t

	if nearest and nearest.has_method("get_landing_position"):
		zip_target_pos = nearest.get_landing_position()
		is_zipping = true
		# DESACTIVAR COLISIONES (Modo Fantasma)
		collision_mask = 0 

func _process_zip(delta):
	var dir = (zip_target_pos - global_position).normalized()
	velocity = dir * zip_speed
	
	# Mover directamente usando global_position para evitar bloqueos
	global_position += velocity * delta
	
	# Si estamos muy cerca del objetivo
	if global_position.distance_to(zip_target_pos) < 0.5:
		is_zipping = false
		velocity = Vector3.ZERO
		global_position = zip_target_pos # Ajuste final
		# ACTIVAR COLISIONES de nuevo
		collision_mask = original_collision_mask
