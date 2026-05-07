extends CharacterBody2D


const SPEED = 325.0
const JUMP_VELOCITY = -650.0

var extra_jumps = 0
var max_extra_jumps = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else: 
		extra_jumps = max_extra_jumps

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif extra_jumps > 0:
			velocity.y = JUMP_VELOCITY
			extra_jumps -= 1

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("shrine"):
		max_extra_jumps = 1
		extra_jumps = 1


func _on_pickup_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("shrine"):
		max_extra_jumps = 1
		extra_jumps = 1
