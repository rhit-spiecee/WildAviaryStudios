extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -650.0

@onready var left_spear = $Left_Spear
@onready var right_spear = $Right_Spear

var extra_jumps = 0
var max_extra_jumps = 0

var spear_on_cooldown := false

func _ready() -> void:
	left_spear.visible = false
	right_spear.visible = false

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
			extra_jumps -= 2

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("spear_right"):
		use_spear(left_spear)

	if Input.is_action_just_pressed("spear_left"):
		use_spear(right_spear)

	move_and_slide()

func use_spear(spear: Node2D) -> void:
	if spear_on_cooldown:
		return

	spear_on_cooldown = true

	left_spear.visible = false
	right_spear.visible = false

	spear.visible = true

	await get_tree().create_timer(0.5).timeout
	spear.visible = false

	await get_tree().create_timer(1.0).timeout
	spear_on_cooldown = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("shrine"):
		max_extra_jumps = 1
		extra_jumps = 1

func _on_pickup_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("shrine"):
		max_extra_jumps = 1
		extra_jumps = 1
