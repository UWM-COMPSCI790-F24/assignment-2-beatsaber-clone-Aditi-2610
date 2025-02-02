extends Node3D

var xr_interface: XRInterface
var right_laser_on = false 
var left_laser_on = false
@onready var right_laser = $RightController/LineRenderer  # Reference to the right laser (MeshInstance3D)
@onready var right_laser_ray = $RightController/RayCast3D
@onready var left_laser = $LeftController/LineRenderer  # Reference to the right laser (MeshInstance3D)
@onready var left_laser_ray = $LeftController/RayCast3D
var yPos: float  # Store the initial Y position of the player
signal pose_recentered  # Signal for pose recentering

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		
		get_viewport().use_xr = true
		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		xr_interface.connect("on_pose_recentered", Callable(self, "_on_pose_recentered"))
		yPos = global_position.y

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")


func _on_right_controller_button_pressed(name: String) -> void:
	if name == "ax_button":
		# Toggle the right laser visibility and interaction
		#$RightController/LineRenderer.visibility = !$RightController/LineRenderer.visibility
		right_laser_on = !right_laser_on  # Toggle the state (on/off)
		_toggle_laser(right_laser, right_laser_ray, right_laser_on)
	if name=="primary_click":
		XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true)


func _on_left_controller_button_pressed(name: String) -> void:
	if name == "ax_button":
		# Toggle the left laser visibility and interaction
		#$LeftController/LineRenderer.visibility = !$LeftController/LineRenderer.visibility
		left_laser_on = !left_laser_on  # Toggle the state (on/off)
		_toggle_laser(left_laser, left_laser_ray, left_laser_on) # Replace with function body.
		
func _toggle_laser(laser_mesh: MeshInstance3D, laser_raycast: RayCast3D, laser_on: bool):
	laser_mesh.visible = !laser_on  # Toggle visibility of the laser sword
	laser_raycast.enabled = !laser_on  # Enable or disable interaction (RayCast3D)
	
	if laser_on:
		print("Laser is ON")
		laser_raycast.cast_to = Vector3(0, 0, -1) * 1.0  # Cast 1 meter in the negative Z direction
	else:
		print("Laser is OFF")
		
func _on_pose_recentered() -> void:
	$"WorldEnvironment".emit_signal("pose_recentered")
	$"WorldEnvironment".center_on_hmd()  # Call the function to recenter the view
		
