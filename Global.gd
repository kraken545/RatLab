extends Node
var animal_elegido : String = "Leon" # Por defecto
# Variables que persisten entre escenas
var tiempo_maximo : float = 300.0 # 5 minutos por defecto
var tiempo_restante : float = 0.0
var nivel_seleccionado : String = ""
var animal_seleccionado : String = ""
var dificultad : String = "normal"

# Señal para avisar al Timer que debe brillar o animarse al perder tiempo
signal tiempo_penalizado(cantidad)

func restar_tiempo(cantidad: float):
	tiempo_restante -= cantidad
	emit_signal("tiempo_penalizado", cantidad)
	if tiempo_restante < 0:
		tiempo_restante = 0
