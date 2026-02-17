extends CharacterBody3D



@export var speed := 15.5
@export var jump_force := 12.0
@export var gravity := 20.0

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var efecto_danio = $EfectoDanio # DEBES CREAR ESTE NODO EN LA ESCENA 3D

func _ready():
	add_to_group("jugador") # Vital para que el científico te vea
	Global.connect("tiempo_penalizado", _on_danio_recibido)
	if efecto_danio: efecto_danio.visible = false

func _on_danio_recibido(cantidad):
	if efecto_danio:
		efecto_danio.text = "- " + str(cantidad) + "s"
		efecto_danio.visible = true
		# Animación simple: sube y desaparece
		var tween = create_tween()
		tween.tween_property(efecto_danio, "position:y", 2.5, 0.5)
		tween.parallel().tween_property(efecto_danio, "modulate:a", 0, 0.5)
		await tween.finished
		efecto_danio.visible = false
		efecto_danio.position.y = 2.0
		efecto_danio.modulate.a = 1.0

func _physics_process(delta):
	# Gravedadaw
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0

	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Input
	var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var input_z = Input.get_action_strength("backward") - Input.get_action_strength("forward")

	# Movimiento
	velocity.x = input_x * speed
	velocity.z = input_z * speed

	# ---- VOLTEAR SPRITE ----
	# Default: mira a la DERECHA
	if input_x < 0 or input_z > 0:
		# Izquierda o atrás → mirar a la izquierda
		sprite.flip_h = true
	elif input_x > 0 or input_z < 0:
		# Derecha o adelante → mirar a la derecha
		sprite.flip_h = false

	move_and_slide()
