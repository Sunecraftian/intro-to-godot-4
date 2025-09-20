extends CanvasLayer

func _ready() -> void:
	$ColorRect.modulate = Color(0.0, 0.0, 0.0, 0.0)

func change_scene(target) -> void:
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	if target is PackedScene: get_tree().change_scene_to_packed(target)
	if target is String: get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("fade_to_black")
