class_name Utils

static func print_float_clean(value: float) -> String:
	if value == int(value):
		return str(int(value))
	else:
		return str(value)
