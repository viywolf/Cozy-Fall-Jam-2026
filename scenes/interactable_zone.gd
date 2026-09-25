extends Node2D

signal interactable_zone_entered
signal treasure_gained
signal junk_gained

@export_enum("Treasure", "Junk") var treasure_type

var is_in_area: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Area2D:
			child.body_entered.connect(on_interactable_area_entered)

func _process(delta: float) -> void:
	if is_in_area:
		# TODO temp input key
		if Input.is_action_just_pressed("ui_accept"):
			interacted_with_area()

func on_interactable_area_entered(body: Node2D):
	if body.name == "Player":
		interactable_zone_entered.emit()
		is_in_area = true
		print("a")
	else:
		print("e5")

func interacted_with_area():
	if treasure_type == "Treasure":
		treasure_gained.emit()
	elif treasure_type == "Junk":
		junk_gained.emit()
