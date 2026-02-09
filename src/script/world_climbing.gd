extends Node3D


# Drag your Marker3D node here in the inspector
@export var landing_point: Marker3D

func get_landing_position() -> Vector3:
	# Returns the global position of the marker on top
	if landing_point:
		return landing_point.global_position
	else:
		# Fallback just in case you forgot to add the marker
		return global_position + Vector3(0, 5, 0)
