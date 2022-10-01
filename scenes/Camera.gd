extends Spatial

export (NodePath) var target

export (float, 0.0, 2.0) var rotation_speed = PI/2

# mouse properties
#export (bool) var mouse_control = true
export (float, 0.001, 0.1) var mouse_sensitivity = 0.005
export (bool) var invert_y = false
export (bool) var invert_x = false
var xTO = rotation.x
var yTO = rotation.y
# zoom settings
export (float) var max_zoom = 3.0
export (float) var min_zoom = 0.4
export (float, 0.05, 1.0) var zoom_speed = 0.09
var zoom = 1.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _unhandled_input(event):
	if event is  InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		if event.relative.x != 0:
			var dir = 1 if invert_x else -1
			var x_rotation = event.relative.x
			xTO += x_rotation*PI/180
			#rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var dir = 1 if invert_y else -1
			var y_rotation = clamp(event.relative.y, -30, 60)
			yTO += y_rotation*PI/180
			#$InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)

func get_input_keyboard(delta):
	# Rotate outer gimbal around y axis
	var y_rotation = 0
	if Input.is_action_pressed("CAMERA_RIGHT"):
		y_rotation += 1
	if Input.is_action_pressed("CAMERA_LEFT"):
		y_rotation += -1
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	# Rotate inner gimbal around local x axis
	var x_rotation = 0
	if Input.is_action_pressed("CAMERA_UP"):
		x_rotation += -1
	if Input.is_action_pressed("CAMERA_DOWN"):
		x_rotation += 1
	if Input.is_action_pressed("CAMERA_ZOOM_IN"):
		zoom -= zoom_speed
	if Input.is_action_pressed("CAMERA_ZOOM_OUT"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
	x_rotation = -x_rotation if invert_y else x_rotation
	$InnerGimbal.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)

func _process(delta):
	#if !mouse_control:
	get_input_keyboard(delta)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, -0.01)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	rotation.x = lerp(rotation.x, xTO, delta)
	$InnerGimbal.rotation.y = lerp($InnerGimbal.rotation.y, yTO, delta)
	if target:
		global_transform.origin = get_node(target).global_transform.origin
