extends Label3D

func _ready():
	# IMPORTANTE: El grupo "jugador" debe estar en el CUERPO (CharacterBody3D), 
	# no en el texto. Pero dejamos la conexión aquí.
	Global.connect("tiempo_penalizado", _on_tiempo_penalizado)
	visible = false # Empezamos invisibles
	modulate.a = 1.0 # Opacidad total

func _on_tiempo_penalizado(cantidad):
	text = "-" + str(cantidad) + "s"
	visible = true
	modulate = Color(1, 0, 0) # Lo ponemos en ROJO para que resalte más
	
	var tween = create_tween()
	
	# EFECTO GIGANTE: Aumentamos la escala de golpe
	scale = Vector3(0.5, 0.5, 0.5) # Empezamos pequeño
	tween.tween_property(self, "scale", Vector3(2.5, 2.5, 2.5), 0.2).set_trans(Tween.TRANS_BOUNCE)
	
	# Movimiento hacia arriba y desvanecimiento
	tween.parallel().tween_property(self, "position:y", position.y + 2.0, 0.8)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	
	await tween.finished
	
	# Reset para el siguiente golpe
	visible = false
	position.y -= 2.0
	modulate.a = 1.0
	scale = Vector3(1, 1, 1) # Volvemos al tamaño normal
