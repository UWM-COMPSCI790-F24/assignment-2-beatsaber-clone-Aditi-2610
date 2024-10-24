extends XRController3D

var current_collider = null

func _ready() -> void:
	# Ensure the RayCast3D is active and retrieve the RayCast3D node from the controller
	var ray_cast = $"LineRenderer/RayCast3D"
	if ray_cast:
		ray_cast.enabled = true  # Activate RayCast3D
	else:
		#if $"MeshInstance3D/RayCast3D".is_colliding():
		#var current_Collider = $"MeshInstance3D/RayCast3D".get_collider()

		print("RayCast3D node not found!")
# Only proceed if it's a new collider or different from the previous one

func _process(delta: float) -> void:
	# Verify if RayCast3D is colliding with any objects
	var ray_cast = $"LineRenderer/RayCast3D"
	if ray_cast.is_colliding():
		var new_collider = ray_cast.get_collider()

		# Proceed only if it's a new collider or different from the last one
		if current_collider == null or current_collider != new_collider:
			current_collider = new_collider

			# Retrieve the parent of the collider (expected to be the cube)
			var cube_parent = new_collider.get_parent()
#if $"MeshInstance3D/RayCast3D" != null:
		#$"MeshInstance3D/RayCast3D".enabled = true  # Enable RayCast3D
			# Check if the cube has a method named 'split_cube'
			if cube_parent.has_method("split_cube"):
				cube_parent.split_cube()  # Invoke the method to split the cube
				$"Beeper".play()  # Trigger the beep sound effect
