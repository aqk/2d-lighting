extends Node

signal game_started

var server_port = 25555
export var ip_address = '10.0.0.8'
export var player_name = ""

var peer := NetworkedMultiplayerENet.new()
var player_info = {}
#var network_type = preload("res://core/networking/NetworkType.tscn")
var is_server = false
var connection_count = 0
var upnp

#   -------------  RPCS

remote func register_player(player_intro) -> void:
	var player_id = get_tree().get_rpc_sender_id()
	if player_id != player_intro["player_id"]:
		print_debug("Protocol Error: player %s sent INTRO id %s", player_id, player_intro["player_id"])
	player_info[player_id] = player_intro

remote func client_start_game() -> void:
	if get_tree().get_rpc_sender_id() != 1:
		return
	start_game()
	$"../../game/".connect("mouse_pos", self, "_client_mouse_pos")
	
remote func set_ball_state(velocity, position):
	$"../../game/ball".set_ball_state(velocity, position)

remote func set_client_paddle(y):
	$"../../game".set_client_mouse_pos(y)

remote func set_server_paddle(y):
	$"../../game".set_server_mouse_pos(y)
	
#    -------------  LOCAL CODE
# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_signals()
	
func _connect_signals():
	var signal_map = [
		"network_peer_connected",
		"network_peer_disconnected",
		"connected_to_server",
		"connection_failed",
		"server_disconnected"
	]
	for signal_name in signal_map:
		get_tree().connect(signal_name, self, "_on_" + signal_name)
		
func server_start_game() -> void:
	for client in player_info:
		rpc_id(client, "client_start_game")
	var game_scene = start_game()
	assert(get_tree().get_network_unique_id() == 1)
	for ch in game_scene.get_children():
		if ch.name == "ball":
			ch.connect("ball_state", self, "_send_ball_state")
		game_scene.connect("mouse_pos", self, "_send_server_mouse_pos")			

func _send_server_mouse_pos(y):
	for user in player_info:
		rpc_id(user, "set_server_paddle", y)
	$"../../game".set_server_mouse_pos(y)

func _client_mouse_pos(y):
	for user in player_info:
		rpc_id(user, "set_client_paddle", y)
	$"../../game".set_client_mouse_pos(y)

func _send_ball_state(velocity, position):
	for user in player_info:
		rpc_id(user, "set_ball_state", velocity, position)

func start_game() -> Node:
	emit_signal("game_started")
	$"../../Menu".visible = false
	var game_scene = load("res://game.tscn").instance()
	$"../../".add_child(game_scene)
	game_scene.name = "game"
	return game_scene

func join_game() -> void:
	print_debug("Joining game with %s:%s" % [ip_address, server_port])
	peer.create_client(ip_address, server_port)
	get_tree().network_peer = peer
	is_server = false

func set_up_upnp() -> void:
	pass

func host_game(host_online = true) -> void:
	print_debug("Ran host game")
	if host_online:
		set_up_upnp()
		var err = upnp.add_port_mapping(server_port)
		if err != upnp.UPNP_RESULT_SUCCESS:
			push_error("Could not port forward: Error code: %s" % server_port)
	peer.set_bind_ip("0.0.0.0")
	var error = peer.create_server(server_port)
	get_tree().network_peer = peer
	if error == ERR_ALREADY_IN_USE:
		print_debug("Port %s occupied. Server already exists?" % server_port)
	connection_count += 1


#   -------------  CALLBACKS

func _on_network_peer_connected(player_id) -> void:
	print_debug("Player Connected: %s" % player_id)
	var my_player_info = {
		"player_id": get_tree().get_network_unique_id(),
		"player_name": player_name
	}
	
	if get_tree().get_network_unique_id() == 1:
		$"../VBoxContainer/Start".disabled = false
	
	# Send OUR player_info TO the new player, player_id
	rpc_id(player_id, "register_player", my_player_info)
	if is_server:
		connection_count += 1

func _on_network_peer_disconnected(player_id):
	player_info.erase(player_id)

func _on_connected_to_server():
	pass

func _on_connection_failed():
	pass

func _on_server_disconnected():
	get_tree().network_peer = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
