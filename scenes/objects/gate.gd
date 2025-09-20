extends StaticBody2D


signal player_entered_gate


func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("entered")
	player_entered_gate.emit(_body)


func _on_area_2d_body_exited(_body: Node2D) -> void:
	print("exited")
