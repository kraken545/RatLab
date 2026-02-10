extends CharacterBody3D

@export_group("Configuración")
@export var velocidad := 3.0
@export var world : Node3D # Aquí arrastra el 'MeshInstance3D'

var puntos : Array[Vector3] = []
var indice := 0
var buscando := false

@onready var sprite = $AnimatedSprite3D

func _ready():
	await get_tree().process_frame
	if world:
		# Buscamos los Marker3D dentro del MeshInstance3D
		for hijo in world.get_children():
			if hijo is Marker3D:
				puntos.append(hijo.global_position)
		print("Científico: Puntos encontrados: ", puntos.size())

func _physics_process(delta):
	if puntos.size() == 0 or buscando: return
	
	if not is_on_floor(): velocity.y -= 20.0 * delta

	var objetivo = puntos[indice]
	var direccion = objetivo - global_position
	direccion.y = 0

	if direccion.length() > 0.6:
		velocity.x = direccion.normalized().x * velocidad
		velocity.z = direccion.normalized().z * velocidad
		sprite.flip_h = velocity.x < -0.1
	else:
		_inspeccionar()
	
	move_and_slide()

func _inspeccionar():
	buscando = true
	# El científico busca animales por 2 segundos
	await get_tree().create_timer(2.0).timeout 
	indice = (indice + 1) % puntos.size()
	buscando = false
