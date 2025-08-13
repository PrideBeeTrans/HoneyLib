tool
class_name ColorPalette
extends Resource

var colors := {}


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("ColorPalette")
	properties.add_dictionary("colors")
	return properties.get_properties()
