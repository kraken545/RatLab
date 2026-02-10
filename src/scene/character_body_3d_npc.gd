extends CharacterBody3D

@export var velocidad_paseo := 1.2
@export var nodo_con_puntos : Node3D # Aquí arrastra el 'MeshInstance3D'

var puntos : Array[Vector3] = []
var indice := 0

func _ready():
	await get_tree().process_frame
	if nodo_con_puntos:
		for hijo in nodo_con_puntos.get_children():
			if hijo is Marker3D: puntos.append(hijo.global_position)

func _physics_process(delta):
	if puntos.size() == 0: return
	
	var direccion = puntos[indice] - global_position
	direccion.y = 0

	if direccion.length() > 0.5:
		velocity = direccion.normalized() * velocidad_paseo
	else:
		indice = (indice + 1) % puntos.size()
	
	move_and_slide()
