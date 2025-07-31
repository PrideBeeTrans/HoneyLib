## Base class for UI screens with transition and messaging support.
## Intended to be used with ScreenContainer for modular UI management.
## Provides default implementations and warnings for transition methods.

tool
class_name Screen
extends ComponentControl

## Called when the screen is entering (after being set as active).
## Receives an optional message dictionary from ScreenContainer.
func enter(msg: Dictionary) -> void:
	pass

## Called when the screen is exiting (before being removed).
## Receives an optional message dictionary from ScreenContainer.
func exit(msg: Dictionary) -> void:
	pass

## Plays an animation or effect when the screen appears.
## Override in subclasses. Default logs a warning if not implemented.
func play_in() -> void:
	push_warning("%s: play_in() not implemented." % self)

## Plays an animation or effect when the screen disappears.
## Override in subclasses. Default logs a warning if not implemented.
func play_out() -> void:
	push_warning("%s: play_out() not implemented." % self)
