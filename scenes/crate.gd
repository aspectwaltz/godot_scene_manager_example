extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t = 0;
var rTo = rotation.y;
var pTo = rotation.x;
var dTo = transform.origin.y;
var d0 = dTo;
var p0 = pTo;
var r0 = rTo;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += delta;
	rTo = r0 + .2*cos(t);
	dTo = d0 + .2*sin(5*t);
	pTo = p0 + .2*cos(t);
	rotation.y = lerp(rotation.y, rTo,delta)
	rotation.x = lerp(rotation.x, pTo,delta)
	transform.origin.y = lerp(transform.origin.y, dTo,delta)
	
