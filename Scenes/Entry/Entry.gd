extends MarginContainer

var font_size = 32

#func _draw() -> void:
#	font_size = clamp($Body.rect_size.y , 5 , 54 )
#
#	$Body/No.get("custom_fonts/font").size  = font_size # Set Font
#	$Body/No.get("custom_fonts/font").size # Get Font

func set_data(pos,name,points):
	$Body/No.text = str(pos)
	$Body/Name.text = str(name)
	$Body/Pontos.text = str(points)

func update_font(s):
	$Body/No.get("custom_fonts/font").size = s

func set_color(color : Color):
	$Body/No.modulate = color
	$Body/Name.modulate = color
	$Body/Pontos.modulate = color
