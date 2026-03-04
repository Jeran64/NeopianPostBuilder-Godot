extends Control
@onready var title_name: LineEdit = $TitleName
@onready var author: LineEdit = $Author
@onready var tags: TextEdit = $Tags
@onready var pick_file: Button = $"Pick File"
@onready var comic_preview: TextureRect = $"Pick File/ComicPreview"
@onready var file_path: LineEdit = $"Pick File/FilePath"
@onready var file_dialog: FileDialog = $"Pick File/FilePath/FileDialog"
@onready var pick_thumbnail: Button = $"Pick Thumbnail"
@onready var thumb_preview: TextureRect = $"Pick Thumbnail/ThumbPreview"
@onready var thumbnail_path: LineEdit = $"Pick Thumbnail/ThumbnailPath"
@onready var thumbnail_dialog: FileDialog = $"Pick Thumbnail/ThumbnailPath/thumbnailDialog"
@onready var caption_text: TextEdit = $CaptionText
@onready var alt_text: TextEdit = $AltText
@onready var submission_text: TextEdit = $"Submission Text"
@onready var add_entry: Button = $AddEntry
@onready var comiccontainer: VBoxContainer = $Comics/ScrollContainer/VBoxContainer
@onready var articlecontainer: VBoxContainer = $Articles/ScrollContainer/VBoxContainer
@onready var contSeriescontainer: VBoxContainer = $ContinuedSeries/ScrollContainer/VBoxContainer
@onready var newSeriescontainer: VBoxContainer = $NewSeries/ScrollContainer/VBoxContainer
@onready var shortStoriescontainer: VBoxContainer = $ShortStories/ScrollContainer/VBoxContainer
@onready var poetrycontainer: VBoxContainer = $Poetry/ScrollContainer/VBoxContainer
@onready var fanartcontainer: VBoxContainer = $FanArt/ScrollContainer/VBoxContainer
@onready var incompletecontainer: VBoxContainer = $Incomplete/ScrollContainer/VBoxContainer
@onready var submissionTypeDropdown: OptionButton = $OptionButton
@onready var mainBrain: Control = $".."
@onready var issue_number: LineEdit = $"../IndexPage/IssueNumber"
@onready var quote_of_the_week: TextEdit = $"../IndexPage/Quote of the Week"
@onready var quote_author: LineEdit = $"../IndexPage/QuoteAuthor"
@onready var pick_frontpage_button: Button = $"../IndexPage/PickFrontpageButton"
@onready var save_issue_dialog: FileDialog = $SaveIssueDialog
@onready var load_issue_dialog: FileDialog = $LoadIssueDialog
@onready var FrontPageListing: VBoxContainer = $"../IndexPage/ScrollContainer/VBoxContainer"
@onready var pick_issue_directory: Button = $"../IndexPage/pickIssueDirectory"
@onready var issue_dialog: FileDialog = $"../IndexPage/pickIssueDirectory/IssuePath/IssueDialog"
@onready var issue_path: LineEdit = $"../IndexPage/pickIssueDirectory/IssuePath"
@onready var rootObject: Node2D = $"../.."
@onready var first_build: CheckButton = $"../IndexPage/firstBuild"
@onready var link: LineEdit = $Link
@onready var order_navigation: Control = $OrderNavigation



class MediaEntry:
	var entryType="";
	var entryName="";
	var entryAuthors="";
	var entryCaption="";
	var entryTags="";
	var entryAltText;
	var entryIsComplete=false;
	var entryMediaFile="";
	var entryThumbFile="";
	var entryAuthorLink=""
	var entryUUID="";
	
	func _init() -> void:
		self.entryUUID=randi_range(10,2147483640);#just about max int. its fiiiiine.

	func exportData():
		return [entryType,
		entryName,
		entryAuthors,
		entryCaption,
		entryTags,
		entryAltText,
		entryIsComplete,
		entryMediaFile,
		entryThumbFile,
		entryAuthorLink,
		entryUUID]
		
	func exportFrontPageData():
		return str([self.entryMediaFile,self.entryThumbFile,self.entryName,self.entryAuthors,self.entryCaption,self.entryType,self.entryAltText,self.entryTags,self.entryAuthorLink])
	
	func importData(newEntryType,newEntryName,newEntryAuthors,newEntryCaption,newEntryTags,newEntryAltText,newEntryIsComplete,newEntryMediaFile,newEntryThumbFile,newEntryAuthorLink,newEntryUUID):
		self.entryType=newEntryType
		self.entryName=newEntryName
		self.entryAuthors=newEntryAuthors
		self.entryCaption=newEntryCaption
		self.entryTags=newEntryTags
		self.entryAltText=newEntryAltText
		self.entryIsComplete=newEntryIsComplete
		self.entryMediaFile=newEntryMediaFile
		self.entryThumbFile=newEntryThumbFile
		self.entryAuthorLink=newEntryAuthorLink;
		self.entryUUID=newEntryUUID

var currentlySelected=null;#the class of currently selectedentry
var buttonCurrentlySelected=null;#the button

var Comics=[];
var Articles=[];
var ContinuedSeries=[];
var NewSeries=[];
var ShortStories=[];
var Poetry=[];
var FanArt=[];
var Incomplete=[];

var poolOfCandidates=[];

func generateTextPreview(filepath):
	if(filepath!=""):
		print("attempting to open", filepath);
		var file = FileAccess.open(filepath, FileAccess.READ)
		var content = file.get_as_text()
		submission_text.text=content


func SetGUItoType(mediaKindType):
	match mediaKindType:
		"Comics":
			file_dialog.filters=["*.gif,*.png,*.jpg,*.jpeg"];
			alt_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0);
			pick_thumbnail.modulate=Color(1.0, 1.0, 1.0, 1.0);
			comic_preview.visible=true;
			submission_text.visible=false;
			pick_file.disabled=false;
		"Articles":
			file_dialog.filters=["*.txt,*.html"];
			alt_text.modulate=Color(0.191, 0.12, 0.106, 1.0);
			thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0);
			pick_thumbnail.modulate=Color(1.0, 1.0, 1.0, 1.0);
			caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			comic_preview.visible=false;
			submission_text.visible=true;
			pick_file.disabled=false;
		"ContinuedSeries":
			file_dialog.filters=["*.txt,*.html"];
			alt_text.modulate=Color(0.191, 0.12, 0.106, 1.0);
			thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0);
			pick_thumbnail.modulate=Color(1.0, 1.0, 1.0, 1.0);
			caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			comic_preview.visible=false;
			submission_text.visible=true;
			pick_file.disabled=false;
		"NewSeries":
			file_dialog.filters=["*.txt,*.html"];
			alt_text.modulate=Color(0.191, 0.12, 0.106, 1.0);
			thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0);
			pick_thumbnail.modulate=Color(1.0, 1.0, 1.0, 1.0);
			caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			comic_preview.visible=false;
			submission_text.visible=true;
			pick_file.disabled=false;
		"ShortStories":
			file_dialog.filters=["*.txt,*.html"];
			alt_text.modulate=Color(0.191, 0.12, 0.106, 1.0);
			thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0);
			pick_thumbnail.modulate=Color(1.0, 1.0, 1.0, 1.0);
			caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			comic_preview.visible=false;
			submission_text.visible=true;
			pick_file.disabled=false;
		"Poetry":
			file_dialog.filters=["*.txt,*.html"];
			alt_text.modulate=Color(0.191, 0.12, 0.106, 1.0);
			thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0);
			pick_thumbnail.modulate=Color(1.0, 1.0, 1.0, 1.0);
			caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			comic_preview.visible=false;
			submission_text.visible=true;
			pick_file.disabled=false;
		"FanArt":
			file_dialog.filters=["*.gif,*.png,*.jpg,*.jpeg"];
			alt_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			thumbnail_path.modulate=Color(0.191, 0.12, 0.106, 1.0);
			pick_thumbnail.modulate=Color(0.191, 0.12, 0.106, 1.0);
			caption_text.modulate=Color(0.191, 0.12, 0.106, 1.0);
			comic_preview.visible=true;
			submission_text.visible=false;
			pick_file.disabled=false;
		_:
			file_dialog.filters=[""];
			alt_text.modulate=Color(0.192, 0.808, 0.106, 1.0);
			caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
			comic_preview.visible=false;
			submission_text.visible=true;
			pick_file.disabled=true;
			print("Something went wrong with the selection?");

func GetEntry(indexNumber, type):
	match type:
		"Comics":
			return Comics[indexNumber]
		"Articles":
			return Articles[indexNumber]
		"ContinuedSeries":
			return ContinuedSeries[indexNumber]
		"NewSeries":
			return NewSeries[indexNumber]
		"ShortStories":
			return ShortStories[indexNumber]
		"Poetry":
			return Poetry[indexNumber]
		"FanArt":
			return FanArt[indexNumber]
		"Incomplete":
			return Incomplete[indexNumber]
		_:
			print("something went terribly wrong");

func AddEntry(mediaEntry):
	print("Adding of type:",mediaEntry.entryType, " and completeness: ",mediaEntry.entryIsComplete);
	if(mediaEntry.entryIsComplete==false):
		print("new one is marked as incomplete. filing as such");
		Incomplete.append(mediaEntry);
		print(Incomplete);
	else:
		match mediaEntry.entryType:
			"Comics":
				Comics.append(mediaEntry)
				print(Comics.size()," comics entered");
			"Articles":
				Articles.append(mediaEntry)
				print(Articles.size()," articles entered");
			"ContinuedSeries":
				ContinuedSeries.append(mediaEntry)
				print(ContinuedSeries.size()," contSeries entered");
			"NewSeries":
				NewSeries.append(mediaEntry)
				print(NewSeries.size()," newSeries entered");
			"ShortStories":
				ShortStories.append(mediaEntry)
				print(ShortStories.size()," Shorts entered");
			"Poetry":
				Poetry.append(mediaEntry)
				print(Poetry.size()," poems entered");
			"FanArt":
				FanArt.append(mediaEntry)
				print(FanArt.size()," FanArts entered");
			_:
				print("something went terribly wrong while tying to save");
	#Add a button to the subList of entries
	var newEntry=Button.new();#create a new checkbox object
	if(mediaEntry.entryIsComplete):
		getCorrectContainer(mediaEntry.entryType).add_child(newEntry)#gets the selected node name, then converts that to the vbox container node to add the child to.
	else:
		incompletecontainer.add_child(newEntry);
	if(mediaEntry.entryName==""):#if it hadnt gotten a name yet, give it one based on its UUID.
		newEntry.text="untitled#"+str(mediaEntry.entryUUID)
	else:
		newEntry.text=mediaEntry.entryName;#set its display as the name of the title.
	newEntry.alignment=HORIZONTAL_ALIGNMENT_LEFT;
	newEntry.connect("pressed",_load_media_details.bind(newEntry.get_node(".")))
	
func RemoveEntry(entryIndex,submissionType):
	print("Removing ", entryIndex);
	match submissionType: #there is a more efficient way of doing this, but i dont really care. this is simple. 
		"Comics":
			Comics.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",Comics);
		"Articles":
			Articles.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",Articles);
		"ContinuedSeries":
			ContinuedSeries.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",ContinuedSeries);
		"NewSeries":
			NewSeries.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",NewSeries);
		"ShortStories":
			ShortStories.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",ShortStories);
		"Poetry":
			Poetry.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",Poetry);
		"FanArt":
			FanArt.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",FanArt);	
		"Incomplete":
			Incomplete.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",Incomplete);
		_:
			print("Nothing was removed: something went terribly wrong");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func clearEnteredData() -> void:
	#returns an array of all the entered data in the following format:
	#[EntryType, Title, Author, Caption, Tags, AltText, FilePath,ThumbnailPath,
	submissionTypeDropdown.selected=-1;
	title_name.text="";
	author.text="";
	caption_text.text="";
	tags.text="";
	alt_text.text="";
	file_path.text="";
	link.text="";
	thumbnail_path.text="";
	submission_text.text="";
	submissionTypeDropdown.modulate=Color(1.0, 1.0, 1.0, 1.0)
	title_name.modulate=Color(1.0, 1.0, 1.0, 1.0)
	author.modulate=Color(1.0, 1.0, 1.0, 1.0)
	caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0)
	tags.modulate=Color(1.0, 1.0, 1.0, 1.0)
	alt_text.modulate=Color(1.0, 1.0, 1.0, 1.0)
	file_path.modulate=Color(1.0, 1.0, 1.0, 1.0)
	thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0);
	pick_thumbnail.modulate=Color(1.0, 1.0, 1.0, 1.0);
	caption_text.modulate=Color(1.0, 1.0, 1.0, 1.0);
	thumbnail_path.modulate=Color(1.0, 1.0, 1.0, 1.0)
	for a in getAllButtons():#all the children of the various containers. Create a list.
		print(a.text)
		a.modulate=Color(1.0, 1.0, 1.0, 1.0) #visually deselect them
	thumb_preview.texture = null
	comic_preview.texture=null;
	pick_file.disabled=true;#these flags set to default entry
	comic_preview.visible=false;
	submission_text.visible=true;
	order_navigation.visible=false;

func getEntryTypeList(submissionType) -> Array:
	print("looking for a container match for ", submissionType);
	match submissionType:
		"Comics":
			return Comics;
		"Articles":
			return Articles
		"ContinuedSeries":
			return ContinuedSeries
		"NewSeries":
			return NewSeries
		"ShortStories":
			return ShortStories
		"Poetry":
			return Poetry
		"FanArt":
			return FanArt
		_:
			return Incomplete; #also works as a catchall
			
func getCorrectContainer(submissionType) -> VBoxContainer:
	print("looking for a container match for ", submissionType);
	match submissionType:
		"Comics":
			return comiccontainer;
		"Articles":
			return articlecontainer
		"ContinuedSeries":
			return contSeriescontainer
		"NewSeries":
			return newSeriescontainer
		"ShortStories":
			return shortStoriescontainer
		"Poetry":
			return poetrycontainer
		"FanArt":
			return fanartcontainer
		_:
			return incompletecontainer; #also works as a catchall
		
func getAllButtons() -> Array:
	var buttonList=[];
	buttonList=buttonList+comiccontainer.get_children();
	buttonList=buttonList+articlecontainer.get_children();
	buttonList=buttonList+contSeriescontainer.get_children();
	buttonList=buttonList+newSeriescontainer.get_children();
	buttonList=buttonList+shortStoriescontainer.get_children();
	buttonList=buttonList+poetrycontainer.get_children();
	buttonList=buttonList+fanartcontainer.get_children();
	buttonList=buttonList+incompletecontainer.get_children();
	return buttonList;

func getAllEntries() -> Array:
	var entryList=[];
	entryList=entryList+Comics;
	entryList=entryList+Articles;
	entryList=entryList+ContinuedSeries;
	entryList=entryList+NewSeries;
	entryList=entryList+ShortStories;
	entryList=entryList+Poetry;
	entryList=entryList+FanArt;
	entryList=entryList+Incomplete;
	return entryList;

func _on_add_entry_pressed() -> void:
	var completeFlag=true;
	if(currentlySelected==null):
		currentlySelected=MediaEntry.new();#create a new entry
	else:
		#Since we are about to resave the data, clear out the old data.
		var type=buttonCurrentlySelected.get_parent().get_parent().get_parent().name#a bit of a hack to load the type. functional :3
		var index=buttonCurrentlySelected.get_index(true) 
		RemoveEntry(index,type);#also remove it from the database
		buttonCurrentlySelected.queue_free();#kill the button that was associated with it, so we can readd it under any potentially updated name or category
	#Check to see if the each data entry is complete, highlighting ones that are not.
	#if incomplete, highlight incomplete things.
	if(submissionTypeDropdown.selected==-1):
		completeFlag=false;
	currentlySelected.entryType=submissionTypeDropdown.get_item_text(submissionTypeDropdown.selected)
	if(title_name.text==""):
		completeFlag=false;
	currentlySelected.entryName=title_name.text
	if(author.text==""):
		completeFlag=false;
	currentlySelected.entryAuthors=author.text;
	if(caption_text.text==""):
		if(currentlySelected.entryType!="FanArt"):#this becomes optional if its Fanart
			completeFlag=false;
	currentlySelected.entryCaption=caption_text.text;
	if(tags.text==""):
		completeFlag=false;
	currentlySelected.entryTags=tags.text;
	if(link.text==""):
		pass
	else:
		#check to see if the first characters are HTTPS:// or HTTP:// If these are missing, add them.
		if(link.text.to_lower().begins_with("https://") or link.text.to_lower().begins_with("http://")):
			print("Sick link bro, you followed the protocol on your own!");
		else:
			print("Correcting link start to include the HTTPS.");
			link.text="https://"+link.text
		#completeFlag=false; #this is optional.
	currentlySelected.entryAuthorLink=link.text;
	if(alt_text.text==""):
		if(currentlySelected.entryType=="Comics" or currentlySelected.entryType=="FanArt" ):#only enforce the completeness of this one if its a comic
			completeFlag=false;
	currentlySelected.entryAltText=alt_text.text;
	if(file_path.text==""):
		completeFlag=false;
	currentlySelected.entryMediaFile=file_path.text;
	if(thumbnail_path.text==""):
		if(currentlySelected.entryType!="FanArt"):#this becomes optional if its Fanart
			completeFlag=false;
	currentlySelected.entryThumbFile=thumbnail_path.text;
	currentlySelected.entryIsComplete=completeFlag;#flag if the entry is complete or not.
	print("Saved this data. ",currentlySelected.exportData());
	
	
	#Save the data to the database
	AddEntry(currentlySelected);
	currentlySelected=null;#we are complete. release its spirit.
	
	#Clear the entries of highlighting and data
	clearEnteredData()

func _load_media_details(nodeClicked) -> void:
	print("Loading details.")
	var type=nodeClicked.get_parent().get_parent().get_parent().name#a bit of a hack to load the type. functional :3
	var index=nodeClicked.get_index(true) 
	order_navigation.visible=true;#make the navigator visible
	order_navigation.position.y=nodeClicked.global_position.y #make it inline of the node currently selected, so it appears in the right spot
	#nodeClicked.add_child(order_navigation);
	buttonCurrentlySelected=nodeClicked;
	print("getting the ", index, " file of type: ",type)
	#load the data from the database into thier GUI slots
	currentlySelected=GetEntry(index,type);
	file_path.text=currentlySelected.entryMediaFile
	thumbnail_path.text=currentlySelected.entryThumbFile;
	title_name.text=currentlySelected.entryName;
	author.text=currentlySelected.entryAuthors;
	caption_text.text=currentlySelected.entryCaption;
	alt_text.text=currentlySelected.entryAltText;
	link.text=currentlySelected.entryAuthorLink;
	tags.text=currentlySelected.entryTags;
	match currentlySelected.entryType:
		"Comics":
			submissionTypeDropdown.selected=0;
		"Articles":
			submissionTypeDropdown.selected=1;
		"ContinuedSeries":
			submissionTypeDropdown.selected=2;
		"NewSeries":
			submissionTypeDropdown.selected=3;
		"ShortStories":
			submissionTypeDropdown.selected=4;
		"Articles":
			submissionTypeDropdown.selected=5;
		"FanArt":
			submissionTypeDropdown.selected=6;
		"Incomplete":
			submissionTypeDropdown.selected=-1;
		_:
			submissionTypeDropdown.selected=-1;

	#GUI alterations. 
	thumb_preview.texture = null
	add_entry.disabled=true;
	SetGUItoType(currentlySelected.entryType);
	for a in getAllButtons():#all the children of the various containers. Create a list.
		a.modulate=Color(1.0, 1.0, 1.0, 1.0) #visually deselect them
	buttonCurrentlySelected.modulate=Color(0.2, 0.5, 0.295, 1.0)
	#everyone can do a load on the thumbnail
	var newImage= Image.load_from_file(currentlySelected.entryThumbFile);
	if(currentlySelected.entryThumbFile.ends_with(".gif")):#it will fail if it is a .gif. use an alt pathway
		print("trying .gif method")
		thumb_preview.texture = GifManager.animated_texture_from_file(currentlySelected.entryThumbFile)
	else:
		var newTexture=ImageTexture.create_from_image(newImage);
		print("setting thumbnail preview")
		thumb_preview.texture=newTexture
	comic_preview.visible=false;
	submission_text.visible=true;
	if(currentlySelected.entryType=="Comics" or currentlySelected.entryType=="FanArt"):#but this is only for comics. hehe reload the images.
		comic_preview.visible=true;#overrride for visiblity.
		submission_text.visible=false;
		submission_text.text="";#Clear this out, so that if we go back, and select text again, the old text isnt visible.
		print("loading image from ",currentlySelected.entryMediaFile)
		newImage= Image.load_from_file(currentlySelected.entryMediaFile);
		if(currentlySelected.entryMediaFile.ends_with(".gif")):#it will fail if it is a .gif. use an alt pathway
			print("trying .gif method")
			comic_preview.texture = GifManager.animated_texture_from_file(currentlySelected.entryMediaFile)
		else:
			var newTexture=ImageTexture.create_from_image(newImage);
			print("setting thumbnail preview")
			comic_preview.texture=newTexture
	else:#if it is not a comic, then we have some text to load. 
		generateTextPreview(currentlySelected.entryMediaFile);
		comic_preview.texture=null;#Clear this out, so if we switch back to comics, its cleared out.
	add_entry.disabled=false;


func _on_pick_file_pressed() -> void:
	file_dialog.visible=true;

func _on_pick_thumbnail_pressed() -> void:
	thumbnail_dialog.visible=true;

func _on_file_dialog_file_selected(selectedPath: String) -> void:
	file_dialog.visible=false;
	file_path.text=selectedPath;
	print("Selected FilePath: ",selectedPath)
	if(submissionTypeDropdown.get_item_text(submissionTypeDropdown.selected)=="Comics" or submissionTypeDropdown.get_item_text(submissionTypeDropdown.selected)=="FanArt"):#this is only for comics. hehe
		submission_text.text="";#Clear this out, so that if we go back, and select text again, the old text isnt visible.
		print("loading image from ",selectedPath)
		var newImage= Image.load_from_file(selectedPath);
		if(selectedPath.ends_with(".gif")):#it will fail if it is a .gif. use an alt pathway
			print("trying .gif method")
			comic_preview.texture = GifManager.animated_texture_from_file(selectedPath)
		else:
			var newTexture=ImageTexture.create_from_image(newImage);
			print("setting thumbnail preview")
			comic_preview.texture=newTexture
	else:#everything else that is not a comic, we will load as text.
		generateTextPreview(selectedPath);
		comic_preview.texture=null;#Clear this out, so if we switch back to comics, its cleared out.

func _on_thumbnail_dialog_file_selected(selectedPath: String) -> void:
	thumbnail_dialog.visible=false;
	thumbnail_path.text=selectedPath;
	print("loading image from ",selectedPath)
	var newImage= Image.load_from_file(selectedPath);
	if(selectedPath.ends_with(".gif")):#it will fail if it is a .gif. use an alt pathway
		print("trying .gif method")
		thumb_preview.texture = GifManager.animated_texture_from_file(selectedPath)
	else:
		var newTexture=ImageTexture.create_from_image(newImage);
		print("setting thumbnail preview")
		thumb_preview.texture=newTexture

func _on_option_button_item_selected(index: int) -> void:
	if(index!=-1):
		#we have selected things! Depending on what was selected, enable or disable things.
		SetGUItoType(submissionTypeDropdown.get_item_text(submissionTypeDropdown.selected));
	else:
		pick_file.disabled=true;
		print("Didnt select any type. shrug?");

func _on_subtract_comic_pressed() -> void:
	if(currentlySelected!=null and buttonCurrentlySelected!=null): #we have something selected/
		var type=buttonCurrentlySelected.get_parent().get_parent().get_parent().name#a bit of a hack to load the type. functional :3
		var index=buttonCurrentlySelected.get_index(true) 
		RemoveEntry(index,type);
		buttonCurrentlySelected.queue_free();
		buttonCurrentlySelected=null;
		currentlySelected=null;
	clearEnteredData()


func _on_cancel_pressed() -> void:
	buttonCurrentlySelected=null;
	currentlySelected=null;
	clearEnteredData()

func save_to_file(location, content):
	var file = FileAccess.open(location, FileAccess.WRITE)
	file.store_string(content)
	print("finished saving");

func load_from_file(location):
	print("loading file: ",location);
	var file = FileAccess.open(location, FileAccess.READ)
	var content=[];
	while file.get_position() < file.get_length():
		var newEntry=str_to_var(file.get_line())#fun facty: the first of these is not actually a new entry.
		print("recovered the data of ", newEntry);
		content.append(newEntry);
	print("finished reading file!");
	return content


func _on_save_issue_pressed() -> void:
	save_issue_dialog.visible=true;
	

func _on_pick_frontpage_button_pressed() -> void:
	poolOfCandidates=Articles+ContinuedSeries+NewSeries+ShortStories+Poetry #no comics, to avoid nested images. thats why we are not using getAllEntries();
	for n in FrontPageListing.get_children():#go through and clear out any existing ones.
		n.queue_free()
	if(len(poolOfCandidates)<3):
		print("NOT ENOUGH CONTENT. 3 entries minimum.")
	else:
		poolOfCandidates.shuffle();
		print(poolOfCandidates[0].entryName,poolOfCandidates[1].entryName,poolOfCandidates[2].entryName)
		#set up new text objects, and add them to the container to show whos been added.
		var newFrontpageEntry=Label.new();#create a new checkbox object
		FrontPageListing.add_child(newFrontpageEntry)#attach the newly created node
		newFrontpageEntry.text=poolOfCandidates[0].entryName+" by "+poolOfCandidates[0].entryAuthors;#set its display as the name of the title.
		newFrontpageEntry=Label.new();#create a new checkbox object
		FrontPageListing.add_child(newFrontpageEntry)#attach the newly created node
		newFrontpageEntry.text=poolOfCandidates[1].entryName+" by "+poolOfCandidates[1].entryAuthors;#set its display as the name of the title.
		newFrontpageEntry=Label.new();#create a new checkbox object
		FrontPageListing.add_child(newFrontpageEntry)#attach the newly created node
		newFrontpageEntry.text=poolOfCandidates[2].entryName+" by "+poolOfCandidates[2].entryAuthors;#set its display as the name of the title.
		
	pass # Replace with function body.

func _on_title_name_text_changed(new_text: String) -> void:
	#check to see if newly added letters are in the forbidden character list. If they are, undo, and reset cursor position to the end.
	#Not doing this will allow characters in the URL that dont get escaped, and break becuase they are used by HTTP for other things
	if(new_text.substr(len(new_text)-1,1) in "'?\"&%@][/\\$"):
		print("Illegal Character!");
		title_name.text=title_name.text.substr(0,len(new_text)-1)#erase the last text
		title_name.caret_column=len(title_name.text)#return the cursor back to the end


func _on_load_issue_pressed() -> void:
	load_issue_dialog.visible=true;
	
func _on_load_issue_dialog_file_selected(chosenFile: String) -> void:
	load_issue_dialog.visible=false;
	var loadedIssue=load_from_file(chosenFile);
	print(loadedIssue);
	#clear out existing entries
	Comics=[];
	Articles=[];
	ContinuedSeries=[];
	NewSeries=[];
	ShortStories=[];
	Poetry=[];
	FanArt=[];
	Incomplete=[];
	#clear out buttons
	for a in getAllButtons():
		a.queue_free();
	#take out the first element. We stashed some information about the issue itself there. 
	issue_number.text=loadedIssue[0][0]
	print("grabbed issue number: ",loadedIssue[0][0]);
	quote_of_the_week.text=loadedIssue[0][1]
	print("grabbed Quote: ",loadedIssue[0][1]);
	quote_author.text=loadedIssue[0][2]
	print("grabbed quote author: ",loadedIssue[0][2]);
	loadedIssue.pop_front(); #we are done with it. We can clear it out now, that way everything after this acts regularly.
	print("loading entries")
	for newEntry in loadedIssue:
		print(newEntry);
		var entryToAdd=MediaEntry.new();
		print("type: ",newEntry[0]);
		entryToAdd.entryType=newEntry[0]
		print("name: ",newEntry[1]);
		entryToAdd.entryName=newEntry[1]
		print("Author: ",newEntry[2]);
		entryToAdd.entryAuthors=newEntry[2]
		print("Caption: ",newEntry[3]);
		entryToAdd.entryCaption=newEntry[3]
		print("Tags: ",newEntry[4]);
		entryToAdd.entryTags=newEntry[4]
		print("Alt: ",newEntry[5]);
		entryToAdd.entryAltText=newEntry[5]
		print("Is the entry complete?: ",newEntry[6]);
		entryToAdd.entryIsComplete=newEntry[6]
		print("filepath: ",newEntry[7]);
		entryToAdd.entryMediaFile=newEntry[7]
		print("Thumbnail Path: ",newEntry[8]);
		entryToAdd.entryThumbFile=newEntry[8]
		print("Author Links: ",newEntry[9]);
		if(newEntry[9]==""):
			pass
		else:
			#check to see if the first characters are HTTPS:// or HTTP:// If these are missing, add them.
			if(newEntry[9].to_lower().begins_with("https://") or newEntry[9].to_lower().begins_with("http://")):
				print("Sick link bro, you followed the protocol on your own!");
			else:
				print("Correcting link start to include the HTTPS.");
				newEntry[9]="https://"+newEntry[9]

		entryToAdd.entryAuthorLink=newEntry[9]
		print("UUID: ",newEntry[10]);
		entryToAdd.entryUUID=newEntry[10]
		AddEntry(entryToAdd)#all the data has been set, now we can reorganize it.
	
		
	
#read the file of all the data, one entry per line issue_number.text,quote_of_the_week.text,quote_author.text
#create a New.Entry() for each, and assign the data from the line
#sort the entries into thier different categories (check for incompleteness to sort those in there)
#check that the files still exist. If they dont, move to incomplete, and clear the value.
#add buttons for each


func _on_build_pressed() -> void:
	if(quote_of_the_week.text!=null and quote_author!=null and poolOfCandidates.size()>=3):
		#create a "failstate" where the button flashes if the issue isnt fully built
		if(issue_number.text!="" and issue_path.text!=""):
			print("saving issue ",issue_number.text," to ",issue_path.text)
			rootObject.SubmitFinalData(str(Comics),str(Articles),str(ContinuedSeries),str(NewSeries),str(ShortStories),str(Poetry),str(FanArt),issue_path.text,issue_number.text)
			print("The first build button state is ",first_build.button_pressed)
			
			
			rootObject.makeDirectory(issue_path.text,issue_number.text,first_build.button_pressed);
			#systematically send all the data with the appropritate metadata fileType,fileOfMedia,fileofThumbnail,title,authors,caption,alttext,entryTags
			for targetArticles in Articles:
				print("Starting build process for Fanarts");
				rootObject.prepareAndSend("article",targetArticles.entryMediaFile,targetArticles.entryThumbFile,targetArticles.entryName,targetArticles.entryAuthors,targetArticles.entryCaption,"",targetArticles.entryTags,targetArticles.entryAuthorLink)#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetContinuedSeries in ContinuedSeries:
				print("Starting build process for Fanarts");
				rootObject.prepareAndSend("continuedSeries",targetContinuedSeries.entryMediaFile,targetContinuedSeries.entryThumbFile,targetContinuedSeries.entryName,targetContinuedSeries.entryAuthors,targetContinuedSeries.entryCaption,"",targetContinuedSeries.entryTags,targetContinuedSeries.entryAuthorLink)#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetNewSeries in NewSeries:
				print("Starting build process for Fanarts");
				rootObject.prepareAndSend("newSeries",targetNewSeries.entryMediaFile,targetNewSeries.entryThumbFile,targetNewSeries.entryName,targetNewSeries.entryAuthors,targetNewSeries.entryCaption,"",targetNewSeries.entryTags,targetNewSeries.entryAuthorLink)#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetShortStories in ShortStories:
				print("Starting build process for Fanarts");
				rootObject.prepareAndSend("shortStory",targetShortStories.entryMediaFile,targetShortStories.entryThumbFile,targetShortStories.entryName,targetShortStories.entryAuthors,targetShortStories.entryCaption,"",targetShortStories.entryTags,targetShortStories.entryAuthorLink)#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetPoetry in Poetry:
				print("Starting build process for Fanarts");
				rootObject.prepareAndSend("poetry",targetPoetry.entryMediaFile,targetPoetry.entryThumbFile,targetPoetry.entryName,targetPoetry.entryAuthors,targetPoetry.entryCaption,"",targetPoetry.entryTags,targetPoetry.entryAuthorLink)#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetFanArt in FanArt:
				print("Starting build process for Fanarts");
				rootObject.prepareAndSend("fanart",targetFanArt.entryMediaFile,targetFanArt.entryMediaFile,targetFanArt.entryName,targetFanArt.entryAuthors,targetFanArt.entryCaption,targetFanArt.entryAltText,targetFanArt.entryTags,targetFanArt.entryAuthorLink)#fileOfComic,fileofThumbnail,title,authors,caption
			for targetComic in Comics:
				print("Starting build process for Fanarts");
				rootObject.prepareAndSend("comic",targetComic.entryMediaFile,targetComic.entryThumbFile,targetComic.entryName,targetComic.entryAuthors,targetComic.entryCaption,targetComic.entryAltText,targetComic.entryTags,targetComic.entryAuthorLink)#fileOfComic,fileofThumbnail,title,authors,caption
			#Now that things are in its place, this can be run
			rootObject.makeIndex(quote_of_the_week.text,quote_author.text,str(poolOfCandidates[0].exportFrontPageData()),str(poolOfCandidates[1].exportFrontPageData()),str(poolOfCandidates[2].exportFrontPageData()))
			print("attempting the Add Archive Function, sending the data ",issue_number.text," , ",issue_path.text)
			rootObject.addArchive(issue_number.text,issue_path.text)
			print("Process complete. Enjoy the Post!")
		else:
			print("Still needs issuenumber and a filepath to save")
	else:
		print("this issue isnt ready yet!")



func _on_pick_issue_directory_pressed() -> void:
	issue_dialog.visible=true;
	pass # Replace with function body.


func _on_issue_dialog_dir_selected(issueSelectedDirectory: String) -> void:
	issue_path.text=issueSelectedDirectory;
	issue_dialog.visible=false;
	
	pass # Replace with function body.


func _on_save_issue_dialog_file_selected(chosenDirectory: String) -> void:
	save_issue_dialog.visible=false;
	print("saving to ",chosenDirectory);
	var entriesToSave=getAllEntries();
	var saveOutput=JSON.stringify([issue_number.text,quote_of_the_week.text,quote_author.text])+"\n"; #start with some data about the issue.
	for targetEntry in entriesToSave:
		saveOutput+=JSON.stringify(targetEntry.exportData())+"\n"; #stringify
	print(saveOutput)
	save_to_file(chosenDirectory,saveOutput);
#func loading

func clickedArrangeUp():
	#get info about the current selection
	var type=buttonCurrentlySelected.get_parent().get_parent().get_parent().name#a bit of a hack to load the type. functional :3
	var index=buttonCurrentlySelected.get_index(true) 
	#print("index:",index, "position: ",buttonCurrentlySelected.global_position.y, " name: ",buttonCurrentlySelected.text)
	if(index>0):#this prevents it from working out of bounds
		match type:
			"Comics":
				var holding=Comics[index];
				Comics[index]=Comics[index-1];
				Comics[index-1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index-1);#also move the button up by one. the vContainer should rearrange.
			"Articles":
				var holding=Articles[index];
				Articles[index]=Articles[index-1];
				Articles[index-1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index-1);#also move the button up by one. the vContainer should rearrange.
			"ContinuedSeries":
				var holding=ContinuedSeries[index];
				ContinuedSeries[index]=ContinuedSeries[index-1];
				ContinuedSeries[index-1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index-1);#also move the button up by one. the vContainer should rearrange.
			"NewSeries":
				var holding=NewSeries[index];
				NewSeries[index]=NewSeries[index-1];
				NewSeries[index-1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index-1);#also move the button up by one. the vContainer should rearrange.
			"ShortStories":
				var holding=ShortStories[index];
				ShortStories[index]=ShortStories[index-1];
				ShortStories[index-1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index-1);#also move the button up by one. the vContainer should rearrange.
			"Poetry":
				var holding=Poetry[index];
				Poetry[index]=Poetry[index-1];
				Poetry[index-1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index-1);#also move the button up by one. the vContainer should rearrange.
			"FanArt":
				var holding=FanArt[index];
				FanArt[index]=FanArt[index-1];
				FanArt[index-1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index-1);#also move the button up by one. the vContainer should rearrange.
			_:#Incomplete also works as a catchall
				var holding=Incomplete[index];
				Incomplete[index]=Incomplete[index-1];
				Incomplete[index-1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index-1);#also move the button up by one. the vContainer should rearrange.
		# currentlySelected is the entry Object.
	#order_navigation.global_position.y=buttonCurrentlySelected.global_position.y #make it inline of the node currently selected, so it appears in the right spot
	#print("End index:",buttonCurrentlySelected.get_index(true) , " position: ",buttonCurrentlySelected.global_position.y, " name: ",buttonCurrentlySelected.text)
	
func clickedArrangeDown():
		#get info about the current selection
	var type=buttonCurrentlySelected.get_parent().get_parent().get_parent().name#a bit of a hack to load the type. functional :3
	var index=buttonCurrentlySelected.get_index(true) 
	#print("Start index:",index, " position: ",buttonCurrentlySelected.global_position.y, " name: ",buttonCurrentlySelected.text)
	if(index<buttonCurrentlySelected.get_parent().get_child_count()-1):#this prevents it from working out of bounds
		match type:
			"Comics":
				var holding=Comics[index];
				Comics[index]=Comics[index+1];
				Comics[index+1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index+1);#also move the button up by one. the vContainer should rearrange.
			"Articles":
				var holding=Articles[index];
				Articles[index]=Articles[index+1];
				Articles[index+1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index+1);#also move the button up by one. the vContainer should rearrange.
			"ContinuedSeries":
				var holding=ContinuedSeries[index];
				ContinuedSeries[index]=ContinuedSeries[index+1];
				ContinuedSeries[index+1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index+1);#also move the button up by one. the vContainer should rearrange.
			"NewSeries":
				var holding=NewSeries[index];
				NewSeries[index]=NewSeries[index+1];
				NewSeries[index+1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index+1);#also move the button up by one. the vContainer should rearrange.
			"ShortStories":
				var holding=ShortStories[index];
				ShortStories[index]=ShortStories[index+1];
				ShortStories[index+1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index+1);#also move the button up by one. the vContainer should rearrange.
			"Poetry":
				var holding=Poetry[index];
				Poetry[index]=Poetry[index+1];
				Poetry[index+1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index+1);#also move the button up by one. the vContainer should rearrange.
			"FanArt":
				var holding=FanArt[index];
				FanArt[index]=FanArt[index+1];
				FanArt[index+1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index+1);#also move the button up by one. the vContainer should rearrange.
			_:#Incomplete also works as a catchall
				var holding=Incomplete[index];
				Incomplete[index]=Incomplete[index+1];
				Incomplete[index+1]=holding;
				getCorrectContainer(type).move_child(buttonCurrentlySelected,index+1);#also move the button up by one. the vContainer should rearrange.
		# currentlySelected is the entry Object.
	#order_navigation.global_position.y=buttonCurrentlySelected.global_position.y #make it inline of the node currently selected, so it appears in the right spot
	#print("End index:",buttonCurrentlySelected.get_index(true) , " position: ",buttonCurrentlySelected.global_position.y, " name: ",buttonCurrentlySelected.text)
