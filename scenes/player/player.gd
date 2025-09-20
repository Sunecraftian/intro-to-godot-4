extends CharacterBody2D

var can_laser : bool = true
var can_grenade : bool = true
var direction : Vector2 = Vector2.ZERO


@export var max_speed := 700
var speed = max_speed

signal laser(pos, direction)
signal grenade(pos, direction)

func _process(_delta: float) -> void:
	
	# input
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	# rotate
	look_at(get_global_mouse_position())

	var player_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_pressed("Primary Action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		can_laser = false
		$GPUParticles2D.emitting = true
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		laser.emit(selected_laser.global_position, player_direction)
		$LaserTimer.start()
		
	if Input.is_action_pressed("Secondary Action") and can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		can_grenade = false
		var pos = $LaserStartPositions.get_children()[0].global_position
		grenade.emit(pos, player_direction)
		$GrenadeTimer.start()
		
func hit():
	Globals.health -= 10	
	
		
		
func _on_laser_timer_timeout() -> void:
	can_laser = true


func _on_grenade_timer_timeout() -> void:
	can_grenade = true
