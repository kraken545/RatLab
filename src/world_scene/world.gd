extends Node3D

func _ready():
	var animal_escena: PackedScene
	
	# Usamos animal_elegido que es el que actualizas en el menú
	match Global.animal_elegido:
		"Leon": animal_escena = load("res://src/scene/Leon3d.tscn")
		"Aap": animal_escena = load("res://src/scene/aap3d.tscn")
		"Panda": animal_escena = load("res://src/scene/panda_3d.tscn")
		"Eend": animal_escena = load("res://src/scene/eend3d.tscn")
		"Kikker": animal_escena = load("res://src/scene/kikker3d.tscn")
		"Stokstaartje": animal_escena = load("res://src/scene/ll3d.tscn")
			
	if animal_escena:
		var instancia = animal_escena.instantiate()
		add_child(instancia)
		# Colocamos al jugador en el inicio del nivel
		instancia.global_position = Vector3(0, 2, 150)
