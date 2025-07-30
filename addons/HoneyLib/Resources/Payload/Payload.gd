tool
class_name Payload
extends Resource

signal will_execute(source, target)
signal did_execute(source, target, result)


func execute(source, target) -> bool:
	emit_signal("will_execute", source, target)
	
	var result := _execute(source, target)
	
	if _is_valid_result(result):
		emit_signal("did_execute", source, target)
		return result
	
	return false


func _execute(source, target) -> bool:
	push_error("Method _execute() not implement in base class")
	return false


func _is_valid_result(result) -> bool:
	return result != null and result != false
