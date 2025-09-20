extends CharacterBody2D

var player_nearby := false
var can_laser := true
var right_gun_use := true

var heatlh := 30
var vulnerable := true

signal laser(pos, dir)

func hit():
	if vulnerable:
		heatlh -= 10
		vulnerable = false
		$Timers/IFrames.start()		
		$Scout.material.set_shader_parameter("progress", 1)
		$HitSound.play()
	if heatlh <= 0:
		hide()
		$DeathSound.play()
		await $DeathSound.finished
		queue_free()


func _process(_delta: float) -> void:
	if player_nearby:
		look_at(Globals.player_pos)
		if can_laser:
			var marker := $LaserSpawnPositions.get_child(right_gun_use)
			right_gun_use = not right_gun_use
			var pos : Vector2 = marker.global_position
			var dir : Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, dir)
			can_laser = false
			$Timers/LaserTimer.start()


func _on_attack_area_body_entered(_body: Node2D) -> void:
	player_nearby = true


func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_nearby = false


func _on_laser_timer_timeout() -> void:
	can_laser = true


func _on_i_frames_timeout() -> void:
	vulnerable = true
	$Scout.material.set_shader_parameter("progress", 0)
	
