
from py4godot.methods import private
from py4godot.signals import signal, SignalArg
from py4godot.classes import gdclass
from py4godot.classes.core import Vector3
from py4godot.classes.Node2D import Node2D
import os
import sys
import shutil
from pathlib import Path
from datetime import date    

@gdclass
class node_2d(Node2D):

	# define properties like this

	comicTemplate=""
	comicData=[];
	articleData=[];
	continuedSeriesData=[];
	newSeriesData=[];
	shortStoriesData=[];
	poetryData=[];
	fanArtData=[];
	issueFolder="";
	comicFolder="";
	articleFolder="";
	continuedSeriesFolder="";
	newSeriesFolder="";
	shortStoriesFolder="";
	poetryFolders="";
	
	CONTENTTEMPLATE="";
	
	ISSUENUMBER=-1;
	toggleFlag=True;
	
	# define signals like this
	test_signal = signal([SignalArg("test_arg", int)])

	def testUfn(self):
		print("hi")

	def firstTimePopulate(self, location):
		print("Metadata: Location",str(os.getcwd()))
		print("Metadata--- Contents: ",str(os.listdir(str(os.getcwd()))))
		print("making a copy of highest level pages")
		shutil.copyfile("IssueNULL/ArchiveBackground.jpg",location+"/ArchiveBackground.jpg")
		shutil.copyfile("IssueNULL/ArchivesMascot.png",location+"/ArchivesMascot.png")
		shutil.copyfile("IssueNULL/About.html",location+"/About.html")
		shutil.copyfile("IssueNULL/Archives.html",location+"/Archives.html")
		shutil.copyfile("IssueNULL/Contact.html",location+"/Contact.html")
		print("Finished making copy.")

	def makeDirectory(self, issueDirectory,issueNumber,firstTime):
		global issueFolder;
		global comicFolder;
		global articleFolder;
		global continuedSeriesFolder;
		global newSeriesFolder;
		global shortStoriesFolder;
		global poetryFolder;
		global fanArtFolder;
		global ISSUENUMBER
		global toggleFlag;
		toggleFlag=True
		#create a folder called Issue#
		ISSUENUMBER=issueNumber
		issueFolder=str(issueDirectory+"/Issue"+str(issueNumber))
		comicFolder=issueFolder+"/Comics";
		articleFolder=issueFolder+"/Articles";
		continuedSeriesFolder=issueFolder+"/ContinuedSeries";
		newSeriesFolder=issueFolder+"/NewSeries";
		shortStoriesFolder=issueFolder+"/ShortStories";
		poetryFolder=issueFolder+"/Poetry";
		fanArtFolder=issueFolder+"/FanArt";
		print("attempting to save directory at:",issueFolder)
		#os.makedirs(os.path.dirname(issueFolder), exist_ok=True)
		if not os.path.exists(issueFolder):
			os.makedirs(issueFolder)
			
		#Create subfolders for all media types
		if not os.path.exists(comicFolder):
			os.makedirs(comicFolder)
		if not os.path.exists(articleFolder):
			os.makedirs(articleFolder)
		if not os.path.exists(continuedSeriesFolder):
			os.makedirs(continuedSeriesFolder)
		if not os.path.exists(newSeriesFolder):
			os.makedirs(newSeriesFolder)
		if not os.path.exists(shortStoriesFolder):
			os.makedirs(shortStoriesFolder)
		if not os.path.exists(poetryFolder):
			os.makedirs(poetryFolder)
		if not os.path.exists(fanArtFolder):
			os.makedirs(fanArtFolder)
		
		print("Made directory at:",issueFolder, "moving tableofContents")
		shutil.copyfile("IssueNULL/Comics.html", issueFolder+"/Comics.html")
		shutil.copyfile("IssueNULL/Articles.html", issueFolder+"/Articles.html")
		shutil.copyfile("IssueNULL/ContinuedSeries.html", issueFolder+"/ContinuedSeries.html")
		shutil.copyfile("IssueNULL/NewSeries.html", issueFolder+"/NewSeries.html")
		shutil.copyfile("IssueNULL/ShortStories.html", issueFolder+"/ShortStories.html")
		shutil.copyfile("IssueNULL/Poetry.html", issueFolder+"/Poetry.html")
		shutil.copyfile("IssueNULL/FanArt.html", issueFolder+"/FanArt.html")
		#images
		shutil.copyfile("IssueNULL/Background.jpg", issueFolder+"/Background.jpg")
		shutil.copyfile("IssueNULL/Header.gif", issueFolder+"/Header.gif")
		shutil.copyfile("IssueNULL/Submit.gif", issueFolder+"/Submit.gif")
		if(firstTime):
			print("making a copy of Archive page. User, if you read this, You are responsible for moving the other pages to where they belong. Contact, Guidelines, About, and the images associated.")
			#shutil.copyfile("IssueNULL/ArchiveBackground.jpg",issueDirectory+"/ArchiveBackground.jpg")
			#shutil.copyfile("IssueNULL/ArchivesMascot.png",issueDirectory+"/ArchivesMascot.png")
			#shutil.copyfile("IssueNULL/About.html",issueDirectory+"/About.html")
			shutil.copyfile("IssueNULL/Archives.html",issueDirectory+"/Archives.html")
			#shutil.copyfile("IssueNULL/Contact.html",issueDirectory+"/Contact.html")
			print("Finished making copy.")

		shutil.copyfile("IssueNULL/FrontPage.html", issueFolder+"/FrontPage.html")
		###
		#Open these all up, and swap out for the issue number and publish date for the header
		print("finished Copying.")

	def makeIndex(self, quoteOfTheWeek,quoteAuthor,EntryOneData,EntryTwoData,EntryThreeData):
		print("Making Index")
		EntryOne=eval(EntryOneData)
		EntryTwo=eval(EntryTwoData)
		EntryThree=eval(EntryThreeData)
		print("loading indexpage")
		indexFile=open(issueFolder+"/FrontPage.html")
		indexContents=indexFile.read();
		print("recorded data, closing.")
		indexFile.close();
		print("IndexPageentry ONE",EntryOneData) 
		indexContents=indexContents.replace("$$ISSUENUMBER$$",str(ISSUENUMBER))
		indexContents=indexContents.replace("$$PUBLISHDATE$$",str(date.today().isoformat()))
		indexContents=indexContents.replace("$$QUOTE$$",str(quoteOfTheWeek))
		indexContents=indexContents.replace("$$QUOTEAUTHOR$$",str(quoteAuthor))
		thumbnailFileName=os.sep.join(os.path.normpath(EntryOne[1]).split(os.sep)[-1:])#grab only the thumbnailfilename, 
		
		mediaFileType=EntryOne[5]#filetype will be the last entry. 
		indexContents=indexContents.replace("$$TITLEONE$$",EntryOne[2])
		indexContents=indexContents.replace("$$TEXTONE$$",EntryOne[4])#this is the caption #loadtext[:50]+"..."
		indexContents=indexContents.replace("$$THUMBNAILONE$$",str(mediaFileType)+"/"+thumbnailFileName);
		indexContents=indexContents.replace("$$LINKONE$$",str(mediaFileType)+"/"+EntryOne[2]+".html");
		print("IndexPageentry Two",EntryTwoData) 
		thumbnailFileName=os.sep.join(os.path.normpath(EntryTwo[1]).split(os.sep)[-1:])#grab only the thumbnailfilename, 
		mediaFileType=EntryTwo[5]#filetype will be the last entry. 
		indexContents=indexContents.replace("$$TITLETWO$$",EntryTwo[2])
		indexContents=indexContents.replace("$$TEXTTWO$$",EntryTwo[4])#this is the caption #loadtext[:50]+"..."
		indexContents=indexContents.replace("$$THUMBNAILTWO$$",str(mediaFileType)+"/"+thumbnailFileName);
		indexContents=indexContents.replace("$$LINKTWO$$",str(mediaFileType)+"/"+EntryTwo[2]+".html");
		print("IndexPageentry Three",EntryThreeData) 
		thumbnailFileName=os.sep.join(os.path.normpath(EntryThree[1]).split(os.sep)[-1:])#grab only the thumbnailfilename, 
		mediaFileType=EntryThree[5]#filetype will be the last entry. 
		indexContents=indexContents.replace("$$TITLETHREE$$",EntryThree[2])
		indexContents=indexContents.replace("$$TEXTTHREE$$",EntryThree[4])#this is the caption #loadtext[:50]+"..."
		indexContents=indexContents.replace("$$THUMBNAILTHREE$$",str(mediaFileType)+"/"+thumbnailFileName);
		indexContents=indexContents.replace("$$LINKTHREE$$",str(mediaFileType)+"/"+EntryThree[2]+".html");
		print("saving the index page")
		indexFile=open(issueFolder+"/FrontPage.html","w")#open it again, but now with write intentions.
		indexFile.write(indexContents)
		indexFile.close();
		print("index page complete")
		
	def addArchive(self, issueNumber,directoryLocation): #This is currently weak to an instance where there isnt a archive file already made. 
		print("opening Archive Page at "+str(directoryLocation)+"/Archives.html")
		archiveFile=open(str(directoryLocation)+"/Archives.html")
		archiveContents=archiveFile.read();
		print("recorded data, closing.")
		archiveFile.close();
		archiveEntryTemplate="<A href='Issue$$ISSUENUMBER$$/FrontPage.html'>Issue: #$$ISSUENUMBER$$</A><BR><B>Published:</B>$$DATE$$<BR>"
		newEntry=archiveEntryTemplate#save a copy for... reasons i guess?
		newEntry=newEntry.replace("$$ISSUENUMBER$$",str(issueNumber))
		newEntry=newEntry.replace("$$DATE$$",date.today().isoformat())
		
		archiveContents=archiveContents.replace("<!--$$APPENDINGPOINT$$-->",newEntry+"<br>\n<!--$$APPENDINGPOINT$$-->")
		print("saving the Archive page")
		archiveFile=open(str(directoryLocation)+"/Archives.html","w")#open it again, but now with write intentions.
		archiveFile.write(archiveContents)
		archiveFile.close();
		print("Archives Updated!")
		
	def SubmitFinalData(self,listOfComics,listOfArticles,listOfContinuedSeries,listOfNewSeries,listOfShortStories,listOfPoetry,listOfFanArt,issueNumber, DirectoryLocation):
		global comicData;
		global articleData;
		global continuedSeriesData;
		global newSeriesData;
		global shortStoriesData;
		global poetryData;
		global fanArtData;
 
		comicData=eval(listOfComics);
		articleData=eval(listOfArticles);
		continuedSeriesData=eval(listOfContinuedSeries);
		newSeriesData=eval(listOfNewSeries);
		shortStoriesData=eval(listOfShortStories);
		poetryData=eval(listOfPoetry);
		fanArtData=eval(listOfFanArt);
		print("Recieved the following data: \n",comicData,"\n",articleData,"\n",continuedSeriesData,"\n",newSeriesData,"\n",shortStoriesData,"\n",poetryData,"\n",fanArtData,"\n issue number: ",issueNumber, DirectoryLocation)
	
	def addFanArt(self, issueNumber, DirectoryLocation):
		fanartTemplate='<br> <table class="art"><tr><td align="Center"><img src="$$SUMBMISSIONIMAGE$$" title="$$ALTTEXT$$"></img></td></tr><tr><td align="Center"><b>$$TITLE$$</b> by <b><a href="$$SOCIALLINKS$$">$$USERNAME$$</a></b></td></tr><tr><td align="right" class="tagstext"><b>Tags:</b>$$TAGS$$</td></tr></table>'
		print("opening fanart Page at "+str(directoryLocation)+"/FanArt.html")
		fanartFile=open(str(directoryLocation)+"/FanArt.html")
		fanartContents=fanartFile.read();
		print("recorded data, closing.")
		fanartFile.close();
		newEntry=fanartTemplate#save a copy for... reasons i guess?
		newEntry=newEntry.replace("$$ISSUENUMBER$$",str(issueNumber))
		newEntry=newEntry.replace("$$DATE$$",date.today().isoformat())
		
		fanartContents=fanartContents.replace("<!--$$APPENDINGPOINT$$-->",newEntry+"<br>\n<!--$$APPENDINGPOINT$$-->")
		print("saving the FanArt page",fanartContents)
		fanartFile=open(str(directoryLocation)+"/FanArt.html","w")#open it again, but now with write intentions.
		fanartFile.write(fanartContents)
		archiveFile.close();
		fanartFile("Archives Updated!")
		
	def prepareAndSend(self,fileType,fileOfMedia,fileofThumbnail,title,authors,caption,alttext,entryTags,authorLink):
		
		global CONTENTTEMPLATE
		global ISSUENUMBER
		global issueFolder;
		global articleFolder;
		global continuedSeriesFolder;
		global newSeriesFolder;
		global shortStoriesFolder;
		global poetryFolder;
		global toggleFlag;
		CONTENTTEMPLATE=open("IssueNULL/mediaTemplate.html").read()
		newMediaPage=""
		tableOfContentsFormat='<TR></Icon><TD align="top" bgcolor="#d8edff"><A href="$$MEDIATYPE$$/$$TITLE$$.html"><IMG border="0" src="$$ICON$$" width="150" height="150" class="story_img"></A></TD></text><TD align="top" bgcolor="#d8edff"><A href="$$MEDIATYPE$$/$$TITLE$$.html"><B>$$TITLE$$</B></A></P>$$CAPTION$$<BR><BR>by <b>$$AUTHOR$$</b><BR><BR><b>Tags: </b>$$TAGS$$</TD></TR>'

	 #check to make sure my filesystem isnt written anywhere, it should all be relative.
	#create index
	#check utf encoding headers
	#Clear out links to users, and create toplevel About and Archive?
	#header links need ../ added to prefix. 
	
	
	
		if(fileType=="article"):
			print("Adding Article",newMediaPage,"data")
			newMediaPage=CONTENTTEMPLATE; #save a working copy of the generic Content.
			print("making a copy of ",fileofThumbnail," at ",articleFolder)
			shutil.copy(fileofThumbnail,articleFolder)
			print("Saved copy of files to appropriate location .")
			thumbnailFileName=Path(fileofThumbnail).name #save jsut the name
			print("saving thumbnail file:",thumbnailFileName)
			print("preparing article")
			articleText=open(fileOfMedia).read()#open the media
			#print("Loading the File"+articleText);
			articleText=articleText.replace("\n","\n<p>");
			newMediaPage=newMediaPage.replace("$$CONTENT$$",articleText)#write Content.
			newMediaPage=newMediaPage.replace("$$TITLE$$",title)
			if(authorLink==""):#If we dont have a link, do a simple swap
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors)
			else:#if we have a link, swap in the link code, and then add the information
				newMediaPage=newMediaPage.replace("$$AUTHORS$$","<a href='$$SOCIALLINKS$$' onclick=\"return confirm('You are now leaving the Neopian Post. We do NOT control the content outside, so please proceed at your own risk and responsibility. Would you like to continue?')\">$$AUTHORS$$</a>")
				newMediaPage=newMediaPage.replace("$$SOCIALLINKS$$",authorLink)
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors) 
			newMediaPage=newMediaPage.replace("$$TAGS$$",entryTags)
			newMediaPage=newMediaPage.replace("$$ISSUENUMBER$$",str(ISSUENUMBER))
			newMediaPage=newMediaPage.replace("$$PUBLISHDATE$$",date.today().isoformat())
			newMediaPage=newMediaPage.replace("$$ICON$$",thumbnailFileName) #make sure this is still accurate. 
			
			print("writing to disk at "+articleFolder+"/"+title+".html")
			f = open(articleFolder+"/"+title+".html", "x") #open a file with the name and location, and X means to make it if it doesnt exist. 
			f.write(newMediaPage)
			f.close();
			
			ARTICLETEMPLATEDATA=""#declare this variable
			print("adding to Table of Contents.")
			print("building table entry.")
			#now that the article page is made, find the article table of contents page, and append the new article to it. 
			#load in the bespoke HTML that the submissions follow for the table of contents, and swap in the new good data.
			newSubmission=tableOfContentsFormat;#load in the template
			print("table entry:",newSubmission)
			newSubmission=newSubmission.replace("$$MEDIATYPE$$","Articles")
			newSubmission=newSubmission.replace("$$TITLE$$",title)
			newSubmission=newSubmission.replace("$$ICON$$","Articles/"+thumbnailFileName)
			newSubmission=newSubmission.replace("$$CAPTION$$",caption)
			newSubmission=newSubmission.replace("$$AUTHOR$$",authors)
			newSubmission=newSubmission.replace("$$TAGS$$",entryTags)
			print("checking background color flag")
			toggleFlag=not toggleFlag;#flip this every time
			print("is this block going to be blue?", str(toggleFlag))
			if(not toggleFlag):#if its true
				newSubmission=newSubmission.replace("#d8edff","#fbfbfb");
			print("table entry built:",newSubmission, "opening Table of contents to write to it at ",issueFolder+"/Articles.html")
			f2=open(issueFolder+"/Articles.html")
			print("Opened Articles.html ")
			ARTICLETEMPLATEDATA=f2.read();
			f2.close;
			print("read the text data")
			ARTICLETEMPLATEDATA=ARTICLETEMPLATEDATA.replace("<!--APPENDINGPOINT--!>",newSubmission+"<!--APPENDINGPOINT--!>")
			ARTICLETEMPLATEDATA=ARTICLETEMPLATEDATA.replace("$$ISSUENUMBER$$",ISSUENUMBER)#This will only proc on the first entry.
			ARTICLETEMPLATEDATA=ARTICLETEMPLATEDATA.replace("$$PUBLISHDATE$$",date.today().isoformat())#after they are replaced, it will not be there anymore.
			print("Article Table Of Contents built...  Now saving...");
			f2=open(issueFolder+"/Articles.html","w")
			f2.write(ARTICLETEMPLATEDATA)
			f2.close();
			print("wrote file at",issueFolder+"/Articles.html")
		if(fileType=="shortStory"):
			print("Adding shortStory",newMediaPage,"data")
			newMediaPage=CONTENTTEMPLATE; #save a working copy of the generic Content.
			print("making a copy of ",fileofThumbnail," at ",shortStoriesFolder)
			shutil.copy(fileofThumbnail,shortStoriesFolder)
			print("Saved copy of files to appropriate location .")
			thumbnailFileName=Path(fileofThumbnail).name #save jsut the name
			print("saving thumbnail file:",thumbnailFileName)
			print("preparing shortStory")
			shortStoryText=open(fileOfMedia).read()#open the media
			shortStoryText=shortStoryText.replace("\n","\n<p>");
			newMediaPage=newMediaPage.replace("$$CONTENT$$",shortStoryText)#write Content.
			newMediaPage=newMediaPage.replace("$$TITLE$$",title)
			if(authorLink==""):#If we dont have a link, do a simple swap
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors)
			else:#if we have a link, swap in the link code, and then add the information
				newMediaPage=newMediaPage.replace("$$AUTHORS$$","<a href='$$SOCIALLINKS$$' onclick=\"return confirm('You are now leaving the Neopian Post. We do NOT control the content outside, so please proceed at your own risk and responsibility. Would you like to continue?')\">$$AUTHORS$$</a>")
				newMediaPage=newMediaPage.replace("$$SOCIALLINKS$$",authorLink)
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors) 
			newMediaPage=newMediaPage.replace("$$TAGS$$",entryTags)
			newMediaPage=newMediaPage.replace("$$ISSUENUMBER$$",str(ISSUENUMBER))
			newMediaPage=newMediaPage.replace("$$PUBLISHDATE$$",date.today().isoformat())
			newMediaPage=newMediaPage.replace("$$ICON$$",thumbnailFileName) #make sure this is still accurate. 
			print("writing to disk at "+shortStoriesFolder+"/"+title+".html")
			f = open(shortStoriesFolder+"/"+title+".html", "x") #open a file with the name and location, and X means to make it if it doesnt exist. 
			f.write(newMediaPage)
			f.close();
			
			SHORTSTORYTEMPLATEDATA=""#declare this variable
			print("adding to Table of Contents.")
			print("building table entry.")
			#now that the article page is made, find the article table of contents page, and append the new article to it. 
			#load in the bespoke HTML that the submissions follow for the table of contents, and swap in the new good data.
			newSubmission=tableOfContentsFormat;#load in the template
			print("table entry:",newSubmission)
			newSubmission=newSubmission.replace("$$MEDIATYPE$$","ShortStories")
			newSubmission=newSubmission.replace("$$TITLE$$",title)
			newSubmission=newSubmission.replace("$$ICON$$","ShortStories/"+thumbnailFileName)
			newSubmission=newSubmission.replace("$$CAPTION$$",caption)
			newSubmission=newSubmission.replace("$$AUTHOR$$",authors)
			newSubmission=newSubmission.replace("$$TAGS$$",entryTags)
			print("checking background color flag")
			toggleFlag=not toggleFlag;#flip this every time
			print("is this block going to be blue?", str(toggleFlag))
			if(not toggleFlag):#if its true
				newSubmission=newSubmission.replace("#d8edff","#fbfbfb");
			print("table entry built:",newSubmission, "opening Table of contents to write to it at ",issueFolder+"/ShortStories.html")
			f2=open(issueFolder+"/ShortStories.html")
			print("Opened ShortStories.html ")
			SHORTSTORYTEMPLATEDATA=f2.read();
			f2.close;
			print("read the text data")
			SHORTSTORYTEMPLATEDATA=SHORTSTORYTEMPLATEDATA.replace("<!--APPENDINGPOINT--!>",newSubmission+"<!--APPENDINGPOINT--!>")
			SHORTSTORYTEMPLATEDATA=SHORTSTORYTEMPLATEDATA.replace("$$ISSUENUMBER$$",ISSUENUMBER)#This will only proc on the first entry.
			SHORTSTORYTEMPLATEDATA=SHORTSTORYTEMPLATEDATA.replace("$$PUBLISHDATE$$",date.today().isoformat())#after they are replaced, it will not be there anymore.
			print("ShortStories Table Of Contents built...  Now saving...");
			f2=open(issueFolder+"/ShortStories.html","w")
			f2.write(SHORTSTORYTEMPLATEDATA)
			f2.close();
			print("wrote file at",issueFolder+"/ShortStories.html")
		if(fileType=="continuedSeries"):
			print("Adding continuedSeries",newMediaPage,"data")
			newMediaPage=CONTENTTEMPLATE; #save a working copy of the generic Content.
			print("making a copy of ",fileofThumbnail," at ",continuedSeriesFolder)
			shutil.copy(fileofThumbnail,continuedSeriesFolder)
			print("Saved copy of files to appropriate location .")
			thumbnailFileName=Path(fileofThumbnail).name #save jsut the name
			print("saving thumbnail file:",thumbnailFileName)
			print("preparing continuedSeries")
			continuedSeriesText=open(fileOfMedia).read()#open the media
			continuedSeriesText=continuedSeriesText.replace("\n","\n<p>");
			newMediaPage=newMediaPage.replace("$$CONTENT$$",continuedSeriesText)#write Content.
			newMediaPage=newMediaPage.replace("$$TITLE$$",title)
			if(authorLink==""):#If we dont have a link, do a simple swap
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors)
			else:#if we have a link, swap in the link code, and then add the information
				newMediaPage=newMediaPage.replace("$$AUTHORS$$","<a href='$$SOCIALLINKS$$' onclick=\"return confirm('You are now leaving the Neopian Post. We do NOT control the content outside, so please proceed at your own risk and responsibility. Would you like to continue?')\">$$AUTHORS$$</a>")
				newMediaPage=newMediaPage.replace("$$SOCIALLINKS$$",authorLink)
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors) 
			newMediaPage=newMediaPage.replace("$$TAGS$$",entryTags)
			newMediaPage=newMediaPage.replace("$$ISSUENUMBER$$",str(ISSUENUMBER))
			newMediaPage=newMediaPage.replace("$$PUBLISHDATE$$",date.today().isoformat())
			newMediaPage=newMediaPage.replace("$$ICON$$",thumbnailFileName) #make sure this is still accurate. 
			print("writing to disk at "+continuedSeriesFolder+"/"+title+".html")
			f = open(continuedSeriesFolder+"/"+title+".html", "x") #open a file with the name and location, and X means to make it if it doesnt exist. 
			f.write(newMediaPage)
			f.close();
			
			CONTINUEDSERIESTEMPLATEDATA=""#declare this variable
			print("adding to Table of Contents.")
			print("building table entry.")
			#now that the article page is made, find the article table of contents page, and append the new article to it. 
			#load in the bespoke HTML that the submissions follow for the table of contents, and swap in the new good data.
			newSubmission=tableOfContentsFormat;#load in the template
			print("table entry:",newSubmission)
			newSubmission=newSubmission.replace("$$MEDIATYPE$$","ContinuedSeries")
			newSubmission=newSubmission.replace("$$TITLE$$",title)
			newSubmission=newSubmission.replace("$$ICON$$","ContinuedSeries/"+thumbnailFileName)
			newSubmission=newSubmission.replace("$$CAPTION$$",caption)
			newSubmission=newSubmission.replace("$$AUTHOR$$",authors)
			newSubmission=newSubmission.replace("$$TAGS$$",entryTags)
			print("checking background color flag")
			toggleFlag=not toggleFlag;#flip this every time
			print("is this block going to be blue?", str(toggleFlag))
			if(not toggleFlag):#if its true
				newSubmission=newSubmission.replace("#d8edff","#fbfbfb");
			print("table entry built:",newSubmission, "opening Table of contents to write to it at ",issueFolder+"/ContinuedSeries.html")
			f2=open(issueFolder+"/ContinuedSeries.html")
			print("Opened ContinuedSeries.html ")
			CONTINUEDSERIESTEMPLATEDATA=f2.read();
			f2.close;
			print("read the text data")
			CONTINUEDSERIESTEMPLATEDATA=CONTINUEDSERIESTEMPLATEDATA.replace("<!--APPENDINGPOINT--!>",newSubmission+"<!--APPENDINGPOINT--!>")
			CONTINUEDSERIESTEMPLATEDATA=CONTINUEDSERIESTEMPLATEDATA.replace("$$ISSUENUMBER$$",ISSUENUMBER)#This will only proc on the first entry.
			CONTINUEDSERIESTEMPLATEDATA=CONTINUEDSERIESTEMPLATEDATA.replace("$$PUBLISHDATE$$",date.today().isoformat())#after they are replaced, it will not be there anymore.
			print("ContinuedSeries Table Of Contents built...  Now saving...");
			f2=open(issueFolder+"/ContinuedSeries.html","w")
			f2.write(CONTINUEDSERIESTEMPLATEDATA)
			f2.close();
			print("wrote file at",issueFolder+"/ContinuedSeries.html")
		if(fileType=="newSeries"):
			print("Adding newSeries",newMediaPage,"data")
			newMediaPage=CONTENTTEMPLATE; #save a working copy of the generic Content.
			print("making a copy of ",fileofThumbnail," at ",newSeriesFolder)
			shutil.copy(fileofThumbnail,newSeriesFolder)
			print("Saved copy of files to appropriate location .")
			thumbnailFileName=Path(fileofThumbnail).name #save jsut the name
			print("saving thumbnail file:",thumbnailFileName)
			print("preparing newSeries")
			newSeriesText=open(fileOfMedia).read()#open the media
			newSeriesText=newSeriesText.replace("\n","\n<p>");
			newMediaPage=newMediaPage.replace("$$CONTENT$$",newSeriesText)#write Content.
			newMediaPage=newMediaPage.replace("$$TITLE$$",title)
			if(authorLink==""):#If we dont have a link, do a simple swap
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors)
			else:#if we have a link, swap in the link code, and then add the information
				newMediaPage=newMediaPage.replace("$$AUTHORS$$","<a href='$$SOCIALLINKS$$' onclick=\"return confirm('You are now leaving the Neopian Post. We do NOT control the content outside, so please proceed at your own risk and responsibility. Would you like to continue?')\">$$AUTHORS$$</a>")
				newMediaPage=newMediaPage.replace("$$SOCIALLINKS$$",authorLink)
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors) 
			newMediaPage=newMediaPage.replace("$$TAGS$$",entryTags)
			newMediaPage=newMediaPage.replace("$$ISSUENUMBER$$",str(ISSUENUMBER))
			newMediaPage=newMediaPage.replace("$$PUBLISHDATE$$",date.today().isoformat())
			newMediaPage=newMediaPage.replace("$$ICON$$",thumbnailFileName) #make sure this is still accurate. 
			print("writing to disk at "+newSeriesFolder+"/"+title+".html")
			f = open(newSeriesFolder+"/"+title+".html", "x") #open a file with the name and location, and X means to make it if it doesnt exist. 
			f.write(newMediaPage)
			f.close();
			
			NEWSERIESTEMPLATEDATA=""#declare this variable
			print("adding to Table of Contents.")
			print("building table entry.")
			#now that the article page is made, find the article table of contents page, and append the new article to it. 
			#load in the bespoke HTML that the submissions follow for the table of contents, and swap in the new good data.
			newSubmission=tableOfContentsFormat;#load in the template
			print("table entry:",newSubmission)
			newSubmission=newSubmission.replace("$$MEDIATYPE$$","NewSeries")
			newSubmission=newSubmission.replace("$$TITLE$$",title)
			newSubmission=newSubmission.replace("$$ICON$$","NewSeries/"+thumbnailFileName)
			newSubmission=newSubmission.replace("$$CAPTION$$",caption)
			newSubmission=newSubmission.replace("$$AUTHOR$$",authors)
			newSubmission=newSubmission.replace("$$TAGS$$",entryTags)
			print("checking background color flag")
			toggleFlag=not toggleFlag;#flip this every time
			print("is this block going to be blue?", str(toggleFlag))
			if(not toggleFlag):#if its true
				newSubmission=newSubmission.replace("#d8edff","#fbfbfb");
			print("table entry built:",newSubmission, "opening Table of contents to write to it at ",issueFolder+"/NewSeries.html")
			f2=open(issueFolder+"/NewSeries.html")
			print("Opened NewSeries.html ")
			NEWSERIESTEMPLATEDATA=f2.read();
			f2.close;
			print("read the text data")
			NEWSERIESTEMPLATEDATA=NEWSERIESTEMPLATEDATA.replace("<!--APPENDINGPOINT--!>",newSubmission+"<!--APPENDINGPOINT--!>")
			NEWSERIESTEMPLATEDATA=NEWSERIESTEMPLATEDATA.replace("$$ISSUENUMBER$$",ISSUENUMBER)#This will only proc on the first entry.
			NEWSERIESTEMPLATEDATA=NEWSERIESTEMPLATEDATA.replace("$$PUBLISHDATE$$",date.today().isoformat())#after they are replaced, it will not be there anymore.
			print("NewSeries Table Of Contents built...  Now saving...");
			f2=open(issueFolder+"/NewSeries.html","w")
			f2.write(NEWSERIESTEMPLATEDATA)
			f2.close();
			print("wrote file at",issueFolder+"/NewSeries.html")	
			
			
			
			#mistake: creat a function that moves a copy of the issueNull table of contents pages to the issueFolder.
			#then when it stime to make the table of contents, load that file and appent, then rewrite to it. 
		if(fileType=="poetry"):
			print("Adding poetry",newMediaPage,"data")
			newMediaPage=CONTENTTEMPLATE; #save a working copy of the generic Content.
			print("making a copy of ",fileofThumbnail," at ",poetryFolder)
			shutil.copy(fileofThumbnail,poetryFolder)
			print("Saved copy of files to appropriate location .")
			thumbnailFileName=Path(fileofThumbnail).name #save jsut the name
			print("saving thumbnail file:",thumbnailFileName)
			print("preparing poetry")
			poetryText=open(fileOfMedia).read()#open the media
			poetryText=poetryText.replace("\n","\n<p>");
			newMediaPage=newMediaPage.replace("$$CONTENT$$",poetryText)#write Content.
			newMediaPage=newMediaPage.replace("$$TITLE$$",title)
			if(authorLink==""):#If we dont have a link, do a simple swap
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors)
			else:#if we have a link, swap in the link code, and then add the information
				newMediaPage=newMediaPage.replace("$$AUTHORS$$","<a href='$$SOCIALLINKS$$' onclick=\"return confirm('You are now leaving the Neopian Post. We do NOT control the content outside, so please proceed at your own risk and responsibility. Would you like to continue?')\">$$AUTHORS$$</a>")
				newMediaPage=newMediaPage.replace("$$SOCIALLINKS$$",authorLink)
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors) 
			newMediaPage=newMediaPage.replace("$$TAGS$$",entryTags)
			newMediaPage=newMediaPage.replace("$$ISSUENUMBER$$",str(ISSUENUMBER))
			newMediaPage=newMediaPage.replace("$$PUBLISHDATE$$",date.today().isoformat())
			newMediaPage=newMediaPage.replace("$$ICON$$",thumbnailFileName) #make sure this is still accurate. 
			print("writing to disk at "+poetryFolder+"/"+title+".html")
			f = open(poetryFolder+"/"+title+".html", "x") #open a file with the name and location, and X means to make it if it doesnt exist. 
			f.write(newMediaPage)
			f.close();
			
			POETRYTEMPLATEDATA=""#declare this variable
			print("adding to Table of Contents.")
			print("building table entry.")
			#now that the article page is made, find the article table of contents page, and append the new article to it. 
			#load in the bespoke HTML that the submissions follow for the table of contents, and swap in the new good data.
			newSubmission=tableOfContentsFormat;#load in the template
			print("table entry:",newSubmission)
			newSubmission=newSubmission.replace("$$MEDIATYPE$$","Poetry")
			newSubmission=newSubmission.replace("$$TITLE$$",title)
			newSubmission=newSubmission.replace("$$ICON$$","Poetry/"+thumbnailFileName)
			newSubmission=newSubmission.replace("$$CAPTION$$",caption)
			newSubmission=newSubmission.replace("$$AUTHOR$$",authors)
			newSubmission=newSubmission.replace("$$TAGS$$",entryTags)
			print("checking background color flag")
			toggleFlag=not toggleFlag;#flip this every time
			print("is this block going to be blue?", str(toggleFlag))
			if(not toggleFlag):#if its true
				newSubmission=newSubmission.replace("#d8edff","#fbfbfb");
			print("table entry built:",newSubmission, "opening Table of contents to write to it at ",issueFolder+"/Poetry.html")
			f2=open(issueFolder+"/Poetry.html")
			print("Opened Poetry.html ")
			POETRYTEMPLATEDATA=f2.read();
			f2.close;
			print("read the text data")
			POETRYTEMPLATEDATA=POETRYTEMPLATEDATA.replace("<!--APPENDINGPOINT--!>",newSubmission+"<!--APPENDINGPOINT--!>")
			POETRYTEMPLATEDATA=POETRYTEMPLATEDATA.replace("$$ISSUENUMBER$$",ISSUENUMBER)#This will only proc on the first entry.
			POETRYTEMPLATEDATA=POETRYTEMPLATEDATA.replace("$$PUBLISHDATE$$",date.today().isoformat())#after they are replaced, it will not be there anymore. Wasted cycles, but less development time.
			print("Poetry Table Of Contents built...  Now saving...");
			f2=open(issueFolder+"/Poetry.html","w")
			f2.write(POETRYTEMPLATEDATA)
			f2.close();
			print("wrote file at",issueFolder+"/Poetry.html")	
		
		if(fileType=="comic"):
			print("Adding Comic",newMediaPage,"data")
			newMediaPage=CONTENTTEMPLATE; #save a working copy of the generic Content.
			print("making a thumbnail of ",fileofThumbnail," at ",comicFolder)
			shutil.copy(fileofThumbnail,comicFolder)
			print("making a copy of comic file ",fileofThumbnail," at ",comicFolder)
			comicFile=shutil.copy(fileOfMedia,comicFolder)
			comicFile=os.sep.join(os.path.normpath(comicFile).split(os.sep)[-1:])#grab only the filename, and filename so its relative
			print("Saved copy of files to appropriate location.")
			thumbnailFileName=Path(fileofThumbnail).name #save jsut the name
			print("saving thumbnail file:",thumbnailFileName)
			print("preparing comic")
			print("the File"+comicFile+"... \n Now adding text to the template file.");
			newMediaPage=newMediaPage.replace("$$CONTENT$$","<img src='"+comicFile+"' title='"+alttext+"'></img>")#write Content.
			newMediaPage=newMediaPage.replace("$$TITLE$$",title)
			if(authorLink==""):#If we dont have a link, do a simple swap
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors)
			else:#if we have a link, swap in the link code, and then add the information
				newMediaPage=newMediaPage.replace("$$AUTHORS$$","<a href='$$SOCIALLINKS$$' onclick=\"return confirm('You are now leaving the Neopian Post. We do NOT control the content outside, so please proceed at your own risk and responsibility. Would you like to continue?')\">$$AUTHORS$$</a>")
				newMediaPage=newMediaPage.replace("$$SOCIALLINKS$$",authorLink)
				newMediaPage=newMediaPage.replace("$$AUTHORS$$",authors) 
			newMediaPage=newMediaPage.replace("$$TAGS$$",entryTags)
			newMediaPage=newMediaPage.replace("$$ISSUENUMBER$$",str(ISSUENUMBER))
			newMediaPage=newMediaPage.replace("$$PUBLISHDATE$$",date.today().isoformat())
			newMediaPage=newMediaPage.replace("$$ICON$$",thumbnailFileName) #make sure this is still accurate. 
			print("writing to disk at "+comicFolder+"/"+title+".html")
			f = open(comicFolder+"/"+title+".html", "x") #open a file with the name and location, and X means to make it if it doesnt exist. 
			f.write(newMediaPage)
			f.close();
			
			COMICTEMPLATEDATA=""#declare this variable
			print("adding to Table of Contents.")
			print("building table entry.")
			#now that the article page is made, find the article table of contents page, and append the new article to it. 
			#load in the bespoke HTML that the submissions follow for the table of contents, and swap in the new good data.
			newSubmission=tableOfContentsFormat;#load in the template
			print("table entry:",newSubmission)
			newSubmission=newSubmission.replace("$$MEDIATYPE$$","Comics")
			newSubmission=newSubmission.replace("$$TITLE$$",title)
			newSubmission=newSubmission.replace("$$ICON$$","Comics/"+thumbnailFileName)
			newSubmission=newSubmission.replace("$$CAPTION$$",caption)
			newSubmission=newSubmission.replace("$$AUTHOR$$",authors)
			newSubmission=newSubmission.replace("$$TAGS$$",entryTags)
			print("checking background color flag")
			toggleFlag=not toggleFlag;#flip this every time
			print("is this block going to be blue?", str(toggleFlag))
			if(not toggleFlag):#if its true
				newSubmission=newSubmission.replace("#d8edff","#fbfbfb");
			print("table entry built:",newSubmission, "opening Table of contents to write to it at ",issueFolder+"/Comics.html")
			f2=open(issueFolder+"/Comics.html")
			print("Opened Comics.html ")
			COMICTEMPLATEDATA=f2.read();
			f2.close;
			print("read the text data")
			COMICTEMPLATEDATA=COMICTEMPLATEDATA.replace("<!--APPENDINGPOINT--!>",newSubmission+"<!--APPENDINGPOINT--!>")
			COMICTEMPLATEDATA=COMICTEMPLATEDATA.replace("$$ISSUENUMBER$$",ISSUENUMBER)#This will only proc on the first entry.
			COMICTEMPLATEDATA=COMICTEMPLATEDATA.replace("$$PUBLISHDATE$$",date.today().isoformat())#after they are replaced, it will not be there anymore. Wasted cycles, but less development time. 
			print("Comics Table Of Contents built...  Now saving...");
			f2=open(issueFolder+"/Comics.html","w")
			f2.write(COMICTEMPLATEDATA)
			f2.close();
			print("wrote file at",issueFolder+"/Comics.html")	
	
		if(fileType=="fanart"):
				#fileType,fileOfMedia,fileofThumbnail,title,authors,caption,alttext,entryTags,authorLink
			if(authorLink==""):
				fanartTemplate="<br> <table class='art'><tr><td align='Center'><img src='$$SUMBMISSIONIMAGE$$' title='$$ALTTEXT$$'></img></td></tr><tr><td align='Center'><b>$$TITLE$$</b> by <b>$$USERNAME$$</b></td></tr><tr><td align='right' class='tagstext'><b>Tags:</b>$$TAGS$$</td></tr></table>"
			else:
				fanartTemplate="<br> <table class='art'><tr><td align='Center'><img src='$$SUMBMISSIONIMAGE$$' title='$$ALTTEXT$$'></img></td></tr><tr><td align='Center'><b>$$TITLE$$</b> by <b><a href='$$SOCIALLINKS$$' onclick=\"return confirm('You are now leaving the Neopian Post. We do NOT control the content outside, so please proceed at your own risk and responsibility. Would you like to continue?')\">$$USERNAME$$</a></b></td></tr><tr><td align='right' class='tagstext'><b>Tags:</b>$$TAGS$$</td></tr></table>"
			fanartFile=shutil.copy(fileOfMedia,fanArtFolder)
			fanartFile=os.sep.join(os.path.normpath(fanartFile).split(os.sep)[-1:])#grab only the filename, and filename so it can be referenced as relative in the filestructure
			print("Saved copy of files to appropriate location.")
						
			print("opening fanart Page at "+str(issueFolder)+"/FanArt.html")
			fanartPage=open(str(issueFolder)+"/FanArt.html")
			fanartContents=fanartPage.read();
			print("recorded data, closing.")
			fanartPage.close();
			newEntry=fanartTemplate#save a copy for... reasons i guess?
			newEntry=newEntry.replace("$$SUMBMISSIONIMAGE$$","FanArt/"+str(fanartFile))#use our relative name
			newEntry=newEntry.replace("$$ALTTEXT$$",str(alttext))
			newEntry=newEntry.replace("$$TITLE$$",str(title))
			newEntry=newEntry.replace("$$SOCIALLINKS$$",str(authorLink))
			newEntry=newEntry.replace("$$USERNAME$$",str(authors))
			newEntry=newEntry.replace("$$TAGS$$",str(entryTags))
			
			fanartContents=fanartContents.replace("<!--APENDINGPOINT-->",newEntry+"<br>\n<!--APENDINGPOINT-->")
			fanartContents=fanartContents.replace("$$ISSUENUMBER$$",ISSUENUMBER)#This will only proc on the first entry.
			fanartContents=fanartContents.replace("$$PUBLISHDATE$$",date.today().isoformat())#after they are replaced, it will not be there anymore. Wasted cycles, but less development time. 
			
			print("saving a FanArt page update ")
			fanartPage=open(str(issueFolder)+"/FanArt.html","w")#open it again, but now with write intentions.
			fanartPage.write(fanartContents)
			fanartPage.close();
			print("FanArt Updated!")
		
			
	def _ready(self) -> None:
		print("Welcome to the Neopian Post Builder")
		# put initialization code here 
		#print(comicTemplate)
 
	def _process(self, delta:float) -> None:
		pass
		# put dynamic code here

	# Hide the method in the godot editor
	@private
	def test_method(self):
		print("thing happened")
		pass
# take a user ganerated list of submission kinds, metadata, and issue number.
#create a space to store the data
#Build an .html page for each submission
#save relevant images to the submission subfolder.
#create an index page for each medium, listing all the submissions for that issue.
#Create a homepage that has template spots for the editor to point people to
