extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateList(inventory):
	clear();
	for item in inventory:
		add_item(item.getName(), item.getTexture())
