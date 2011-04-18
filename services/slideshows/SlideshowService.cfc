component accessors="true"  hint="i am the SlideShow Service" output="false"
{
	property name="GenericDAO" type="any" displayname="GenericDAO";
	property name="EmailService" type="any" displayname="EmailService";
	property name="AppConfig" type="any" displayname="AppConfig";
	property name="Utils" type="any" displayname="Utils";
	property name="OOConvert" type="any" displayname="OOConvert";
	property name="PDFConvert" type="any" displayname="PDFConvert";
	property name="UserService" type="any" displayname="UserService";
	property name="GroupService" type="any" displayname="GroupService";
	property name="SearchService" type="any" displayname="SearchService";
	property name="FileService" type="any" displayname="FileService";
	
	public function init(){
		return this;
	}
	
	public function isSlideshowOwner(id){
		var s = readSlideshow(id);
		var isOwner = false;
		var cuID = getUserService().getCurrentUserID();
		var user = getUserService().readUser(cuID);
		
		if(cuID != 0 && s.getCreatedBy().getID() == cuID){
			isOwner = true;
		}
		if(user.getIsAdmin()){
			isOwner = true;
		}
		return isOwner;
	}
	
	public function isSlideOwner(id){
		var s = readSlide(id);
		var isOwner = false;
		var cuID = getUserService().getCurrentUserID();
		var user = getUserService().readUser(cuID);
		
		if(cuID != 0 && s.getSlideshow().getCreatedBy().getID() == cuID){
			isOwner = true;
		}
		if(user.getIsAdmin()){
			isOwner = true;
		}
		return isOwner;
	}
	
	public function checkSlideshowOwner(id){
		if(!isSlideshowOwner(arguments.id)){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public function checkSlideOwner(id){
		if(!isSlideOwner(arguments.id)){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public String function uploadAttachment(fileField,slideshowID){
		var s = readSlideshow(arguments.slideshowID);
		var storeRoot = getAppConfig().getConfigSetting('storageRootDir');
		var attFolder = s.getSlideshowRootDir() & '/attachment';
		var uploadedFile = fileUpload(getAppConfig().getConfigSetting('physicalTempRoot'), arguments.fileField, '*', 'makeUnique');
		var validExtensions = getAppConfig().getConfigSetting('validAttachmentUploadExtensions');
		var fs = getFileService();
		
		if(uploadedFile.fileWasSaved && listFindNoCase(validExtensions, replace(uploadedFile.serverFileExt, '.', '', 'all'))){
			var serverFile = uploadedFile.serverDirectory & '/' & uploadedFile.serverFile;
			var attFile  = attFolder & '/' & s.getAlias() & '.' & uploadedFile.serverFileExt;
			fs.moveFile(serverFile, storeRoot & attFile);
			s.setPathToAttachment(attFile);
			saveSlideshow(s);
			return attFile;
		}
		fs.delete(uploadedFile.directory & '/' & uploadedFile.name);
		return '';
	}
	
	public boolean function deleteAttachment(slideshowID){
		var s = readSlideshow(arguments.slideshowID);
		var attFile = expandPath(s.getPathToAttachment());
		if(fileExists(attFile)){
			fileDelete(attFile);
			return true;
		}
		return false;
	}
	
	public String function uploadSlideshow(fileField){
		var uploadedFile = fileUpload(getAppConfig().getConfigSetting('physicalTempRoot'), arguments.fileField, '*', 'makeUnique');
		var validExtensions = getAppConfig().getConfigSetting('validPresentationUploadExtensions');
		if(uploadedFile.fileWasSaved && listFindNoCase(validExtensions, replace(uploadedFile.serverFileExt, '.', '', 'all'))){
			var serverFile = uploadedFile.serverDirectory & '/' & uploadedFile.serverFile;
			var cleanFileName = uploadedFile.serverDirectory & '/' & getUtils().getStrippedUUID() & '.' & uploadedFile.serverFileExt;
			fileMove(serverFile, cleanFileName);
			//rename pps to ppt
			if(uploadedFile.serverFileExt == 'pps'){
				var newCleanFileName = replace(cleanFileName, '.pps', '.ppt');
				fileMove(cleanFileName, newCleanFileName);
				cleanFileName = newCleanFileName;
			}
			return getFileFromPath(cleanFileName);
		}
		fileDelete(uploadedFile.directory & '/' & uploadedFile.name);
		return '';
	}
	
	public Array function convertSlideshow(String fileName){
		var filePath = getAppConfig().getConfigSetting('physicalTempRoot') & arguments.fileName;
		
		var ret = [];
		var convertService = '';
		
		if(fileExists(filePath)){
			var ext = listLast(getFileFromPath(filePath), '.');
			switch(ext){
				case 'ppt':
				case 'odp':
				case 'sxi':
					convertService = getOOConvert();
					break;
				case 'pdf':
					convertService = getPDFConvert();
					break;
						
			}
			ret = convertService.convert(filePath);
		}
		return ret;
	}
	
	public function saveSlideshowInfoAndConvert(fileName,id,data,createdByID,groupID)
		hint='i combine the saveSlideshowInfo and the convertSlideshow methods and convert the slideshow in a threaded manner'
	{
		var sID = isNull(arguments.id) ? 0 : arguments.id;
		var app = getAppConfig().getConfigSetting('appFriendlyName');
		var storeRoot = getAppConfig().getConfigSetting('storageRootDir');
		var gatewayName = getAppConfig().getConfigSetting('managementConsoleGatewayName');
		var tname = app & '_' & getUtils().getStrippedUUID() & '_saveSlideshowInfoAndConvert';
		var d = arguments.data;
		d.isConverting = true;
		var showNotes = structKeyExists(arguments.data, 'showNotes') ? arguments.data.showNotes : 1;
		
		var newID = saveSlideshowInfo(sID,arguments.data);
			
		thread name=tname args=arguments t=this slideshowID=newID fileService=getFileService() showNotes=showNotes gatewayName=gatewayName storeRoot=storeRoot{
			var args = attributes.args;
			var com = attributes.t;
			var fs = attributes.fileService;
			
			var slideArr = com.convertSlideShow(args.fileName);
			var ss = com.readSlideshow(attributes.slideshowID);
			var ssRoot = ss.getSlideshowRootDir();
			var ssRootFull = attributes.storeRoot & ssRoot;
			var thumbRoot = ssRoot & '/thumbs';
			var slideRoot = ssRoot & '/slides';
			
			var s = '';
			var c = 0;
			var cID = !isNull(args.createdByID) ? args.createdByID : '';
			var gID = !isNull(args.groupID) ? args.groupID : '';
			var newD = {};
			var id = '';
			
			var msg = {};
			msg["headers"]["DSSubtopic"] = cID & '-management_console_gateway';
			msg.destination = 'ColdFusionGateway'; 	
			msg.body = {};
			msg.body.type = 'ImportStatus';
			
			try{
				for(var ts in slideArr){
					c++;
					var d = {};
					d.title = ts.title;
					d.text = ts.text;
					d.notes = ts.notes;
					d.slideNumber = c;
					d.showNotes = attributes.showNotes;
					d.pathToSlide = slideRoot & '/' & c & '.jpg';
					fs.storeSlideImage(ts.img, attributes.storeRoot, d.pathToSlide);
					
					d.height = ts.img.height;
					d.width = ts.img.width;
					
					d.pathToSlideThumb = thumbRoot & '/' & c & '_thumb.jpg';
					imageResize(ts.img,150,'');
					fs.storeSlideImage(ts.img,attributes.storeRoot, d.pathToSlideThumb);
					
					d.slideshow = ss;
					com.saveNewSlide(javacast('null',''),d);
					if(c == 1){
						com.saveSlideshowInfo(ss.getID(),{pathToThumb=d.pathToSlideThumb});
					}
				}
			}
			catch(Any e){
				var isLogging = getAppConfig().getConfigSetting('logSlideshowImportErrors');
				var logFile = getAppConfig().getConfigSetting('slideshowImportErrorsLogName');		
				var detail = structKeyExists(e, 'detail') && len(e.detail) ? serializeJSON(e.detail) : 'no detail';
				savecontent variable='m'{
					writeOutput('An Error occurred importing slideshow ''#ss.getID()#''. Error message: #e.message#.  See exception log for further info regarding thread #thread.name#');
				}
				if(isLogging) writeLog(file=logFile, text=m);
				
				newD.isConverting = false;
				newD.hasErrors = true;
				newD.lastBuildDate = '';
				id = com.saveSlideshowInfo(ss.getID(),newD, cID, gID);
				msg.body.content = com.getSlideshowByID(id);
				sendGatewayMessage(attributes.gatewayName, msg);
				rethrow;
			}
			
			//the import is complete, update the status
			
			newD.hasErrors = false;
			newD.isConverting = false;
			newD.lastBuildDate = now();
			
			id = com.saveSlideshowInfo(ss.getID(),newD, cID, gID);
			
			//this is where we will notify the flex app
			//that the conversion is complete via 
			//sendGatewayMessage() and a FMS gateway
				
			msg.body.content = com.getSlideshowByID(id);	
			sendGatewayMessage(attributes.gatewayName, msg);
		}
		return newID;
	}
	
	public String function saveSlideshowInfo(id, data, createdByID, groupID){
		var sID = isNull(arguments.id) ? 0 : arguments.id;
		var s = readSlideshow(sID);		
		s.populate(data);
		
		if(structKeyExists(arguments, 'createdByID') && len(trim(arguments.createdByID)))  s.setCreatedBy(getUserService().readUser(arguments.createdByID));
		if(structKeyExists(arguments, 'groupID') && len(trim(arguments.groupID))){
			//removed  && getGroupService().isGroupMember(arguments.groupID)
			s.setGroup(getGroupService().readGroup(arguments.groupID));
		}
		else{
			s.setGroup(javacast('null', ''));
		}

		saveSlideshow(s);

		if(structKeyExists(data, 'tags') && listLen(data.tags, ',')){
			var eTags = s.getTagAssociations();
			if(!isNull(eTags) && arrayLen(eTags)){
				s.setTagAssociations([]);
				for(var et in eTags){
					et.setSlideshow(javacast('null', ''));
					et.getTag().removeTagAssociation(et);
					getGenericDAO().deleteByID("TagAssociation", et.getID());
				}
			} 
			var tArr = listToArray(data.tags);
			for(var t in tArr){
				var tag = getGenericDAO().list("Tag", 'tag=?', [t]);
				if(!isNull(tag) && arrayLen(tag)){
					tag = tag[1];
				}
				else{
					tag = getGenericDAO().read('Tag', 0);
					tag.setTag(t);
					getGenericDAO().save(tag);
				}
				var ta = getGenericDAO().read('TagAssociation', 0);
				ta.setTag(tag);
				ta.setSlideshow(s);
				getGenericDAO().save(ta);
				tag.addTagAssociation(ta);
				s.addTagAssociation(ta);
			}
		}
		saveSlideshow(s);
		return s.getID();
	}
	
	public function saveSlideshow(target,noFlush){
		var exists = len(target.getCreatedOn()) ? 1 : 0;
		var storeRoot = getAppConfig().getConfigSetting('storageRootDir');
		
		if(!exists){
			var alias = getUtils().makeAlias(target.getTitle());
			var tries = 0;
			while(arrayLen(listSlideshows('alias=?',[alias])) > 0 && tries < 100){
				tries++;
				alias = getUtils().makeAlias(target.getTitle()) & '-' & getUtils().getRandString(6);
				if(tries == 99) alias = getUtils().getStrippedUUID();
			}
			
			target.setAlias(alias);
			
			var presoRoot = getAppConfig().getConfigSetting('storageRootDir') & 'presentations/';
			var presoDirName = getUtils().getStrippedUUID();
			var presoDir = presoRoot & presoDirName;
			
			target.setSlideshowRootDir('/presentations/' & presoDirName);

			if(!directoryExists(presoDir)){
				getFileService().createDir(presoDir);
				getFileService().createDir(presoDir & '/thumbs');
				getFileService().createDir(presoDir & '/attachment');
				getFileService().createDir(presoDir & '/slides');
			}	 
		}
		getGenericDAO().save(argumentCollection=arguments);
		
		var s = {};
		s.action = isNull(target.getPassword()) && !isNull(target.getLastBuildDate()) ? 'update' : 'delete' ;
		s.key = target.getID();
		s.type = 'custom';
		s.title = target.getTitle();
		s.body = target.getTitle() & ' ' & target.getAbstract();
		var tags = target.getTagAssociations();
		
		if(!isNull(tags) && arrayLen(tags)){
			for(var t in tags){
				s.body &= ' ' & t.getTag().getTag();
			}
		}
		var slides = target.getSlides();
		if(!isNull(slides) && arrayLen(slides)){
			for(var slide in slides){
				s.body &= ' ' & slide.getText() & ' ' & slide.getTitle();
				if(slide.getShowNotes()) s.body &= ' ' & slide.getNotes();
			}
		}
		getSearchService().index(attCollection=s);	
	}
	
	public function readSlideshow(id){
		return getGenericDAO().read('Slideshow', arguments.id);
	}
	
	public function deleteSlideshow(instance,noFlush){
		var s = {};
		s.action = 'delete';
		s.key = instance.getID();
		s.type = 'custom';
		getSearchService().index(s);
		getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteSlideshowByID(id,noFlush){
		var args = {};
		args.name = 'Slideshow';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		
		var fs = getFileService();

		//remove from search index 
		var slideshow = readSlideshow(arguments.id);
		var s = {};
		
		var tname = getUtils().getStrippedUUID() & '_delete_presentation_media';
		
		
		s.action = 'delete';
		s.key = slideshow.getID();
		s.type = 'custom';
		
		getSearchService().index(attCollection=s);
		
		while(slideshow.hasSlide()){
			var slide = slideshow.getSlides()[1];
			slide.setSlideshow(javacast('null', ''));
			slideshow.removeSlide(slide);
		}
		while(slideshow.hasTagAssociation()){
			var ta = slideshow.getTagAssociations()[1];
			var tagID = ta.getTag().getID();
			
			slideshow.removeTagAssociation(ta);
			ta.setSlideshow(javacast('null', ''));
			
			var tagArr = ormExecuteQuery('select ta.tag.id from TagAssociation ta join ta.tag where ta.tag.id = ?', [tagID]);
			
			if(arrayLen(tagArr) eq 1){
				var tag = getGenericDAO().read('Tag', tagArr[1]);
				ta.setTag(javacast('null', ''));
				tag.removeTagAssociation(ta);
				getGenericDAO().delete(tag);
			}
			
		}
		
		while(slideshow.hasView()){
			var v = slideshow.getViews()[1];
			v.setSlideshow(javacast('null', ''));
			slideshow.removeView(v);
		}

		while(slideshow.hasRanking()){
			var r = slideshow.getRankings()[1];
			r.setSlideshow(javacast('null', ''));
			slideshow.removeRanking(r);
		}
		
		while(slideshow.hasComment()){
			var c = slideshow.getComments()[1];
			c.setSlideshow(javacast('null', ''));
			slideshow.removeComment(c);
		}
		while(slideshow.hasFavoritedBy()){
			var f = slideshow.getFavoritedBy()[1];
			f.setSlideshow(javacast('null', ''));
			slideshow.removeFavoritedBy(f);
		}
		
		var u = slideshow.getCreatedBy();
		u.removeSlideshow(slideshow);
		slideshow.removeCreatedBy();
		
		if(slideshow.hasGroup()){
			var g = slideshow.getGroup();
			g.removeSlideshow(slideshow);
			slideshow.setGroup(javacast('null', ''));
		}
		
			
		thread name=tname fs=fs slideshow=slideshow storeRoot=getAppConfig().getConfigSetting('storageRootDir') {
			attributes.fs.delete(attributes.storeRoot & slideshow.getSlideshowRootDir(), true);
			for(var s in attributes.slideshow.getSlides()){
				/*
				fs.delete(s.getSlideshow().getPathToThumb());
				fs.delete(s.getSlideshow().getPathToAttachment());
				fs.delete(s.getPathToSlide());
				fs.delete(s.getPathToSlideThumb());
				*/
				var sm = s.getPathToSlideMedia();
				if(fileExists(sm)){
					attributes.fs.delete(sm);
				}
			}
		}
		getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function countSlideshows(String whereClause, Any params){
		var args = {};
		args.entity = 'Slideshow';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		return getGenericDAO().count(argumentCollection=args);
	}
	
	public function listAllSlideshows(String whereClause, Any params, Struct options){
		var args = {};
		args.entity = 'Slideshow';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		if(structKeyExists(arguments, 'options')){
			 args.queryOptions = arguments.options;
		}
		return getGenericDAO().list(argumentCollection=args); 
	}
	
	public function listSlideshows(String whereClause, Any params, Struct options){
		var args = {};
		args.entity = 'Slideshow';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		if(structKeyExists(arguments, 'options')){
			 args.queryOptions = arguments.options;
		}
		var ss = getGenericDAO().list(argumentCollection=args); 
		
		var retArr = [];
		var cuID = getUserService().getCurrentUserID();
		for(var s in ss){
			if(len(s.getPassword()) && s.getCreatedBy().getID() == cuID){
				arrayAppend(retArr,s);
			}
			else if(!len(s.getPassword())){
				arrayAppend(retArr,s);
			}
		}
		return retArr;
	}

	public function listUserSlideshowsByUserIDAsQuery(userID){
		var user = getUserService().readUser(arguments.userID);
		return entityToQuery(listSlideshows('createdBy=?',[user]));
	}
	
	public function getSlideshowByID(slideshowID){
		var s = readSlideshow(isNull(arguments.slideshowID) ? 0 : arguments.slideshowID);
		var slideshow = {};
		if(s.getID() != 0){
			slideshow['__type__'] = 'com.slidesix.vo.slideshows.Slideshow';
			slideshow.abstract = s.getAbstract();
			slideshow.avgRank = s.getAvgRank();
			slideshow.countRank = s.getCountRank();
			slideshow.numViews = s.getNumViews(); 
			slideshow.numEmbeddedViews = s.getNumEmbeddedViews();
			slideshow.numFavorites = s.getNumFavorites();
			slideshow.numComments = s.getNumComments();
			slideshow.numSlides = s.getNumSlides();
			slideshow.alias = s.getAlias();
			slideshow.createdOn = s.getCreatedOn(); 
			slideshow.createdBy = s.getCreatedBy().getID(); 
			slideshow.createdByImg = s.getCreatedBy().getPathToImage(); 
			slideshow.createdByBio = s.getCreatedBy().getBio(); 
			slideshow.createdByFullName = s.getCreatedBy().getFirstName() & " " & s.getCreatedBy().getFirstName(); 
			slideshow.createdByUsername = s.getCreatedBy().getUsername(); 
			slideshow.createdByUserID = s.getCreatedBy().getID(); 
			slideshow.hasErrors = s.getHasErrors();
			slideshow.id = s.getID();
			slideshow.isConverting = s.getIsConverting();
			slideshow.isPublishing = s.getIsPublishing();
			slideshow.lastBuildDate = s.getLastBuildDate();
			slideshow.notifyComments = s.getNotifyComments(); 
			slideshow.allowComments = s.getAllowComments(); 
			slideshow.password = s.getPassword();
			slideshow.pathToAttachment = s.getPathToAttachment();
			slideshow.pathToThumb = s.getPathToThumb();
			slideshow.slideshowRootDir = s.getSlideshowRootDir();
			slideshow.title = s.getTitle();
			slideshow.updatedOn = s.getUpdatedOn();
			slideshow.groupName = isNull(s.getGroup()) ? '' : s.getGroup().getName();
			slideshow.groupID = isNull(s.getGroup()) ? '' : s.getGroup().getID();
			slideshow.tagList = s.getTagList();
		}
		return slideshow;
	}
	
	public function listSlideshowsByUserID(userID,orderBy){
		var order = isNull(arguments.orderBy) ? 'lastBuildDate desc' : arguments.orderBy;
		var user = getUserService().readUser(userID);
		var ret = [];
		var ts = {};
		var slideshows = listSlideshows('createdBy=? order by ' & order ,[user]);
		var cuID = getUserService().getCurrentUserID();
		
		for(var i=1; i<=arrayLen(slideshows); i++){
			ts = {};
			var slideshow = slideshows[i];
			ts['__type__'] = 'com.slidesix.vo.slideshows.Slideshow';
			ts.abstract = slideshow.getAbstract();
			ts.avgRank = javacast('int', val(slideshow.getAvgRank()));
			ts.countRank = javacast('int', val(slideshow.getCountRank()));
			ts.numViews = javacast('int', val(slideshow.getNumViews())); 
			ts.numEmbeddedViews = javacast('int', val(slideshow.getNumEmbeddedViews()));
			ts.numFavorites = javacast('int', val(slideshow.getNumFavorites()));
			ts.numComments = javacast('int', val(slideshow.getNumComments()));
			ts.numSlides = javacast('int', val(slideshow.getNumSlides()));
			ts.alias = slideshow.getAlias();
			ts.createdOn = slideshow.getCreatedOn(); 
			ts.createdBy = slideshow.getCreatedBy().getID(); 
			ts.createdByImg = slideshow.getCreatedBy().getPathToImage(); 
			ts.createdByBio = slideshow.getCreatedBy().getBio(); 
			ts.createdByFullName = slideshow.getCreatedBy().getFirstName() & " " & slideshow.getCreatedBy().getFirstName(); 
			ts.createdByUsername = slideshow.getCreatedBy().getUsername(); 
			ts.createdByUserID = slideshow.getCreatedBy().getID(); 
			ts.hasErrors = slideshow.getHasErrors();
			ts.id = slideshow.getID();
			ts.isConverting = slideshow.getIsConverting();
			ts.isPublishing = slideshow.getIsPublishing();
			ts.lastBuildDate = slideshow.getLastBuildDate();
			ts.notifyComments = slideshow.getNotifyComments(); 
			ts.allowComments = slideshow.getAllowComments(); 
			ts.password = slideshow.getPassword();
			ts.pathToAttachment = slideshow.getPathToAttachment();
			ts.pathToThumb = slideshow.getPathToThumb();
			ts.slideshowRootDir = slideshow.getSlideshowRootDir();
			ts.title = slideshow.getTitle();
			ts.updatedOn = slideshow.getUpdatedOn();
			ts.groupName = isNull(slideshow.getGroup()) ? '' : slideshow.getGroup().getName();
			ts.groupID = isNull(slideshow.getGroup()) ? '' : slideshow.getGroup().getID();
			ts.tagList = slideshow.getTagList();
			
			if(!isNull(ts.password) && (len(ts.password) && ts.createdBy == cuID)){
				arrayAppend(ret, ts);
			}
			else if(isNull(ts.password) || !isNull(ts.password) && !len(ts.password)){
				arrayAppend(ret, ts);
			}
		}
		return ret;
	}
	
	/*rankings*/
	
	public function saveNewRanking(id, data){
		id = isNull(id) ? 0 : id;
		var r = readRanking(id);		
		r.populate(data);
		saveRanking(r);
		return r.getID();
	}
	
	public function saveRanking(target,noFlush){
		getGenericDAO().save(argumentCollection=arguments);
	}
	
	public function readRanking(id){
		return getGenericDAO().read('Ranking', arguments.id);
	}
	
	public function deleteRanking(instance,noFlush){
		getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteRankingByID(id,noFlush){
		var args = {};
		args.name = 'Ranking';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function listRankings(String whereClause, Array params){
		var args = {};
		args.entity = 'Ranking';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		
		return getGenericDAO().list(argumentCollection=args);
	}
	
	/*comments*/
	
	public function saveNewComment(id, data){
		id = isNull(id) ? 0 : id;
		var c = readComment(id);		
		c.populate(data);
		saveComment(c);
		return c.getID();
	}
	
	public function saveComment(target,noFlush){
		getGenericDAO().save(argumentCollection=arguments);
	}
	
	public function readComment(id){
		return getGenericDAO().read('Comment', arguments.id);
	}
	
	public function deleteComment(instance,noFlush){
		getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteCommentByID(id,noFlush){
		var args = {};
		args.name = 'Comment';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function listComments(String whereClause, Array params){
		var args = {};
		args.entity = 'Comment';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		
		return getGenericDAO().list(argumentCollection=args);
	}
	
	public function listCommentsBySlideshowID(slideshowID){
		var s = readSlideshow(arguments.slideshowID);
		var ret = [];
		var c = {};
		var comments = s.getComments();
		
		for(var i=1; i<=arrayLen(comments); i++){
			c = {};
			var comment = comments[i];
			c['__type__'] = 'com.slidesix.vo.slideshows.Comment';
			c.id = comment.getID();
			c.name = comment.getName();
			c.email = comment.getEmail();
			c.url = comment.getURL();
			c.comment = comment.getComment();
			c.createdOn = comment.getCreatedOn();
			c.isSubscribed = comment.getIsSubscribed();
			arrayAppend(ret, c);
		}
		return ret;
	}
	
	
	/*views*/
	
	public function saveNewView(data,slideshowID){
		var s = readSlideshow(arguments.slideshowID);
		var v = readView(0);		
		v.populate(data);
		v.setSlideshow(s);
		saveView(v);
		return v.getID();
	}
	
	public function saveView(target,noFlush){
		getGenericDAO().save(argumentCollection=arguments);
	}
	
	public function readView(id){
		return getGenericDAO().read('View', arguments.id);
	}
	
	public function deleteView(instance,noFlush){
		getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteViewByID(id,noFlush){
		var args = {};
		args.name = 'View';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function listViews(String whereClause, Array params){
		var args = {};
		args.entity = 'View';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		
		return getGenericDAO().list(argumentCollection=args);
	}

	/*slides*/
	
	public function saveNewSlide(id, data){
		id = isNull(id) ? 0 : id;
		var s = readSlide(id);		
		s.populate(data);
		saveSlide(s);
		return s.getID();
	}
	public function saveSlideInfo(id,data){
		var sID = isNull(arguments.id) ? 0 : arguments.id;
		var s = readSlide(sID);		
		s.populate(data);
		saveSlide(s);
		return s.getID();
	}

	public function saveSlide(target,noFlush){
		getGenericDAO().save(argumentCollection=arguments);
	}
	
	public function readSlide(id){
		return getGenericDAO().read('Slide', arguments.id);
	}
	
	public function deleteSlideMediaBySlideID(id,noFlush){
		var slide = readSlide(arguments.id);
		
		if(len(trim(slide.getPathToSlideMedia()))){
			var mf = getAppConfig().getConfigSetting('pathToMediaServerRecordings') & '/' & slide.getPathToSlideMedia();
			var mfMeta = mf & '.meta'; //sometimes a meta file is hanging around
			getFileService().delete(mf);
			getFileService().delete(mfMeta);
			slide.setPathToSlideMedia(javacast('null', ''));
			saveSlide(slide);
		}
	}
	
	public function deleteSlide(instance,noFlush){
		getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteSlideByID(id,noFlush){
		var args = {};
		args.name = 'Slide';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function listSlides(String whereClause, Array params){
		var args = {};
		args.entity = 'Slide';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		
		var slides = getGenericDAO().list(argumentCollection=args);
		var retArr = [];
		var cuID = getUserService().getCurrentUserID();
		for(var s in slides){
			if(len(s.getSlideshow().getPassword()) && s.getCreatedBy().getID() == cuID){
				arrayAppend(retArr,s);
			}
			else if(!len(s.getSlideshow().getPassword())){
				arrayAppend(retArr,s);
			}
		}
		return retArr;
	}
	
	public function listSlidesBySlideshowID(slideshowID){
		var s = readSlideshow(arguments.slideshowID);
		var ret = [];
		var ts = {};
		var cuID = getUserService().getCurrentUserID();
		var slides = s.getSlides();
		
		if(arrayLen(slides)){
			for(var i=1; i<=arrayLen(slides); i++){
				ts = {};
				var slide = slides[i];
				ts['__type__'] = 'com.slidesix.vo.slideshows.Slide';
				ts.title = slide.getTitle();
				ts.notes = slide.getNotes();
				ts.pathToSlide = slide.getPathToSlide();
				ts.pathToSlideThumb = slide.getPathToSlideThumb();
				ts.showNotes = slide.getShowNotes();
				ts.pathToSlideMedia = slide.getPathToSlideMedia();
				ts.text = slide.getText();
				ts.hasNarration = slide.getHasNarration();
				ts.slideNumber = slide.getSlideNumber();
				ts.height = slide.getHeight();
				ts.width = slide.getWidth();
				ts.id = slide.getID();
				ts.createdOn = slide.getCreatedOn();
				ts.externalMediaID = slide.getExternalMediaID();
				ts.externalMediaSource = slide.getExternalMediaSource();
				ts.hasMedia = javacast('boolean', slide.getHasMedia());
				
				if(!isNull(slide.getSlideshow().getPassword()) && (len(slide.getSlideshow().getPassword()) && slide.getSlideshow().getCreatedBy().getID() == cuID)){
					arrayAppend(ret, ts);
				}
				else if(isNull(slide.getSlideshow().getPassword()) || !isNull(slide.getSlideshow().getPassword()) && !len(slide.getSlideshow().getPassword())){
					arrayAppend(ret, ts);
				}
			}
		}
		return ret;
	}
	
	/**
	*@hint 'Remember, the dynamic list functionality requires that the dynamic properties are case sensitive!!'
	*/
	public function onMissingMethod(missingMethodName, missingMethodArguments){
		return getGenericDAO().onMissingMethod(arguments.missingMethodName, arguments.missingMethodArguments);
	}
}
	
	
	


	


