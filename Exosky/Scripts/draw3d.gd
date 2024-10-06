class_name Draw3D  # Esto permite que esta clase sea accesible desde cualquier otro script como "Utils"

static func Line(pos1,pos2,color ) -> MeshInstance3D:
    var meshInstance = MeshInstance3D.new();
    var immediateMesh = ImmediateMesh.new();
    var material = StandardMaterial3D.new;
    meshInstance.Mesh = immediateMesh;
    meshInstance.CastShadow = GeometryInstance3D.ShadowCastingSetting.SHADOW_CASTING_SETTING_OFF;
    immediateMesh.surface_begin(Mesh.PRIMITIVE_LINES, material);
    immediateMesh.surface_add_vertex(pos1);
    immediateMesh.surface_add_vertex(pos2);
    immediateMesh.SurfaceEnd();
    material.ShadingMode = StandardMaterial3D.SHADING_MODE_UNSHADED;
    material.AlbedoColor = Color.WHITE
    return meshInstance;
