extends CharacterBody2D

var player_nearby := false
var target : Node2D
var is_attacking := false

var direction : Vector2 = Vector2.ZERO
var speed := 300

var health := 20
var vulnerable := true

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$Timers/IFrames.start()		
		$Bug.material.set_shader_parameter("progress", 1)
		$Particles/HitParticles.emitting = true
		$HitSound.play()

	if health <= 0:
		hide()
		$DeathSound.play()
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
func _ready() -> void:
	$Bug.animation = "walk"

func _process(_delta: float) -> void:
	if player_nearby:
		$Bug.play()
		look_at(Globals.player_pos)
		direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed
		if is_attacking and $Bug.animation_looped:
			if "hit" in target:  	# body.has_method("hit"):
				target.hit()
		else:
			move_and_slide() 
	else:
		$Bug.stop()
		


func _on_notice_area_body_entered(_body: Node2D) -> void:
	player_nearby = true

func _on_notice_area_body_exited(_body: Node2D) -> void:
	player_nearby = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	is_attacking = true
	$Bug.animation = "attack"	
	target = body
	
func _on_attack_area_body_exited(_body: Node2D) -> void:
	is_attacking = false
	$Bug.animation = "walk"

func _on_i_frames_timeout() -> void:
	vulnerable = true
	$Bug.material.set_shader_parameter("progress", 0)
