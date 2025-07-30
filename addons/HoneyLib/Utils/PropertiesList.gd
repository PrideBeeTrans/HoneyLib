class_name PropertiesList
extends Object


static func create_property_list() -> Property:
	return Property.new()


func get_class() -> String:
	return "PropertiesList"


class Property:
	var properties := []
	
	
	func create_component_base(component_name: String,include_map: bool = true,registry_by_name: bool = true) -> void:
		add_category(component_name)
		add_node_path("actor_path")
		add_enum("registry_type", "Name,Class")
		if registry_by_name == true:
			add_string("component_name")
		add_bool("enabled")
		add_array("tags", "%s:" % [TYPE_STRING])
		add_category("Resources")
		
		if include_map != true:
			return
		add_resource("resource_map")
	
	
	#func add_string_enum(property_name: String)


	func add_category(category_name: String) -> void:
		add_property_usage(category_name, TYPE_NIL, PROPERTY_USAGE_CATEGORY)
	
	
	func add_node_path(property_name: String) -> void:
		add_property(property_name, TYPE_NODE_PATH)
	
	
	func add_readyonly(property_name: String,type: int) -> void:
		add_property_usage(property_name, type, PROPERTY_USAGE_EDITOR)

	
	func add_curve(property_name: String) -> void:
		add_resource(property_name, "Curve")
	
	
	func add_texture(property_name: String) -> void:
		add_resource(property_name, "Texture")
	
	
	func add_gradient(property_name: String) -> void:
		add_resource(property_name, "Gradient")
		
		
	func add_packed_scene(property_name: String) -> void:
		add_resource(property_name, "PackedScene")
	
	
	func add_int_range(property_name: String,min_range: int,max_range: int) -> void:
		add_range(property_name, TYPE_INT, "%s,%s" % [min_range,max_range])
	
		
	func add_float_range(property_name: String,min_range: float,max_range: float) -> void:
		add_range(property_name, TYPE_REAL, "%s,%s" % [min_range,max_range])
	

	func add_resource(property_name: String,hint_string: String = "Resource") -> void:
		add_property(property_name, TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, hint_string)


	func add_array(property_name: String,hint_string: String) -> void:
		add_property(property_name, TYPE_ARRAY, PROPERTY_HINT_TYPE_STRING, hint_string)
	
	
	func add_array_int(property_name: String) -> void:
		add_array(property_name, "%s:" % TYPE_INT)

	
	func add_array_string(property_name: String) -> void:
		add_array(property_name, "%s:" % TYPE_STRING)

	
	func add_array_real(property_name: String) -> void:
		add_array(property_name, "%s:" % TYPE_REAL)

	
	func add_array_dictionary(property_name: String) -> void:
		add_array(property_name, "%s:" % TYPE_DICTIONARY)

	
	func add_array_color(property_name: String) -> void:
		add_array(property_name, "%s:" % TYPE_COLOR)
	
	
	func add_array_resources(property_name: String) -> void:
		add_array(property_name, "%s:" % TYPE_OBJECT)


	func add_enum(property_name: String,enums: String) -> void:
		add_property(property_name, TYPE_INT, PROPERTY_HINT_ENUM, enums)


	func add_flags(property_name: String,flags: String) -> void:
		add_property(property_name, TYPE_INT, PROPERTY_HINT_FLAGS,flags)


	func add_flags_2d_physics(property_name: String) -> void:
		add_property(property_name, TYPE_INT, PROPERTY_HINT_LAYERS_2D_PHYSICS)


	func add_flags_2d_render(property_name: String) -> void:
		add_property(property_name, TYPE_INT, PROPERTY_HINT_LAYERS_2D_RENDER)
		

	func add_flags_2d_navigation(property_name: String) -> void:
		add_property(property_name, TYPE_INT, PROPERTY_HINT_LAYERS_2D_NAVIGATION)


	func add_flags_3d_physics(property_name: String) -> void:
		add_property(property_name, TYPE_INT, PROPERTY_HINT_LAYERS_3D_PHYSICS)


	func add_flags_3d_render(property_name: String) -> void:
		add_property(property_name, TYPE_INT, PROPERTY_HINT_LAYERS_3D_RENDER)
		

	func add_flags_3d_navigation(property_name: String) -> void:
		add_property(property_name, TYPE_INT, PROPERTY_HINT_LAYERS_3D_NAVIGATION)


	func add_exp_easing(property_name: String) -> void:
		add_property(property_name, TYPE_REAL, PROPERTY_HINT_EXP_EASING)


	func add_color(property_name: String) -> void:
		add_property(property_name, TYPE_COLOR)


	func add_color_no_alpha(property_name: String) -> void:
		add_property(property_name, TYPE_COLOR, PROPERTY_HINT_COLOR_NO_ALPHA)


	func add_range(property_name: String,type: int,hint_string: String) -> void:
		add_property(property_name, type, PROPERTY_HINT_RANGE, hint_string)


	func add_multiline(property_name: String) -> void:
		add_property(property_name, TYPE_STRING, PROPERTY_HINT_MULTILINE_TEXT)


	func add_file(property_name: String,file_extension: String = "") -> void:
		add_property(property_name, TYPE_STRING, PROPERTY_HINT_FILE, file_extension)


	func add_dir(property_name: String) -> void:
		add_property(property_name, TYPE_STRING, PROPERTY_HINT_DIR)


	func add_global_file(property_name: String,file_extension: String = "") -> void:
		add_property(property_name, TYPE_STRING, PROPERTY_HINT_GLOBAL_FILE, file_extension)


	func add_global_dir(property_name: String) -> void:
		add_property(property_name, TYPE_STRING, PROPERTY_HINT_GLOBAL_DIR)


	func add_group(group_name: String) -> void:
		add_property_usage(group_name, TYPE_NIL, PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE)


	func add_group_prefix(group_name: String,hint_string: String) -> void:
		add_property_usage(group_name, TYPE_NIL, PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE, hint_string)


	func add_int(property_name: String) -> void:
		add_property(property_name, TYPE_INT)
	
	
	func add_float(property_name: String) -> void:
		add_property(property_name, TYPE_REAL)
	
	
	func add_bool(property_name: String) -> void:
		add_property(property_name, TYPE_BOOL)
		
	
	func add_string(property_name: String) -> void:
		add_property(property_name, TYPE_STRING)
		
		
	func add_vector2(property_name: String) -> void:
		add_property(property_name, TYPE_VECTOR2)
			
			
	func add_rect2(property_name: String) -> void:
		add_property(property_name, TYPE_RECT2)
			
			
	func add_vector3(property_name: String) -> void:
		add_property(property_name, TYPE_VECTOR3)
			
			
	func add_transform2d(property_name: String) -> void:
		add_property(property_name, TYPE_TRANSFORM2D)
			
			
	func add_plane(property_name: String) -> void:
		add_property(property_name, TYPE_PLANE)
				
				
	func add_quat(property_name: String) -> void:
		add_property(property_name, TYPE_QUAT)
				
				
	func add_aabb(property_name: String) -> void:
		add_property(property_name, TYPE_AABB)
				
				
	func add_basics(property_name: String) -> void:
		add_property(property_name, TYPE_BASIS)
				
				
	func add_transform(property_name: String) -> void:
		add_property(property_name, TYPE_TRANSFORM)
				
				
	func add_dictionary(property_name: String) -> void:
		add_property(property_name, TYPE_DICTIONARY)
	
	
	func add_enum_string(property_name: String,hint_string: String) -> void:
		var usage_storage := PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE
		add_property_hint_usage(property_name, TYPE_STRING, PROPERTY_HINT_ENUM, usage_storage, hint_string)


	func add_property(property_name: String,type: int = TYPE_NIL,hint: int = PROPERTY_HINT_NONE,hint_string: String = "") -> void:
		properties.append({
			"name":property_name,
			"type":type,
			"hint":hint,
			"hint_string":hint_string,
			}
		)
	
	func add_property_type(property_name: String,type: int = TYPE_NIL,hint_string: String = "") -> void:
		properties.append({
			"name":property_name,
			"type":type,
			"hint":PROPERTY_HINT_TYPE_STRING,
			"hint_string":hint_string,
			}
		)

	func add_property_usage(property_name: String,type: int = TYPE_NIL,usage: int = PROPERTY_USAGE_DEFAULT,hint_string: String = "") -> void:
		properties.append({
			"name":property_name,
			"type":type,
			"usage":usage,
			"hint_string":hint_string,
			}
		)
		
	
	func add_property_hint_usage(property_name: String,type: int = TYPE_NIL,hint: int = PROPERTY_HINT_NONE,usage: int = PROPERTY_USAGE_DEFAULT,hint_string: String = "") -> void:
		properties.append({
			"name":property_name,
			"type":type,
			"hint":hint,
			"usage":usage,
			"hint_string":hint_string,
			}
		)


	func get_properties() -> Array:
		return properties
