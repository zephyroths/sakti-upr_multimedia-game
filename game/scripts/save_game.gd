extends Node

const SaveGame = preload("res://system/save/save_file.gd")

# var SAVE_DIR: String = "res://save"

# On Windows 'user://' is the %APPDATA% Folder
# On Linux 'user://' is the $HOME/.local/share

var SAVE_DIR: String = "user://save"
var SAVE_NAME_TEMPLATE: String = "save_%03d.tres"

func save(id: int):
	var save_game: = SaveGame.new()
	for node in get_tree().get_nodes_in_group("save"):
		node.save(save_game)
		
	var directory: Directory = Directory.new()
	if not directory.dir_exists(SAVE_DIR):
		directory.make_dir_recursive(SAVE_DIR)
	
	var save_path = SAVE_DIR.plus_file(SAVE_NAME_TEMPLATE % id)
	var error: int = ResourceSaver.save(save_path, save_game)
	if error != OK:
		print("Ada masalah membuat save di %s ke %s" % [id, save_path])

func load(id: int):
	var save_file_path: String = SAVE_DIR.plus_file(SAVE_NAME_TEMPLATE % id)
	var file: File = File.new()
	if not file.file_exists(save_file_path):
		print("File Save %s tidak ditemukan" % save_file_path)
		return
	
	var save_game: Resource = load(save_file_path)
	get_node("/root/player").load(save_game)
