extends Control
enum types {COMIC,ARTICLE,CONTINUEDSERIES,NEWSERIES,SHORTSTORIES,POETRY}
@onready var savefiledialog: FileDialog = $"Panel/Pick File/FilePath/FileDialog"
@onready var savefile_path: LineEdit = $"Panel/Pick File/FilePath"
@onready var issue_number: LineEdit = $Panel/IssueNumber
@onready var rootObject: Node2D = $".."
@onready var quote_of_the_week: TextEdit = $"IndexPage/Quote of the Week"
@onready var quote_author: LineEdit = $IndexPage/Author
@onready var FrontPageListing: VBoxContainer = $IndexPage/ScrollContainer/VBoxContainer
@onready var first_build: CheckButton = $Panel/firstBuild


var Comics=[];
var Articles=[];
var ContinuedSeries=[];
var NewSeries=[];
var ShortStories=[];
var Poetry=[];
var Incomplete=[];
var poolOfCandidates=[];
#var contentList=[Comics;
# Called when the node enters the scene tree for the first time.
#As things are added, store the 
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
		"Incomplete":
			return Incomplete[indexNumber]
		_:
			print("something went terribly wrong");

func AddEntry(fileOfComic,fileofThumbnail,title,authors,caption,entryType,altText,entryTags):
	print("Adding of type:",entryType);
	match entryType:
		"Comics":
			Comics.append([fileOfComic,fileofThumbnail,title,authors,caption,altText,entryType,entryTags])
			print(Comics);
		"Articles":
			Articles.append([fileOfComic,fileofThumbnail,title,authors,caption,"null",entryType,entryTags])
			print(Articles);
		"ContinuedSeries":
			ContinuedSeries.append([fileOfComic,fileofThumbnail,title,authors,caption,"null",entryType,entryTags])
			print(ContinuedSeries);
		"NewSeries":
			NewSeries.append([fileOfComic,fileofThumbnail,title,authors,caption,"null",entryType,entryTags])
			print(NewSeries);
		"ShortStories":
			ShortStories.append([fileOfComic,fileofThumbnail,title,authors,caption,"null",entryType,entryTags])
			print(ShortStories);
		"Poetry":
			Poetry.append([fileOfComic,fileofThumbnail,title,authors,caption,"null",entryType,entryTags])
			print(Poetry);
		"Incomplete":
			Incomplete.append([fileOfComic,fileofThumbnail,title,authors,caption,"null",entryType,entryTags]);
			print(Incomplete);
		_:
			print("something went terribly wrong while tying to save");
			
func EditEntry(indexNumber, fileOfComic,fileofThumbnail,title,authors,caption,entryType,altText,entryTags):
	print("Adding of type:",entryType);
	match entryType:
		"Comics":
			Comics[indexNumber]=[fileOfComic,fileofThumbnail,title,authors,caption,altText,entryType,entryTags]
			print(Comics);
		"Articles":
			Articles[indexNumber]=[fileOfComic,fileofThumbnail,title,authors,caption,altText,entryType,entryTags]
			print(Articles);
		"ContinuedSeries":
			ContinuedSeries[indexNumber]=[fileOfComic,fileofThumbnail,title,authors,caption,altText,entryType,entryTags]
			print(ContinuedSeries);
		"NewSeries":
			NewSeries[indexNumber]=[fileOfComic,fileofThumbnail,title,authors,caption,altText,entryType,entryTags]
			print(NewSeries);
		"ShortStories":
			ShortStories[indexNumber]=[fileOfComic,fileofThumbnail,title,authors,caption,altText,entryType,entryTags]
			print(ShortStories);
		"Poetry":
			Poetry[indexNumber]=[fileOfComic,fileofThumbnail,title,authors,caption,altText,entryType,entryTags]
			print(Poetry);
		"Incomplete":
			Incomplete[indexNumber]=[fileOfComic,fileofThumbnail,title,authors,caption,altText,entryType,entryTags];
			print(Incomplete);
		_:
			print("something went terribly wrong");
			
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
		"Incomplete":
			Incomplete.remove_at(entryIndex);
			print("Removed",entryIndex, " list is now:",Incomplete);
		_:
			print("Nothing was removed: something went terribly wrong");

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:#
#	pass


func _on_build_pressed() -> void:
	if(quote_of_the_week.text!=null and quote_author!=null and poolOfCandidates.size()>=3):
		#create a "failstate" where the button flashes if the issue isnt fully built
		if(issue_number.text!="" and savefile_path.text!=""):
			print("saving issue ",issue_number.text," to ",savefile_path.text)
			rootObject.SubmitFinalData(str(Comics),str(Articles),str(ContinuedSeries),str(NewSeries),str(ShortStories),str(Poetry),savefile_path.text,issue_number.text)
			print("The first build button state is ",first_build.button_pressed)
			
			
			rootObject.makeDirectory(savefile_path.text,issue_number.text,first_build.button_pressed);
			#systematically send all the data with the appropritate metadata
			for targetArticles in Articles:
				rootObject.prepareAndSend("article",targetArticles[0],targetArticles[1],targetArticles[2],targetArticles[3],targetArticles[4],"",targetArticles[7])#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetContinuedSeries in ContinuedSeries:
				rootObject.prepareAndSend("continuedSeries",targetContinuedSeries[0],targetContinuedSeries[1],targetContinuedSeries[2],targetContinuedSeries[3],targetContinuedSeries[4],"",targetContinuedSeries[7])#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetNewSeries in NewSeries:
				rootObject.prepareAndSend("newSeries",targetNewSeries[0],targetNewSeries[1],targetNewSeries[2],targetNewSeries[3],targetNewSeries[4],"",targetNewSeries[7])#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetShortStories in ShortStories:
				rootObject.prepareAndSend("shortStory",targetShortStories[0],targetShortStories[1],targetShortStories[2],targetShortStories[3],targetShortStories[4],"",targetShortStories[7])#fileOfArticle,fileofThumbnail,title,authors,caption
			for targetPoetry in Poetry:
				rootObject.prepareAndSend("poetry",targetPoetry[0],targetPoetry[1],targetPoetry[2],targetPoetry[3],targetPoetry[4],"",targetPoetry[7])#fileOfArticle,fileofThumbnail,title,authors,caption

			for targetComic in Comics:
				rootObject.prepareAndSend("comic",targetComic[0],targetComic[1],targetComic[2],targetComic[3],targetComic[4],targetComic[5],targetComic[7])#fileOfComic,fileofThumbnail,title,authors,caption
			#Now that things are in its place, this can be run
			rootObject.makeIndex(quote_of_the_week.text,quote_author.text,str(poolOfCandidates[0]),str(poolOfCandidates[1]),str(poolOfCandidates[2]))
			print("attempting the Add Archive Function, sending the data ",issue_number.text," , ",savefile_path.text)
			rootObject.addArchive(issue_number.text,savefile_path.text)
			print("Process complete. Enjoy the Post!")
		else:
			print("Still needs issuenumber and a filepath to save")
	else:
		print("this issue isnt ready yet!")








#func _on_first_build_pressed() -> void:#
	#moves a copy of the Contact, About, Archives, The Image Files, over to the main directory. 
	#print("attempting to populate the main folder with crucial elements.");
	#rootObject.firstTimePopulate(savefile_path.text);
	#print("Complete");
	#pass # Replace with function body.
