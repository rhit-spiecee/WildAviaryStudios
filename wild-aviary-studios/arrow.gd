extends Area2D

var speed := 500.0
var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Calypso2":
		get_tree().paused = true
