extends CharacterBody2D

var active := false
var vulnerable := true
var health := 50 
var speed := 0
var max_speed := 800

var explosion_active := false

func  _ready() -> void:
	$Explosion.hide()
	$Drone.show()

func _process(delta: float) -> void:
	if active:
		look_at(Globals.player_pos)
		var direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			$AnimationPlayer.play("Explosion")
			explosion_active = true
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Containers") + get_tree().get_nodes_in_group("Entities")
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < 400
			if "hit" in target and in_range:
				target.hit()		
	
func hit():
	if vulnerable:
		health-= 10
		vulnerable = false
		$Timers/HitTimer.start()
		$Drone.material.set_shader_parameter("progress", 1)
	if health <= 0:
		$AnimationPlayer.play("Explosion")
		explosion_active = true


func _on_notice_area_body_entered(_body: Node2D) -> void:
	active = true
	var tween = create_tween()
	tween.tween_property(self, "speed", max_speed, 2)


func _on_hit_timer_timeout() -> void:
	vulnerable = true
	$Drone.material.set_shader_parameter("progress", 0)
