extends CharacterBody3D

@export var speed := 12.5
@export var jump_force := 10.0
@export var gravity := 20.0
@export_group("Supervivencia")


var timer_danio := 0.0 # Para contar los 30 segundos
var velocidad_actual := 6.5

var original_collision_mask : int

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

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0
		

	# Movimiento Normal
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0: velocity.y = 0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force


	var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var input_z = Input.get_action_strength("backward") - Input.get_action_strength("forward")

	velocity.x = input_x * speed
	velocity.z = input_z * speed

	if input_x < 0 or input_z > 0: sprite.flip_h = true
	elif input_x > 0 or input_z < 0: sprite.flip_h = false

	move_and_slide()
	
