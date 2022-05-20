extends Camera

## SYSTEMCAMERAVARS
# Look Settings
var Pitch = 1;
var PitchRange = 90;
var Angle = 90;
var Zoom = 1;

# Mouse position (for html5 & mobile)
var mousePos = get_viewport().get_mouse_position();
var mLockP = true;

# Effects
var Shake = 0;

# Clamps
var PitchRangePosition = 45;
var p = clamp(PitchRange, 1, 89);
var PitchClamp = Vector2(PitchRangePosition - p*.5, PitchRangePosition + p*.5);
var ZoomClamp  = Vector2(0.25, 5);

# Enablers
var enable_pitch = true;
var enable_angle = true;

# Interpolate settings
var pTo=Pitch;
var aTo=Angle;
var zTo=Zoom;

# Directional
var Forward = 0;
var Backward = 0;
var Right = 0;
var Left = 0;

# Gamepad device
var Device = 0;

# Sensitivity Settings
var Sens = {
	"Mouse"		: Vector2(.05, .05),
	"Joystick"	: Vector2(1, 2)
}

func _ready():
	camera_initialize()

func _process(delta):
	camera_update()

func camera_initialize():
	pass

func camera_update():
	pass
	
func shake_random():
	pass
	
