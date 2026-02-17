extends Node3D

# Este script permite que cualquier objeto sea un destino para el mono

func get_landing_position() -> Vector3:
	# Retorna la posición global exacta del Marker o del Árbol
	return global_position
