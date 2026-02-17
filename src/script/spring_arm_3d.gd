extends SpringArm3D

@export var sensibilidad : float = 0.1

func _unhandled_input(event):
	# Si el jugador mueve el ratón
	if event is InputEventMouseMotion:
		# Girar horizontalmente (Eje Y)
		rotation_degrees.y -= event.relative.x * sensibilidad
		# Girar verticalmente (Eje X) con límites para no dar la vuelta completa
		rotation_degrees.x -= event.relative.y * sensibilidad
		rotation_degrees.x = clamp(rotation_degrees.x, -60, 30)
