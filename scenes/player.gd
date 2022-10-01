extends Spatial
export (NodePath) var camera_path

# Declare member variables here. Examples:
var forward = Vector3(0,0,0)
var pos = Vector3(0,0,0)
var speed = .25
var xTo = 0
var zTo = 0
var rTo = rotation.z
var pTo = rotation.x
var t = 0
onready var boat = $boat
# Called when the node enters the scene tree for the first time.
func _ready():
	print(camera_path)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += .2*delta;
	
	if camera_path:
		var camera = get_node(camera_path)
		var forward = Vector3.ZERO
		var cam_forward = -camera.global_transform.basis.z
		var cam_axis = cam_forward.abs().max_axis()
		#forward = cam_forward
		#forward[1] = 0
		forward = global_transform.basis.z
		forward[1] = 0
		$Particles.emitting = false
		if Input:
			if Input.is_action_pressed("ui_up"):
				mov(.1*forward)
				pTo -= .1
			if Input.is_action_pressed("ui_down"):
				mov(-.1*forward)
				pTo += .1
			if Input.is_action_pressed("ui_left"):
				rot(.1)
				rTo += .1
			if Input.is_action_pressed("ui_right"):
				rot(-.1) #mov(forward.cross(Vector3.UP))
				rTo += -.1
	rTo += .2*cos(t)*delta;
	pTo += .02*cos(t)*delta;
	rTo = clamp(rTo,-1,1)
	pTo = clamp(pTo,-.1,.1)
	boat.rotation.z = lerp(boat.rotation.z, rTo,delta);#
	boat.rotation.x = lerp(boat.rotation.x,pTo,delta);
	rTo = lerp(rTo, 0, delta)
	pTo = lerp(pTo, 0, delta)

func mov(dir):
	$Particles.emitting = true
	transform.origin += speed*dir

func rot(a):
	rotation.y += speed*a
