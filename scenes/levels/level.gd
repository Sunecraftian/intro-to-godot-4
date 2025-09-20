class_name LevelParent
extends Node2D

var laser_scene : PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene : PackedScene = preload("res://scenes/projectiles/grenade.tscn")
var item_scene : PackedScene = preload("res://scenes/items/item.tscn")


func _ready() -> void:
	for container in get_tree().get_nodes_in_group('Containers'):
		container.connect("open", _on_container_opened)
	for scout in get_tree().get_nodes_in_group('Scouts'):
		scout.connect("laser", _on_scout_laser)
	

func _on_container_opened(pos, direction):
	var item = item_scene.instantiate()
	item.position = pos
	item.direction = direction
	$Items.call_deferred("add_child", item)

func _on_player_laser(pos, direction) -> void:
	create_laser(pos, direction)
	
func _on_scout_laser(pos, dir):
	create_laser(pos, dir)

	
func create_laser(pos, direction):
	var laser = laser_scene.instantiate()
	laser.position = pos
	laser.direction = direction
	laser.rotation = direction.angle()
	$Projectiles.add_child(laser)

func _on_player_grenade(pos, direction) -> void:
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	grenade.linear_velocity = direction * grenade.speed
	$Projectiles.add_child(grenade)

	
