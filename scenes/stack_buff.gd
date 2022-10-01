tool
extends MultiMeshInstance

export (NodePath) var target_mesh_path = null setget setTargetMesh
export var stack_sheet : Texture = null setget setStackSheet
export var cols : int = 1 setget setCols
export var rows : int = 1 setget setRows
export var instances : int = 1 setget setInstances
export var inbetweens : int = 0 setget setInBetweens

func setStackSheet(param1):
	stack_sheet = param1
	_ready()

func setRows(param1):
	rows = param1
	_ready()

func setCols(param1):
	cols = param1
	_ready()
	
func setInstances(param1):
	instances = param1
	_ready()
	
func setInBetweens(param1):
	inbetweens = param1
	_ready()

func setTargetMesh(param1):
	target_mesh_path = param1
	_ready()

func get_valid_verts(mesh_inst):
	var surface_tool := SurfaceTool.new()
	surface_tool.create_from(mesh_inst.mesh,0)
	var mesh := surface_tool.commit()
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh,0)
	var verts = []
	for i in mdt.get_face_count():
		# Get the index in the vertex array.
		var a = mdt.get_face_vertex(i, 0)
		var b = mdt.get_face_vertex(i, 1)
		var c = mdt.get_face_vertex(i, 2)
		# Get vertex position using vertex index.
		var ap = mdt.get_vertex(a)
		var bp = mdt.get_vertex(b)
		var cp = mdt.get_vertex(c)
		verts.append([ap,bp,cp])
	return verts
			
func get_random_point_inside(vertices) -> Vector3:
	var a
	var b
	var tmp
	a = rand_range(0.0,1.0)
	b = rand_range(0.0,1.0)
	if (a > b):
		tmp = a
		a = b
		b = tmp
	return vertices[0] * a + vertices[1] * (b - a) + vertices[2] * (1.0 - b)
	

# Size of a "Pixel" in 3D Space
var px = 0.025

func _ready():
	if not stack_sheet:
		print('Could not render ', get_name(), '. stack_sheet is null.')
		return
	
	# Create a new mesh the size of a sprite.
	var uv_width = (stack_sheet.get_size().x as float / cols) * px
	var uv_height = (stack_sheet.get_size().y as float / rows) * px
	var surface_tool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	# Top left.
	surface_tool.add_color(Color.transparent);
	surface_tool.add_uv(Vector2(0, 0))
	surface_tool.add_vertex(Vector3(-uv_width, 0, uv_height));
	
	# Bottom left
	surface_tool.add_color(Color.transparent);
	surface_tool.add_uv(Vector2(0, 1))
	surface_tool.add_vertex(Vector3(-uv_width, 0, -uv_height));
	
	# Bottom right.
	surface_tool.add_color(Color.transparent);
	surface_tool.add_uv(Vector2(1, 1))
	surface_tool.add_vertex(Vector3(uv_width, 0, -uv_height));
	
	# Top right.
	surface_tool.add_color(Color.transparent);
	surface_tool.add_uv(Vector2(1, 0))
	surface_tool.add_vertex(Vector3(uv_width, 0, uv_height));

	# Add the indices to the surface tool.
	# Because a face is made of up two triangles, we'll need to add six indices.
	# First triangle
	surface_tool.add_index(0);
	surface_tool.add_index(1);
	surface_tool.add_index(2);
	# Second triangle
	surface_tool.add_index(0);
	surface_tool.add_index(2);
	surface_tool.add_index(3);

	# Get the resulting mesh from the surface tool, and apply it to the MeshInstance.
	multimesh = MultiMesh.new()
	multimesh.color_format = MultiMesh.COLOR_FLOAT
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = surface_tool.commit();
	material_override = material_override.duplicate()
	material_override.set_shader_param('stack_sheet', stack_sheet)



func _on_Timer_timeout():
	var target_mesh = get_node(target_mesh_path)
	var verts = get_valid_verts(target_mesh)
	# Need to move up 2x pixels or the stack looks squished
	var up_unit = px + px
	
	var gain : float = inbetweens+1
	multimesh.instance_count = rows*instances*gain
	var rel = global_transform.affine_inverse() * target_mesh.global_transform;
	for j in range(0, instances):
		verts.shuffle()
		
		var r =  rel * get_random_point_inside(verts[0])
		var rx = r[0]#rand_range(-2,2)
		var ry = r[1]
		var rz = r[2]#rand_range(-2,2)
		for i in range(0, rows):
			for k in range(0,gain):
				multimesh.set_instance_transform(j*rows*gain + i*gain + k, Transform(rel.basis * target_mesh.global_transform.basis.inverse(), Vector3(rx,  ry + (i + (k/gain)) * up_unit, rz)))
				multimesh.set_instance_color(
					j*rows*gain + i*gain + k, 
					Color(
						# Sprite width in UV
						1.0, 
						# Sprite height in UV
						1.0 / rows, 
						# Layer index this instance should render
						rows - i - 1))
