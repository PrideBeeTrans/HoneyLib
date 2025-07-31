tool
class_name Aim2D,"res://addons/HoneyLib/Icons/Logic/Aim2D.svg"
extends Component2D

const ANGLE_WRAP_MIN := -180.0
const ANGLE_WRAP_MAX := 180.0
const SCALE_Y_NORMAL := 1.0
const SCALE_Y_FLIPPED := -1.0
const FLIP_Y_ANGLE_THRESHOLD := 90.0
const TARGET_NULL := null

enum AimMode {DISABLED, INPUT_DIR, TARGET, MOUSE}
enum RotationMode {DISABLED, INSTANT, SMOOTH}

var aim_mode : int = AimMode.MOUSE setget set_aim_mode,get_aim_mode
var rotation_mode : int = RotationMode.INSTANT setget set_rotation_mode,get_rotation_mode
var aim_pivot_path := NodePath() setget set_aim_pivot_path,get_aim_pivot_path
var smooth_speed : float = 10.0 setget set_smooth_speed,get_smooth_speed

onready var aim_pivot := get_node_or_null(aim_pivot_path) as Node2D setget set_aim_pivot,get_aim_pivot
onready var start_scale := get_aim_pivot().get_scale() as Vector2 if get_aim_pivot() != null else Vector2.ONE setget set_start_scale,get_start_scale

var input_direction := Vector2.ZERO setget set_input_direction,get_input_direction
var target : Node2D setget set_target,get_target


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == true or is_rotation_mode_disabled() == true or get_aim_pivot() == null:
		return
	update_rotation(delta)
	update_visual_flip()


func update_rotation(delta: float) -> void:
	var aim_dir := (get_aim_direction() - get_aim_pivot().get_global_position()).normalized()
	var target_angle := aim_dir.angle()

	if is_rotation_mode_smooth() == true:
		get_aim_pivot().set_rotation(lerp_angle(get_aim_pivot().get_rotation(), target_angle, delta * smooth_speed))
	elif is_rotation_mode_instant() == true:
		get_aim_pivot().set_rotation(target_angle)


func update_visual_flip() -> void:
	var angle_deg := get_facing_angle_deg()
	get_aim_pivot().scale.y = SCALE_Y_FLIPPED if angle_deg > FLIP_Y_ANGLE_THRESHOLD or angle_deg < -FLIP_Y_ANGLE_THRESHOLD else SCALE_Y_NORMAL
 

func apply_target(new_target: Node2D) -> void:
	set_aim_mode(AimMode.TARGET)
	set_target(new_target)


func reset_target() -> void:
	set_target(TARGET_NULL)


func get_facing_angle_deg() -> float:
	return wrapf(rad2deg(get_aim_pivot().get_global_rotation()), ANGLE_WRAP_MIN, ANGLE_WRAP_MAX)


func get_aim_direction() -> Vector2:
	if is_aim_mode_input_dir() == true:
		return get_input_direction()
	elif is_aim_mode_target() == true:
		return get_target().get_global_position() if get_target() != null else Vector2.ZERO
	elif is_aim_mode_mouse() == true:
		return get_global_mouse_position()
	return Vector2.ZERO


func set_start_scale(value: Vector2) -> void:
	start_scale = value


func get_start_scale() -> Vector2:
	return start_scale


func set_aim_mode(value: int) -> void:
	aim_mode = value
	property_list_changed_notify()


func get_aim_mode() -> int:
	return aim_mode
	

func is_aim_mode_disabled() -> bool:
	return get_aim_mode() == AimMode.DISABLED


func is_aim_mode_input_dir() -> bool:
	return get_aim_mode() == AimMode.INPUT_DIR


func is_aim_mode_target() -> bool:
	return get_aim_mode() == AimMode.TARGET


func is_aim_mode_mouse() -> bool:
	return get_aim_mode() == AimMode.MOUSE


func set_rotation_mode(value: int) -> void:
	rotation_mode = value
	property_list_changed_notify()


func get_rotation_mode() -> int:
	return rotation_mode


func is_rotation_mode_disabled() -> bool:
	return get_rotation_mode() == RotationMode.DISABLED


func is_rotation_mode_instant() -> bool:
	return get_rotation_mode() == RotationMode.INSTANT


func is_rotation_mode_smooth() -> bool:
	return get_rotation_mode() == RotationMode.SMOOTH


func set_input_direction(value: Vector2) -> void:
	input_direction = value


func get_input_direction() -> Vector2:
	return input_direction


func set_target(value: Node2D) -> void:
	target = value


func get_target() -> Node2D:
	return target


func set_smooth_speed(value: float) -> void:
	smooth_speed = value


func get_smooth_speed() -> float:
	return smooth_speed


func set_aim_pivot_path(value: NodePath) -> void:
	aim_pivot_path = value
	set_aim_pivot(get_node_or_null(get_aim_pivot_path()))
	update_configuration_warning()


func get_aim_pivot_path() -> NodePath:
	return aim_pivot_path


func set_aim_pivot(value: Node2D) -> void:
	aim_pivot = value


func get_aim_pivot() -> Node2D:
	return aim_pivot


func _get_configuration_warning() -> String:
	var warning := ""
	if get_aim_pivot_path().is_empty() == true:
		return "Error: Aim2D requires an AimPivot node to function. Please assign one."
	if get_aim_pivot_path().is_empty() == false:
		var aim_pivot := get_node_or_null(get_aim_pivot_path())
		if not aim_pivot is Node2D:
			return "Invalid AimPivot: expected a Node2D, got %s" % aim_pivot.get_class()
	return warning


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("Aim2D")
	properties.add_enum("aim_mode", "Disabled,InputDir,Target,Mouse")
	properties.add_enum("rotation_mode", "Disabled,Instant,Smooth")
	properties.add_node_path("aim_pivot_path")
	if is_rotation_mode_smooth() == true:
		properties.add_float("smooth_speed")
	return properties.get_properties()
