extends Area2D

@export var health := 3
@export var arrow_scene: PackedScene = preload("res://Arrow.tscn")
@export var detection_range := 400.0
@export var shoot_cooldown := 1.5
var player_position_offset := Vector2(1510.5, 65.0)

var can_take_damage := true
var can_shoot := true
var player: Node2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

	player = get_tree().get_first_node_in_group("player")

	if player == null:
		print("NO PLAYER FOUND")
	else:
		print("PLAYER FOUND: ", player.name)

	if arrow_scene == null:
		print("NO ARROW SCENE")
	else:
		print("ARROW SCENE READY")

func _process(delta: float) -> void:
	if player == null:
		return

	var fixed_player_position = player.global_position + player_position_offset
	var distance_to_player = global_position.distance_to(fixed_player_position)

	if distance_to_player <= detection_range and can_shoot:
		shoot_arrow(fixed_player_position)

func shoot_arrow(target_position: Vector2) -> void:
	can_shoot = false

	var arrow = arrow_scene.instantiate()
	get_tree().current_scene.add_child(arrow)

	arrow.global_position = global_position
	arrow.direction = global_position.direction_to(target_position).normalized()

	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func _on_area_entered(area: Area2D) -> void:
	if not can_take_damage:
		return

	if area.name == "Left_Spear" or area.name == "Right_Spear":
		can_take_damage = false
		health -= 1

		if health <= 0:
			queue_free()
			return

		await get_tree().create_timer(0.5).timeout
		can_take_damage = true
