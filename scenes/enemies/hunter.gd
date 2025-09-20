extends CharacterBody2D

var active := false
var player_nearby := false
var vulnerable := true
var health := 100
var speed := 200

func _ready() -> void:
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos
	

	
func _physics_process(_delta: float) -> void:
	if active:
		var next_path_pos : Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction := (next_path_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		var look_angle = direction.angle()
		rotation = look_angle + PI / 2
		
		
func attack():
	if player_nearby:
		Globals.health -= 20

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$Timers/IFrames.start()		
		$Hunter.material.set_shader_parameter("progress", 1)
	if health <= 0:
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _on_notice_area_body_entered(_body: Node2D) -> void:
	active = true
	$AnimationPlayer.play("walk")

func _on_notice_area_body_exited(_body: Node2D) -> void:
	active = false


func _on_navigation_timer_timeout() -> void:
	if active:
		$NavigationAgent2D.target_position = Globals.player_pos


func _on_attack_area_body_entered(_body: Node2D) -> void:
	player_nearby = true
	$AnimationPlayer.play("attack")


func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_nearby = false
	$AnimationPlayer.play("walk")
	
func _on_i_frames_timeout() -> void:
	vulnerable = true
	$Hunter.material.set_shader_parameter("progress", 0)
