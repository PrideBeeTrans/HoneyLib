## EntityBody2D.gd
## A modular 2D movement base class for entities using `KinematicBody2D`.
## Supports grounded or floating motion modes, slope snapping, ceiling sliding,
## movement utility helpers (impulses, forces), and editor-customizable inspector.

tool
class_name EntityBody2D,"res://addons/HoneyLib/Icons/Physics/EntityBody2D.svg"
extends KinematicBody2D

## --- Constants ---

## Motion types.
enum MotionModes { GROUNDED, FLOATING }

## Inspector limits
const MIN_ANGLE := 0.0
const MAX_ANGLE := 180.0
const MIN_SNAP_LENGTH := 0.0
const MAX_SNAP_LENGTH := 32.0

## Maps motion modes to up directions
const MOTION_DIRECTIONS := {
	MotionModes.GROUNDED: Vector2.UP,
	MotionModes.FLOATING: Vector2.ZERO,
}

## --- Properties ---

## Motion mode (GROUNDED or FLOATING).
var motion_mode : int = MotionModes.GROUNDED setget set_motion_mode, get_motion_mode
## Direction used as 'up' for slope handling.
var up_direction : Vector2 = MOTION_DIRECTIONS[motion_mode] setget set_up_direction, get_up_direction
## Allow sliding on ceilings.
var slide_on_ceiling := true setget set_slide_on_ceiling, get_slide_on_ceiling

## Stop movement when hitting slopes.
var floor_stop_on_slope := true setget set_floor_stop_on_slope, get_floor_stop_on_slope
## Keep speed when climbing slopes.
var floor_constant_speed := false setget set_floor_constant_speed, get_floor_constant_speed
## Prevent wall sticking when on slopes.
var floor_block_on_wall := true setget set_floor_block_on_wall, get_floor_block_on_wall
## Max allowed collisions per frame.
var floor_max_slides := 4 setget set_floor_max_slides, get_floor_max_slides
## Max slope angle (in radians).
var floor_max_angle := 0.785398 setget set_floor_max_angle, get_floor_max_angle
## Snap distance used to keep grounded.
var floor_snap_length := 1.0 setget set_floor_snap_length, get_floor_snap_length

## Minimum angle to slide on wall (FLOATING mode).
var wall_min_slide_angle := 0.261799 setget set_wall_min_slide_angle, get_wall_min_slide_angle

## Movement velocity (usually manipulated externally).
var velocity := Vector2.ZERO setget set_velocity, get_velocity
## Snap vector applied in grounded mode.
var snap_vector := Vector2.ZERO setget set_snap_vector, get_snap_vector
## Optional resource (e.g., stat map).
var resource_map : Resource = null setget set_resource_map, get_resource_map

## --- Core Movement ---

## Processes entity movement based on current mode.
func motion_and_slide() -> void:
	if is_mode_grounded():
		if snap_vector != Vector2.ZERO:
			set_velocity(move_and_slide_with_snap(get_velocity(), snap_vector, get_up_direction(), floor_stop_on_slope, floor_max_slides, floor_max_angle))
		else:
			set_velocity(move_and_slide(get_velocity(), get_up_direction(), floor_stop_on_slope, floor_max_slides, floor_max_angle))
	elif is_mode_floating():
		set_velocity(move_and_slide(get_velocity(), get_up_direction(), false, floor_max_slides, wall_min_slide_angle))

## Applies drag over time (e.g., air resistance).
func apply_air_drag(delta: float, drag: float = 0.2) -> void:
	var factor := clamp(1.0 - drag * delta, 0.0, 1.0)
	set_velocity(get_velocity() * factor)

## Applies snap for grounded slope sticking.
func apply_snap(length: float = get_floor_snap_length(), direction: Vector2 = Vector2.DOWN) -> void:
	snap_vector = direction.normalized() * length if length > 0.0 else Vector2.ZERO

## Applies impulse relative to entity mass.
func apply_mass_impulse(impulse: Vector2, mass: float = 1.0) -> void:
	set_velocity(get_velocity() + impulse / max(mass, 0.001))

## Applies continuous force (F = ma).
func apply_force(force: Vector2, delta: float) -> void:
	set_velocity(get_velocity() + force * delta)

## Applies impulse in both axes.
func apply_impulse(impulse: Vector2) -> void:
	apply_impulse_horizontal(impulse.x)
	apply_impulse_vertical(impulse.y)

## Applies impulse horizontally.
func apply_impulse_horizontal(impulse: float) -> void:
	velocity.x += impulse

## Applies impulse vertically.
func apply_impulse_vertical(impulse: float) -> void:
	velocity.y += impulse

## Slides velocity along wall normal.
func slide_along_wall(normal: Vector2) -> void:
	set_velocity(get_velocity().slide(normal))

## --- Utility Checks ---

## Returns true if floor is too steep.
func is_on_steep_slope(max_angle: float = get_floor_max_angle()) -> bool:
	return is_on_floor() and get_floor_normal().angle_to(get_up_direction()) > max_angle

## Returns true if only on floor.
func is_on_floor_only() -> bool:
	return is_on_floor() and not is_on_ceiling() and not is_on_wall()

## Returns true if only on ceiling.
func is_on_ceiling_only() -> bool:
	return is_on_ceiling() and not is_on_floor() and not is_on_wall()

## Returns true if only on wall.
func is_on_wall_only() -> bool:
	return is_on_wall() and not is_on_floor() and not is_on_ceiling()

## --- Velocity Control ---
func set_velocity_x(value: float) -> void:
	velocity.x = value


func get_velocity_x() -> float:
	return velocity.x


func set_velocity_y(value: float) -> void:
	velocity.y = value


func get_velocity_y() -> float:
	return velocity.y


## Resets velocity in both axes.
func reset_velocity() -> void:
	reset_velocity_horizontal()
	reset_velocity_vertical()

## Resets horizontal velocity.
func reset_velocity_horizontal() -> void:
	velocity.x = 0

## Resets vertical velocity.
func reset_velocity_vertical() -> void:
	velocity.y = 0

## Returns absolute horizontal velocity.
func get_horizontal_speed() -> float:
	return abs(get_velocity().x)

## Returns absolute vertical velocity.
func get_vertical_speed() -> float:
	return abs(get_velocity().y)

## Returns movement direction (-1, 0, 1).
func get_move_direction() -> int:
	return int(sign(get_velocity().x))

## --- Getters & Setters ---

func set_motion_mode(value: int) -> void:
	motion_mode = value
	set_up_direction(MOTION_DIRECTIONS[motion_mode])
	property_list_changed_notify()

func get_motion_mode() -> int:
	return motion_mode

func is_mode_grounded() -> bool:
	return motion_mode == MotionModes.GROUNDED

func is_mode_floating() -> bool:
	return motion_mode == MotionModes.FLOATING

func set_up_direction(value: Vector2) -> void:
	up_direction = value

func get_up_direction() -> Vector2:
	return up_direction

func set_slide_on_ceiling(value: bool) -> void:
	slide_on_ceiling = value

func get_slide_on_ceiling() -> bool:
	return slide_on_ceiling

func set_floor_stop_on_slope(value: bool) -> void:
	floor_stop_on_slope = value

func get_floor_stop_on_slope() -> bool:
	return floor_stop_on_slope

func set_floor_constant_speed(value: bool) -> void:
	floor_constant_speed = value

func get_floor_constant_speed() -> bool:
	return floor_constant_speed

func set_floor_block_on_wall(value: bool) -> void:
	floor_block_on_wall = value

func get_floor_block_on_wall() -> bool:
	return floor_block_on_wall

func set_floor_max_slides(value: int) -> void:
	floor_max_slides = value

func get_floor_max_slides() -> int:
	return floor_max_slides

func set_floor_max_angle(value: float) -> void:
	floor_max_angle = value

func get_floor_max_angle() -> float:
	return floor_max_angle

func set_floor_snap_length(value: float) -> void:
	floor_snap_length = value

func get_floor_snap_length() -> float:
	return floor_snap_length

func set_wall_min_slide_angle(value: float) -> void:
	wall_min_slide_angle = value

func get_wall_min_slide_angle() -> float:
	return wall_min_slide_angle

func set_snap_vector(value: Vector2) -> void:
	snap_vector = value

func get_snap_vector() -> Vector2:
	return snap_vector

func set_velocity(value: Vector2) -> void:
	velocity = value

func get_velocity() -> Vector2:
	return velocity

func set_resource_map(value: Resource) -> void:
	resource_map = value

func get_resource_map() -> Resource:
	return resource_map

## Returns class name for reflection.
func get_class() -> String:
	return "EntityBody2D"

## Custom inspector property list (visible in editor).
func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("EntityBody2D")
	properties.add_enum("motion_mode", "Grounded,Floating")

	if is_mode_grounded():
		properties.add_vector2("up_direction")
		properties.add_bool("slide_on_ceiling")
		properties.add_group_prefix("Floor", "floor_")
		properties.add_bool("floor_stop_on_slope")
		properties.add_bool("floor_constant_speed")
		properties.add_bool("floor_block_on_wall")
		properties.add_float_range("floor_max_angle", MIN_ANGLE, MAX_ANGLE)
		properties.add_float_range("floor_snap_length", MIN_SNAP_LENGTH, MAX_SNAP_LENGTH)
	elif is_mode_floating():
		properties.add_float_range("wall_min_slide_angle", MIN_ANGLE, MAX_ANGLE)

	properties.add_category("Resources")
	properties.add_resource("resource_map")
	return properties.get_properties()
