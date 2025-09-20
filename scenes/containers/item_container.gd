class_name ItemContainer
extends StaticBody2D

signal open(pos, dir)

@onready var current_direction := Vector2.DOWN.rotated(rotation)
var opened := false
