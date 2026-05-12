extends Area2D

@export var health := 3
var can_take_damage := true

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	print("Touched by: ", area.name)

	if not can_take_damage:
		return

	if area.name == "Left_Spear" or area.name == "Right_Spear":
		can_take_damage = false
		health -= 1

		print(name, " health: ", health)

		if health <= 0:
			queue_free()
			return

		await get_tree().create_timer(0.5).timeout
		can_take_damage = true
