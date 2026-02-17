extends Control

@onready var box_niveles = $VBoxNiveles # El de los niveles
@onready var box_animales = $VBoxAnimales2 # El de los animales
@onready var history = $history # El de los animales

func _ready():
	# Al empezar, solo los niveles deben ser visibles
	box_niveles.visible = true
	box_animales.visible = false
	history.visible = false

func _on_button_pressed():
	history.visible = false     # Escondemos la historia
	box_animales.visible = true # Ahora sí, mostramos los animales

func mostrar_historia():
	box_niveles.visible = false # Escondemos los niveles
	history.visible = true      # Mostramos la imagen de la historia

func _on_niveau_1_pressed():
	Global.nivel_seleccionado = "res://src/world_scene/world.tscn"
	Global.tiempo_restante = 500.0 # 5 min
	Global.dificultad = "easy"
	mostrar_historia()

func _on_niveau_2_pressed():
	Global.nivel_seleccionado = "res://src/world_scene/world.tscn"
	Global.tiempo_restante = 300.0 # 5 min
	Global.dificultad = "normal"
	mostrar_historia()
	
func _on_niveau_3_pressed() -> void:
	Global.nivel_seleccionado = "res://src/world_scene/world.tscn"
	Global.tiempo_restante = 150.0 # 5 min
	Global.dificultad = "hard"
	mostrar_historia()

func _on_boton_animal_leon_pressed():
	Global.animal_seleccionado = "Leon"
	get_tree().change_scene_to_file(Global.nivel_seleccionado)
	
func _on_button_leon_pressed():
	Global.animal_elegido = "Leon"

func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn") # Carga tu escena principal


func _on_leeuw_pressed():
	Global.animal_elegido = "Leon"
	print("Seleccionaste: ", Global.animal_elegido)
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn") 
	# ^ Asegúrate de que esa ruta sea la de tu mundo real


func _on_panda_pressed():
	Global.animal_elegido = "Panda"
	print("Seleccionaste: ", Global.animal_elegido)
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn") 
	# ^ Asegúrate de que esa ruta sea la de tu mundo real


func _on_eend_pressed():
	Global.animal_elegido = "Eend"
	print("Seleccionaste: ", Global.animal_elegido)
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn") 
	# ^ Asegúrate de que esa ruta sea la de tu mundo real


func _on_kikker_pressed():
	Global.animal_elegido = "Kikker"
	print("Seleccionaste: ", Global.animal_elegido)
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn") 
	# ^ Asegúrate de que esa ruta sea la de tu mundo real


func _on_aap_pressed():
	Global.animal_elegido = "Aap"
	print("Seleccionaste: ", Global.animal_elegido)
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn") 
	# ^ Asegúrate de que esa ruta sea la de tu mundo real


func _on_stokstaartje_pressed():
	Global.animal_elegido = "Stokstaartje"
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn")
 

func _on_boton_nivel_1_pressed():
	Global.tiempo_maximo = 300.0 # 5 minutos
	Global.nivel_seleccionado = "Zoo"
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn")

func _on_boton_nivel_2_pressed():
	Global.tiempo_maximo = 240.0 # 4 minutos
	Global.nivel_seleccionado = "Laboratorio"
	get_tree().change_scene_to_file("res://src/world_scene/world.tscn")
	
