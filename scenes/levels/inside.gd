extends LevelParent

var outside_level_scene : PackedScene = preload("res://scenes/levels/outside.tscn")

func _on_exit_to_outside_body_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.5)
	#get_tree().change_scene_to_file("res://scenes/levels/outside.tscn")
	#get_tree().call_deferred("change_scene_to_packed", outside_level_scene)
	TransitionLayer.change_scene(outside_level_scene)
