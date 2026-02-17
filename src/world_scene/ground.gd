extends MeshInstance3D

func _ready():
	# Obtener o crear el material
	var material = StandardMaterial3D.new()
	
	# Establecer el color Albedo (claro)
	material.albedo_color = Color(1, 1, 1) # Blanco (RGB)
	
	# Hacer que no reciba sombras (se vea claro sin luces)
	material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	
	# Aplicar el material a la superficie 0
	set_surface_override_material(0, material)
