extends Control
@onready var file_dialog: FileDialog = $"Pick File/FilePath/FileDialog"
@onready var thumbnail_dialog: FileDialog = $"Pick Thumbnail/ThumbnailPath/thumbnailDialog"
@onready var file_path: LineEdit = $"Pick File/FilePath"
@onready var thumbnail_path: LineEdit = $"Pick Thumbnail/ThumbnailPath"
@onready var mainBrain: Control = $".."
@onready var title_name: LineEdit = $TitleName
@onready var author: LineEdit = $Author
@onready var caption_text: LineEdit = $CaptionText
@onready var alt_text: LineEdit = $AltText
@onready var thumb_preview: TextureRect = $"Pick Thumbnail/ThumbPreview"
@onready var comic_preview: TextureRect = $"Pick File/ComicPreview"
@onready var add_comic: Button = $AddComic
@onready var tags: LineEdit = $Tags


#@onready var check_box: CheckBox = $ScrollContainer/VBoxContainer/CheckBox
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var entry_type_label: Label = $EntryTypeLabel
var submittedType;


var currentlySelected;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _load_media_details(index,type,nodeClicked) ->void:
	index=nodeClicked.get_index(true)
	print("getting the ", index, " file of type: ",type)
	var savedData=mainBrain.GetEntry(index,type);
	file_path.text=savedData[0];
	thumbnail_path.text=savedData[1];
	title_name.text=savedData[2];
	author.text=savedData[3];
	caption_text.text=savedData[4];
	alt_text.text=savedData[5]
	tags.text=savedData[7];#it skips one. [6]is the filetype. 
	thumb_preview.texture = null
	currentlySelected=nodeClicked
	add_comic.disabled=true;
	for a in currentlySelected.get_parent().get_children():#get all the siblings
		print(a.text)
		a.modulate=Color(1.0, 1.0, 1.0, 1.0)
	currentlySelected.modulate=Color(0.2, 0.5, 0.295, 1.0)
	var testImage=Image.new(); #everyone can do a load on the thumbnail
	var newImage= testImage.load_from_file(thumbnail_path.text);
	if(thumbnail_path.text.ends_with(".gif")):#it will fail if it is a .gif. use an alt pathway
		print("trying .gif method")
		thumb_preview.texture = GifManager.animated_texture_from_file(thumbnail_path.text)
	else:
		var newTexture=ImageTexture.create_from_image(newImage);
		print("setting thumbnail preview")
		thumb_preview.texture=newTexture
	if(name=="Comics"):#but this is only for comics. hehe reload the images.
		print("loading image from ",file_path.text)
		testImage=Image.new();
		newImage= testImage.load_from_file(file_path.text);
		if(file_path.text.ends_with(".gif")):#it will fail if it is a .gif. use an alt pathway
			print("trying .gif method")
			comic_preview.texture = GifManager.animated_texture_from_file(file_path.text)
		else:
			var newTexture=ImageTexture.create_from_image(newImage);
			print("setting thumbnail preview")
			comic_preview.texture=newTexture

	pass

func _on_cancel_pressed() -> void:
#When cancel is clicked, deselect all. 
	if(currentlySelected!=null):
		for a in currentlySelected.get_parent().get_children():#get all the siblings#
			print(a.text)
			a.modulate=Color(1.0, 1.0, 1.0, 1.0)
		currentlySelected=null
		add_comic.disabled=false;
		#currentlySelected.modulate=Color(0.2, 0.5, 0.295, 1.0)
		alt_text.text=""
		file_path.text="";
		thumbnail_path.text="";
		title_name.text="";
		author.text="";
		caption_text.text="";
		tags.text="";
		thumb_preview.texture = null
		if(name=="Comics"):#only a feature for the comics one. 
			comic_preview.texture = null
		add_comic.disabled=false

func _on_edit_entry_pressed() -> void:
	if(currentlySelected!=null):
		mainBrain.EditEntry(currentlySelected.get_index(true),file_path.text,thumbnail_path.text,title_name.text,author.text,caption_text.text,entry_type_label.text,alt_text.text,tags.text); #send all the data again, but tell it the index that gets the data!
		currentlySelected.text=title_name.text#This is the only part that needs updating. 
		#Now create a new entry in the list. 
		print("Adding the file: ",currentlySelected.text);
			#now that we have added it, clear it out
		alt_text.text=""
		file_path.text="";
		thumbnail_path.text="";
		title_name.text="";
		author.text="";
		caption_text.text="";
		tags.text="";
		thumb_preview.texture = null
		if(name=="Comics"):#only a feature for the comics one. 
			comic_preview.texture = null
			
		currentlySelected.modulate=Color(1.0, 1.0, 1.0, 1.0)#we dont need to select this anymore.
		currentlySelected=null;
		add_comic.disabled=false;
	else:
		print("nothing to edit!")
		
func _on_add_comic_pressed() -> void:
	if(file_path.text==""):
		file_path.modulate=Color(0.631, 0.0, 0.247, 1.0)
	elif(thumbnail_path.text==""):
		thumbnail_path.modulate=Color(0.631, 0.0, 0.247, 1.0)
	elif(title_name.text==""):
		title_name.modulate=Color(0.631, 0.0, 0.247, 1.0)
	elif(author.text==""):
		author.modulate=Color(0.631, 0.0, 0.247, 1.0)
	elif(caption_text.text==""):
		caption_text.modulate=Color(0.631, 0.0, 0.247, 1.0)
	elif(tags.text==""):
		tags.modulate=Color(0.631, 0.0, 0.247, 1.0)
	elif(name=="Comics" and alt_text.text==""):#only check this one on the comics. Its there, but it will ALWAYS be blank in non comics.
			alt_text.modulate=Color(0.631, 0.0, 0.247, 1.0)
	else:
		mainBrain.AddEntry(file_path.text,thumbnail_path.text,title_name.text,author.text,caption_text.text,entry_type_label.text,alt_text.text,tags.text);
		#Now create a new entry in the list. 
		var newEntry=Button.new();#create a new checkbox object
		v_box_container.add_child(newEntry)#attach the newly created node
		newEntry.text=title_name.text;#set its display as the name of the title.
		newEntry.alignment=HORIZONTAL_ALIGNMENT_LEFT;
		newEntry.connect("pressed",_load_media_details.bind(9,name,newEntry.get_node(".")))
		print("Adding the file: ",newEntry.text);
			#now that we have added it, clear it out
		alt_text.text=""
		
		file_path.text="";
		file_path.modulate=Color(1.0, 1.0, 1.0, 1.0)
		thumbnail_path.text="";
		thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0)
		title_name.text="";
		title_name.modulate=Color(1.0, 1.0, 1.0, 1.0)
		author.text="";
		author.modulate=Color(1.0, 1.0, 1.0, 1.0)
		caption_text.text="";
		caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0)
		tags.text="";
		tags.modulate=Color(1.0, 1.0, 1.0, 1.0)
		thumb_preview.texture = null
		if(name=="Comics"):#only a feature for the comics one. 
			comic_preview.texture = null
		
func _on_subtract_comic_pressed() -> void:
	if(currentlySelected!=null):
		mainBrain.RemoveEntry(currentlySelected.get_index(true),entry_type_label.text);#first tell the database to clear it
		currentlySelected.queue_free();#eliminate the button.
		currentlySelected=null;
		add_comic.disabled=false;
		#clear out the written data
		alt_text.text=""
		file_path.text="";
		thumbnail_path.text="";
		title_name.text="";
		author.text="";
		caption_text.text="";
		tags.text="";
		thumb_preview.texture = null
		if(name=="Comics"):#only a feature for the comics one. 
			comic_preview.texture = null

	
func _on_pick_file_pressed() -> void:#pressed when we want to load the file. make the dialog appear
	file_dialog.visible=true;
	pass # Replace with function body.


func _on_file_dialog_file_selected(selectedPath: String) -> void:# we have selected a file. Fill in the data, and vainsh the dialog
	file_dialog.visible=false;
	file_path.text=selectedPath;
	print("trying to file on node:",name)
	if(name=="Comics"):#this is only for comics. hehe
		print("loading image from ",selectedPath)
		var testImage=Image.new();
		var newImage= testImage.load_from_file(selectedPath);
		if(selectedPath.ends_with(".gif")):#it will fail if it is a .gif. use an alt pathway
			print("trying .gif method")
			comic_preview.texture = GifManager.animated_texture_from_file(selectedPath)
		else:
			var newTexture=ImageTexture.create_from_image(newImage);
			print("setting thumbnail preview")
			comic_preview.texture=newTexture
	pass # Replace with function body.


func _on_pick_thumbnail_pressed() -> void:#pressed when we want to load the THUMBNAIL file. make the dialog appear
	thumbnail_dialog.visible=true;
	
	pass # Replace with function body.


func _on_thumbnail_dialog_file_selected(selectedPath: String) -> void:
	thumbnail_dialog.visible=false;
	thumbnail_path.text=selectedPath;
	print("loading image from ",selectedPath)
	var testImage=Image.new();
	var newImage= testImage.load_from_file(selectedPath);
	if(selectedPath.ends_with(".gif")):#it will fail if it is a .gif. use an alt pathway
		print("trying .gif method")
		thumb_preview.texture = GifManager.animated_texture_from_file(selectedPath)
	else:
		var newTexture=ImageTexture.create_from_image(newImage);
		print("setting thumbnail preview")
		thumb_preview.texture=newTexture
	
	pass # Replace with function body.


func _on_title_name_text_changed(new_text: String) -> void: #this is to prevent breaking the html links
	if(new_text.substr(len(new_text)-1,1) in "'?\"&%@$"):
		print("Illegal Character!");
		title_name.text=title_name.text.substr(0,len(new_text)-1)#erase the last text
		title_name.caret_column=len(title_name.text)#return the cursor back to the end
	
	pass # Replace with function body.
