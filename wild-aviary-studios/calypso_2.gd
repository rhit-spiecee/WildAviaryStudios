extends CharacterBody2D

const SPEED = 350.0
const JUMP_VELOCITY = -650.0

var extra_jumps = 0
var max_extra_jumps = 0

@onready var left_spear: Area2D = $Left_Spear
@onready var right_spear: Area2D = $Right_Spear

@onready var left_spear_collision: CollisionShape2D = $Left_Spear/CollisionShape2D
@onready var right_spear_collision: CollisionShape2D = $Right_Spear/CollisionShape2D

var spear_on_cooldown := false

func _ready() -> void:
	add_to_group("player")
	hide_spears()

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

	if Input.is_action_just_pressed("spear_right"):
		use_spear(right_spear)

	if Input.is_action_just_pressed("spear_left"):
		use_spear(left_spear)

	move_and_slide()

func hide_spears() -> void:
	left_spear.visible = false
	right_spear.visible = false

	left_spear.monitoring = false
	right_spear.monitoring = false

	left_spear_collision.disabled = true
	right_spear_collision.disabled = true

func use_spear(spear: Area2D) -> void:
	if spear_on_cooldown:
		return

	spear_on_cooldown = true

	hide_spears()

	spear.visible = true
	spear.monitoring = true

	if spear == left_spear:
		left_spear_collision.disabled = false
	else:
		right_spear_collision.disabled = false

	await get_tree().create_timer(0.5).timeout

	hide_spears()

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
