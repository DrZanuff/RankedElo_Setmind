extends Node

var path = "res://"

func _ready() -> void:
	$FileDialog.show()
	

func _on_FileDialog_confirmed() -> void:
	path = $FileDialog.current_path
	var img = $Control/Viewport.get_texture().get_data()
	img.flip_y()
	img.save_png( str( path + ".png" )  )
