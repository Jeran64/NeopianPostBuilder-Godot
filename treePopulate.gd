extends Tree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tree = Tree.new()
	var root = tree.create_item()
	tree.hide_root = false
	root.set_text(0,"Issue :");
	
	#generate the tree main folders.
	var Articles = tree.create_item(root)
	Articles.set_text(0, "Articles")
	var Comics = tree.create_item(root)
	Comics.set_text(0, "Comics")
	var ContinuedSeries = tree.create_item(root)
	ContinuedSeries.set_text(0, "ContinuedSeries")
	var NewSeries = tree.create_item(root)
	NewSeries.set_text(0, "NewSeries")
	var Poetry = tree.create_item(root)
	Poetry.set_text(0, "Poetry")
	var ShortStories = tree.create_item(root)
	ShortStories.set_text(0, "ShortStories")
