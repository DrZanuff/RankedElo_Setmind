tool
extends Camera2D

#Windows Height 720

export (Resource) var elo setget set_rank


func set_rank(e):
	if Engine.editor_hint:
		elo = e
		var badge = $Structure/VBoxContainer/Logo/VBoxContainer/MarginContainer/Badge
		var title = $Structure/VBoxContainer/Logo/VBoxContainer/Title
		var bg = $Structure/BG
		badge.texture = e.badge
		title.texture = e.title
		bg.texture = e.bg


func set_rank_images(e):
	if not Engine.editor_hint:
		var badge = $Structure/VBoxContainer/Logo/VBoxContainer/MarginContainer/Badge
		var title = $Structure/VBoxContainer/Logo/VBoxContainer/Title
		var bg = $Structure/BG
		badge.texture = e.badge
		title.texture = e.title
		bg.texture = e.bg


	
