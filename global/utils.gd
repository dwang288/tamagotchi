class_name Utils

static func print_float_clean(value: float) -> String:
	if value == int(value):
		return str(int(value))
	else:
		return str(value)

static func replace_keywords(text: String) -> String:
	for keyword in IconBbcodeDict.mapping.keys():
		var texture = IconBbcodeDict.mapping[keyword]
		text = text.replace("<<" + keyword + ">>", "[img]" + texture.resource_path + "[/img]")
	return text
