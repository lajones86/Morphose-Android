class_name ControllerOverworld
extends Controller

const MAP_DIRECTORY = "res://Scenes/Overworld/Maps/"

var current_map: OverworldMap

# Called to let a script paused (for warp or combat encounter) know that it can now resume execution
signal execute_script
signal on_map_load


func _ready() -> void:
	$OverworldInputHandler.UI = $OverworldUI


func getCurrentMap() -> OverworldMap:
	return current_map


func openCharBuilderOutsideModStation() -> void:
	switchToCharBuildController(false)


func assignOverworldMapAndPartyLocation(map_name: String, party_grid_position: Vector2, party_direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN):
	if current_map != null:
		current_map.call_deferred("queue_free")
	current_map = load(MAP_DIRECTORY + map_name + ".tscn").instantiate()
	initializeCurrentMap(map_name, party_grid_position)
	$OverworldUI.move_to_front()
	$OverworldInputHandler.party_token = current_map.getPartyToken()


func initializeCurrentMap(map_name: String, party_grid_position: Vector2) -> void:
	add_child(current_map)
	$EncounterHandler.assignMap(current_map)
	current_map.request_script_execution.connect(executeMapScript)
	current_map.on_map_load.connect(onMapLoad)
	current_map.initialize(map_name, party_grid_position)


func loadSavedPartyLocation() -> void:
	assignOverworldMapAndPartyLocation(ActiveSaveData.party.getCurrentMap(), ActiveSaveData.party.getCurrentGridPosition())


func warpPartyTo(destination: OverworldPosition) -> void:
	assignOverworldMapAndPartyLocation(destination.map_name, destination.grid_position)


func blueprintCollected(blueprint) -> void:
	$OverworldUI.displayBlueprintCollectedDialog(blueprint)


func inputHandler() -> OverworldInputHandler:
	return $OverworldInputHandler


func overworldUI() -> OverworldUI:
	return $OverworldUI


func executeMapScript(script: MapScript) -> void:
	emit_signal("execute_script", script)


func onMapLoad(on_load_script: MapScript) -> void:
	call_deferred("emit_signal", "on_map_load", on_load_script)
	

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
