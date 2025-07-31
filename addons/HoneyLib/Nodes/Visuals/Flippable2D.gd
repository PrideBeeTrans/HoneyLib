tool
class_name Flippable2D,"res://addons/HoneyLib/Icons/Visuals/Flippable2D.svg"
extends Component2D

const TARGET_NULL := null

enum FacingMode {DISABLED, AUTO, INPUT_DIRECTIONAL, INPUT_SIDE_SCROLLER, TARGET, MOUSE}
enum FlipAxis {HORIZONTAL, VERTICAL, ALL}
enum MotionPriority {AUTO, DIRECTIONAL, SIDESCROLLER}

var facing_mode : int = FacingMode.DISABLED setget set_facing_mode,get_facing_mode
var flip_axis : int = FlipAxis.HORIZONTAL setget set_flip_axis,get_flip_axis
var motion_priority : int = MotionPriority.DIRECTIONAL

onready var target : Node2D setget set_target,get_target
onready var base_scale := get_scale() as Vector2 setget set_base_scale,get_base_scale

onready var directional_motion := get_component(NodeRegistry.DIRECTIONAL_MOTION_2D) as DirectionalMotion2D setget set_directional_motion,get_directional_motion
onready var side_scroller_motion := get_component(NodeRegistry.SIDE_SCROLLER_MOTION_2D) as SideScrollerMotion2D setget set_side_scroller_motion,get_side_scroller_motion


func flip_to() -> void:
	if is_invalid_flip() == true:
		return
	
	var flip_direction := get_flip_direction(target).normalized() as Vector2
	if flip_direction.is_zero_approx() == true:
		return 
	
	var flip_scale := calculate_flipped_scale(flip_direction, base_scale)
	set_scale(flip_scale)


func apply_target(new_target: Node2D) -> void:
	set_facing_target(new_target)


func reset_target() -> void:
	set_target(TARGET_NULL)


func is_invalid_flip() -> bool:
	return is_facing_disabled() == true


func calculate_flipped_scale(direction: Vector2,base_scale: Vector2) -> Vector2:
	var flip_scale := base_scale
	if flip_axis in [FlipAxis.HORIZONTAL,FlipAxis.ALL]:
		flip_scale.x = abs(base_scale.x) * (-1.0 if direction.x < 0 else 1)
	if flip_axis in [FlipAxis.VERTICAL,FlipAxis.ALL]:
		flip_scale.y = abs(base_scale.y) * (-1.0 if direction.y < 0 else 1)
	return flip_scale


func _enter_tree() -> void:
	update_configuration_warning()
	property_list_changed_notify()


func _exit_tree() -> void:
	update_configuration_warning()
	property_list_changed_notify()
	

func set_directional_motion(value: DirectionalMotion2D) -> void:
	directional_motion = value


func get_directional_motion() -> DirectionalMotion2D:
	return directional_motion


func set_side_scroller_motion(value: SideScrollerMotion2D) -> void:
	side_scroller_motion = value


func get_side_scroller_motion() -> SideScrollerMotion2D:
	return side_scroller_motion


func get_flip_direction(target: Node2D = null) -> Vector2:
	if is_facing_auto() == true:
		var motion := get_active_motion_mode()
		if motion != null and motion.has_method("get_direction"):
			return motion.get_direction()
	
	elif is_facing_input_directional() == true:
		return get_directional_motion().get_direction()
	
	elif is_facing_input_side_scroller() == true:
		return get_side_scroller_motion().get_direction()
	
	elif is_facing_mouse() == true:
		return (get_global_mouse_position() - get_global_position())
	
	elif is_facing_target() == true and target != null:
		return (target.get_global_position() - get_global_position())
	
	return Vector2.ZERO


func set_motion_priority(value: int) -> void:
	motion_priority = value


func get_motion_priority() -> int:
	return motion_priority


func is_motion_priority_auto() -> bool:
	return get_motion_priority() == MotionPriority.AUTO


func is_motion_priority_directional() -> bool:
	return get_motion_priority() == MotionPriority.DIRECTIONAL


func is_motion_priority_sidescroller() -> bool:
	return get_motion_priority() == MotionPriority.SIDESCROLLER


func get_active_motion_mode() -> Node:
	var has_directional := get_directional_motion() != null
	var has_sidescroller := get_side_scroller_motion() != null
	
	if is_motion_priority_directional() == true:
		return get_directional_motion() if has_directional == true else null
		
	elif is_motion_priority_sidescroller() == true:
		return get_side_scroller_motion() if has_sidescroller == true else null
	
	elif is_motion_priority_auto() == true:
		if has_directional == true and not has_sidescroller == true:
			return get_directional_motion()
		elif has_sidescroller == true and not has_directional == true:
			return get_side_scroller_motion()
		elif has_directional == true and has_sidescroller == true:
			return get_directional_motion()
	return null


func get_payload(payload) -> Dictionary:
	if payload is ContextHelper:
		return payload.get_all_data()
	return payload


func set_base_scale(value: Vector2) -> void:
	base_scale = value


func get_base_scale() -> Vector2:
	return base_scale


func set_target(value: Node2D) -> void:
	target = value


func get_target() -> Node2D:
	return target


func set_facing_mode(value: int) -> void:
	facing_mode = value


func get_facing_mode() -> int:
	return facing_mode


func set_facing_disabled() -> void:
	set_facing_mode(FacingMode.DISABLED)


func set_facing_auto() -> void:
	set_facing_mode(FacingMode.AUTO)


func set_facing_input_directional() -> void:
	set_facing_mode(FacingMode.INPUT_DIRECTIONAL)
	
	
func set_facing_input_side_scroller() -> void:
	set_facing_mode(FacingMode.INPUT_SIDE_SCROLLER)
	

func set_facing_mouse() -> void:
	set_facing_mode(FacingMode.MOUSE)


func set_facing_target(new_target: Node2D) -> void:
	set_facing_mode(FacingMode.TARGET)


func is_facing_disabled() -> bool:
	return get_facing_mode() == FacingMode.DISABLED


func is_facing_auto() -> bool:
	return get_facing_mode() == FacingMode.AUTO


func is_facing_input_directional() -> bool:
	return get_facing_mode() == FacingMode.INPUT_DIRECTIONAL


func is_facing_input_side_scroller() -> bool:
	return get_facing_mode() == FacingMode.INPUT_SIDE_SCROLLER


func is_facing_target() -> bool:
	return get_facing_mode() == FacingMode.TARGET


func is_facing_mouse() -> bool:
	return get_facing_mode() == FacingMode.MOUSE


func set_flip_axis(value: int) -> void:
	flip_axis = value


func get_flip_axis() -> int:
	return flip_axis


func is_flip_axis_horizontal() -> bool:
	return get_flip_axis() == FlipAxis.HORIZONTAL


func is_flip_axis_vertical() -> bool:
	return get_flip_axis() == FlipAxis.VERTICAL


func is_flip_axis_all() -> bool:
	return get_flip_axis() == FlipAxis.ALL


## Returns class name for reflection.
func get_class() -> String:
	return "Flippable2D"


func _get_configuration_warning() -> String:
	var warning := ""
	var has_directional := get_owner().find_node("DirectionalMotion2D") != null
	var has_side_scroller := get_owner().find_node("SideScrollerMotion2D") != null
	
	if has_directional == true and has_side_scroller == true:
		property_list_changed_notify()
		return "⚠️Este nó possui *DirectionalMotion2D* e *SideScrollerMotion2D*.\n" + "Prioridade atual: %s (mude usando 'motion_priority')." % [MotionPriority.keys()[motion_priority]]
	return warning


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	var has_directional := get_owner().find_node("DirectionalMotion2D") != null
	var has_side_scroller := get_owner().find_node("SideScrollerMotion2D") != null
	properties.add_category("Flippable2D")
	properties.add_enum("facing_mode", "Disabled,Auto,Input Directional,Input SideScroller,Target,Mouse")
	properties.add_enum("flip_axis", "Horizontal, Vertical,All")
	if has_directional == true and has_side_scroller == true:
		properties.add_enum("motion_priority", "Auto,Directional,SideScroller")
	return properties.get_properties()
