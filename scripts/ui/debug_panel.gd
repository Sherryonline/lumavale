extends PanelContainer


func _ready() -> void:
	visible = OS.is_debug_build()
	if not visible:
		return
	ThemeManager.apply_theme(self)
	for child: Node in $Margin/VBox.get_children():
		if child is Button:
			(child as Button).pressed.connect(_on_button.bind(child.name))


func _on_button(button_name: StringName) -> void:
	match button_name:
		&"Gel":
			GameState.inventory.add_item(load("res://resources/items/slime_gel.tres"), 10)
		&"Potion":
			GameState.inventory.add_item(load("res://resources/items/health_potion.tres"), 1)
		&"Heal":
			if GameState.player != null:
				GameState.player.heal(999)
		&"Damage":
			if GameState.player != null:
				GameState.player.receive_damage({"amount": 10, "hit_direction": Vector2.ZERO})
		&"Save":
			SaveManager.save_game()
		&"Load":
			GameState.apply_save_data(SaveManager.load_game())
		&"Reset":
			SaveManager.delete_save()
		&"Town":
			SceneRouter.change_zone(&"town", &"town_respawn")
	SaveManager.save_game()
