class_name Teleport extends Area2D

@export var shouldExam: bool = false;

@export var teleportFrom: String;
@export var teleportTo: String;
@export var teleportName: String;

@onready var player = get_parent().get_node("Player");
@onready var task = get_parent().get_node("UI/TaskContainer");


func _on_body_entered(body):
	if (not body is Player):
		return;
	print("Player on area");
	print("area should exam - %s" % shouldExam)
	if body.teleportInitiate.get_connections().size() > 0:
		print("something is connected")
		var connections: Array = body.teleportInitiate.get_connections();
		for i in connections.size():
			print("last teleport entry disconnected");
			body.teleportInitiate.disconnect(connections[i]["callable"]);
	if (body.teleportInitiate.is_connected(teleport)):
		print("teleport disconnected");
		body.teleportInitiate.disconnect(teleport);
	print("teleport connected");
	body.teleportInitiate.connect(teleport);
	body.set_meta("collidesWith", self)

func _on_body_exited(body):
	
	if (body is Player && 
		body.has_meta("collidesWith") && 
		body.get_meta("collidesWith") == self):
		print("Player exited area");
		if (body.teleportInitiate.is_connected(teleport)):
			print("teleport disconnected");
			body.teleportInitiate.disconnect(teleport);
		body.set_meta("collidesWith", null)

func teleport(interactedItem: Teleport):
	print("teleport initiated")
	if shouldExam:
		if not task.checkSuccessful.is_connected(_teleport):
			task.checkSuccessful.connect(_teleport.bind(interactedItem))
		task.startExam();
	else:
		_teleport(interactedItem);
	

func _teleport(interactedItem: Teleport):
	if (task.checkSuccessful.is_connected(_teleport)): 
		task.checkSuccessful.disconnect(_teleport);
	#var currentLevel: Map = get_viewport().get_node(interactedItem.teleportFrom)
	if interactedItem.teleportTo != "": 
		#var level: Map = get_viewport().get_node(interactedItem.teleportTo)
		#level.toggleLevel();
		#currentLevel.toggleLevel(); 
		GlobalSettings.save.player.lastMapPositions[teleportFrom] = player.position;
		GlobalSettings.save.player.previousMap = teleportFrom;
		get_tree().change_scene_to_file("res://Scenes/Levels/%s.tscn" % interactedItem.teleportTo);
	


	
