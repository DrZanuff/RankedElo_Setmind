extends Node

var link = "https://script.google.com/macros/s/AKfycbxzZmE--TzcbE6VnHaFGjbjwwXXeVQ6U4jiSbNcDIZGq83NBSUN/exec"
var rank

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	printt(result , response_code )
	var json = body.get_string_from_utf8()
	rank = JSON.parse(json).result
	print(rank.Wolf)


func _on_Button_pressed() -> void:
	$HTTPRequest.request(link)
	pass # Replace with function body.
