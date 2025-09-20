extends RigidBody2D

var exploding := false
var explosion_radius := 300

@export var speed : int = 750

func explode():
	$AnimationPlayer.play("Explosion")
	exploding = true
	
func _process(_delta: float) -> void:
	if exploding:
		var targets = get_tree().get_nodes_in_group("Containers") + get_tree().get_nodes_in_group("Entities")
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < explosion_radius
			if "hit" in target and in_range:
				target.hit()
		
