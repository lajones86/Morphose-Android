class_name OverworldInputHandler
extends Node

var UI: OverworldUI
var party_token: PartyToken

var player_controls_locked: bool = false

signal request_open_char_builder


func _process(delta):
	processInput()


func processInput() -> void:
	if UI.inDialog():
		if Input.is_action_just_pressed("overworld_interact"):
			UI.closeDialog()
	elif not player_controls_locked:
		if Input.is_action_just_pressed("pause"):
			emit_signal("request_open_char_builder")
		elif Input.is_action_just_pressed("up"):
			party_token.attemptMoveUp()
		elif Input.is_action_just_pressed("down"):
			party_token.attemptMoveDown()
		elif Input.is_action_just_pressed("left"):
			party_token.attemptMoveLeft()
		elif Input.is_action_just_pressed("right"):
			party_token.attemptMoveRight()
		elif Input.is_action_just_pressed("overworld_interact"):
			party_token.attemptInteract()


func lockPlayerControls() -> void:
	player_controls_locked = true


func unlockPlayerControls() -> void:
	player_controls_locked = false
	
	# ===============================================================
# ⏱️ PHASE 1: NODE REFERENCE & SETUP (The Waiter)
# ===============================================================

const GLOBAL_BUTTON_PATH = "/root/Root/Controls_Overlay/ActionContainer0/Action0" 


func _enter_tree():
	print("Attempting to locate the control button...")
	
	# Use 'await' to pause execution until this specific node path is available.
	var target_button = await get_node(GLOBAL_BUTTON_PATH)

	if target_button != null:
		# If we reach here, the node exists! We can safely connect the signal now.
		print("✅ Node found! Connecting button signal...")
		target_button.connect("pressed", Callable(self, "_on_action_button_pressed"))
	else:
		# This means that even waiting did not help. The path is STILL wrong.
		print("!!! CRITICAL FAILURE: Failed to find node even after waiting for it.")


# ===============================================================
# 🎮 PHASE 2: THE ACTION HANDLER (The Execution)
# ===============================================================

func _on_action_button_pressed():
	print("✅ SUCCESS! Action Button was pressed. Executing core game logic.")
	
	# -------------------------------------------------------
	# >>> PASTE ALL CORE GAME LOGIC HERE <<<
	# -------------------------------------------------------
