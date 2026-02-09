extends CharacterBody3D



@export var speed := 6.5
@export var jump_force := 12.0
@export var gravity := 20.0

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

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
