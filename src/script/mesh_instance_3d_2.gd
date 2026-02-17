extends MeshInstance3D

# En el Inspector, arrastra tu nodo Marker3D a este espacio
@export var landing_marker : Marker3D

func get_landing_position() -> Vector3:
	if landing_marker:
		# Devuelve la posición exacta del marcador en el mundo 3D
		return landing_marker.global_position
	else:
		# Si olvidaste asignar el marcador, aterrizará 2 metros arriba del centro del pilar
		print("Advertencia: No asignaste el Marker3D en el Inspector")
		return global_position + Vector3(0, 2, 0)
