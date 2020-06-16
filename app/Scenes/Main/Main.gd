extends Node

var link = "https://script.google.com/macros/s/AKfycbxzZmE--TzcbE6VnHaFGjbjwwXXeVQ6U4jiSbNcDIZGq83NBSUN/exec"
var path = "res://"
var rank = []
var current_rank = "Wolf"
onready var name_list = $Control/Viewport/BaseScene/Structure/Data/Body/Names
var entry = load("res://Scenes/Entry/Entry.tscn")
export (Array,Color) var colors = [Color() , Color()]

var board_heigth = 1000


var elo_ranks = [
				"res://Ranks/Elos/Wolf.tres",
				"res://Ranks/Elos/Eagle.tres",
				"res://Ranks/Elos/Bear.tres",
				"res://Ranks/Elos/Lion.tres",
				"res://Ranks/Elos/Dragon.tres"
				]

func _ready() -> void:
	board_heigth = $Control/Viewport/BaseScene/Structure/Data/Body/Names.rect_size.y
	$Curtain.show()
	
	var index = 0
	for b in $Options/Body/Elos.get_children():
		b.set_meta( "rank" , elo_ranks[index] )
		b.connect("pressed",self,"elo_change", [ b.get_meta("rank"),b.text ] )
		index += 1

func elo_change(e,text):
	if rank.empty():
		$AnimationPlayer.play("swap")
		disable_buttons(true)
		$Control/Viewport/BaseScene.set_rank_images( load(e) )
		current_rank = text
	else:
		disable_buttons(true)
		$Control/Viewport/BaseScene.set_rank_images( load(e) )
		current_rank = text
		update_rank()
	

func _on_FileDialog_confirmed() -> void:
	path = $FileDialog.current_path
	var img = $Control/Viewport.get_texture().get_data()
	img.flip_y()
	img.save_png( str( path + ".png" )  )


func _on_FileDialogMult_confirmed() -> void:
	var temp_rank = elo_ranks
#	temp_rank.pop_front()
	
	$AnimationPlayer.play("BlackOut")
	
	yield(get_tree().create_timer(0.3),"timeout")
#	$Control/Viewport/BaseScene.set_rank_images(load(elo_ranks[0]))
#	yield(get_tree() , "idle_frame" )
#	var img_temp = $Control/Viewport.get_texture().get_data()
#	img_temp.flip_y()
#	img_temp.save_png( str( $FileDialogMult.current_dir + "/" + "Wolf" + ".png" )  )
#	yield(get_tree().create_timer(0.5),"timeout")
	
	for e in temp_rank:
		path = $FileDialogMult.current_dir
		
		$Control/Viewport/BaseScene.set_rank_images( load(e) )
		yield(get_tree() , "idle_frame" )
		var img = $Control/Viewport.get_texture().get_data()
		img.flip_y()
		
		name = str(e).replace("res://Ranks/Elos/","")
		name = name.replace("tres","")
		
		printt( e , name )
		
		img.save_png( str( path + "/" + name + ".png" )  )
		
	$AnimationPlayer.play("FadeOut")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "swap":
		disable_buttons(false)

func disable_buttons(status):
	for b in $Options/Body/Elos.get_children():
		if b is Button:
			b.disabled = status
	
	for b in $Options/Body/Save.get_children():
		if b is Button:
			b.disabled = status
	
func _on_ButtonSave_pressed() -> void:
	$FileDialog.show()
	$FileDialogMult.hide()
	$Control/Viewport/BaseScene.position.y = 0
	

func _on_ButtonSaveAll_pressed() -> void:
	$FileDialog.hide()
	$FileDialogMult.show()
	$Control/Viewport/BaseScene.position.y = 0


func _on_ButtonUpdate_pressed() -> void:
	$HTTPRequest.request(link)
	disable_buttons(true)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json = body.get_string_from_utf8()
	rank = JSON.parse(json).result
	update_rank()
	disable_buttons(false)
	
func update_rank():
	$AnimationPlayer.play("BlackOut")
	yield(delete_all(),"completed")
	var index = 1
	if not rank.empty():
		for e in range(rank[current_rank].size() ):
			index += 1
			var new_entry = entry.instance()
			name_list.add_child(new_entry)
			
			new_entry.set_data(
				e+1 , 
				rank[current_rank][e][0] , 
				rank[current_rank][e][1] 
				)
			
			#Set Color
			new_entry.set_color( colors[ ceil(index%2) ] ) 
		
		var font_size = (board_heigth / rank[current_rank].size() ) - 3.9
		font_size = clamp( font_size , 5 , 54 )
		
		name_list.get_child(0).update_font(font_size)
	
	$AnimationPlayer.play("FadeOut")
	disable_buttons(false)

func delete_all():
	yield(get_tree(), "idle_frame")
	for e in name_list.get_children():
		e.queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		var new_entry = entry.instance()
		name_list.add_child(new_entry)
		
	var cam = $Control/Viewport/BaseScene
	if not Engine.editor_hint:
		if event is InputEventMouse:
			if event.is_pressed():
				if event.button_index == BUTTON_WHEEL_UP:
					cam.position.y = clamp(cam.position.y - 50 , 0 , 1280 )
					
				if event.button_index == BUTTON_WHEEL_DOWN:
					cam.position.y = clamp(cam.position.y + 50 , 0 , 1280 )
