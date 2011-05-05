component accessors='true' hint='i am the EventService' output='false'
{
	property name='GenericDAO' type='any' displayname='GenericDAO';
	property name='Utils' type='any' displayname='Utils';
	property name='UserService' type='any' displayname='UserService';
	property name='SlideshowService' type='any' displayname='SlideshowService';
	property name='EmailService' type='any' displayname='EmailService';
	property name='FileService' type='any' displayname='FileService';
	property name='AppConfig' type='any' displayname='AppConfig';
	
	public  function init(){
		return this;
	}
	
	public function isEventOwner(id){
		var c = readEvent(id);
		var isOwner = false;
		var cuID = getUserService().getCurrentUserID();
		var u = getUserService().readUser(cuID);
		var e = [];
		
		if(cuID != 0){
			e = listEventMemberships('user = ? and event = ? and isOwner=?', [u, g, 1]);
		}
		
		if(arrayLen(e) && e[1].getIsOwner()){
			isOwner = true;
		}
		return isOwner;
	}	
	
	public function isEventMember(id){
		var c = readEvent(id);
		var isMember = false;
		var cuID = getUserService().getCurrentUserID();
		var u = getUserService().readUser(cuID);
		var e = [];
		
		if(cuID != 0){
			e = listEventMemberships('user = ? and event = ?', [u, g]);
		}
		
		if(arrayLen(e) && e[1].getIsApproved()){
			isMember = true;
		}
		return isMember;
	}
	
	public function checkEventOwner(id){
		if(!isEventOwner(arguments.id)){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public function checkEventMember(id){
		if(!isEventMember(arguments.id)){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public function saveNewEvent(data,createdByID){
		var c = readEvent(0);		
		c.populate(arguments.data);
		saveEvent(c);
		
		var cm = readEventMembership(0);
		cm.setUser(getUserService().readUser(createdByID));
		cm.setEvent(c);
		cm.setIsApproved(1);
		cm.setIsOwner(1);
		
		c.addEventMembership(cm);
		
		saveEventMembership(cm);
		return c.getID();
	}
	
	public function saveEventInfo(id,data){
		var gID = isNull(arguments.id) ? 0 : arguments.id;
		var c = readEvent(gID);		
		c.populate(data);
		saveEvent(c);
		return c.getID();
	}
	
	public function saveEvent(target,noFlush){
		var exists = len(target.getCreatedOn()) ? 1 : 0;
		if(!exists){
			var alias = getUtils().makeAlias(target.getName());
			var tries = 0;
			while(arrayLen(listEvents('alias=?',[alias])) > 0 && tries < 100){
				tries++;
				alias = getUtils().makeAlias(target.getName()) & '-' & getUtils().getRandString(6);
				if(tries == 99) alias = getUtils().getStrippedUUID();
			}
			target.setAlias(alias);
		}
		return getGenericDAO().save(argumentCollection=arguments);
	}
	
	public function readEvent(id){
		return getGenericDAO().read('Event', arguments.id);
	}
	
	public function deleteEvent(instance,noFlush){
		var ev = arguments.instance;
		var rel = ev.getEventSlideshowRelationships();
		
		while(ev.hasEventSlideshowRelationship()){
			var r = ev.getEventSlideshowRelationships()[1];
			var ss = r.getSlideshow();
			r.setEvent(javacast('null', ''));
			r.setSlideshow(javacast('null', ''));
			ss.removeEventSlideshowRelationship(r);
			ev.removeEventSlideshowRelationship(r);
			getSlideshowService().saveSlideshow(ss);
			deleteEventRelationship(r);
			saveEvent(ev);
		}

		while(ev.hasEventMembership()){
			var m = ev.getEventMemberships()[1];
			m.setEvent(javacast('null', ''));
			m.getUser().removeEventMembership(m);
			ev.removeEventMembership(m);
			getUserService().saveUser(m.getUser());
			deleteEventMembership(m);
			saveEvent(ev);
		}
		
		return getGenericDAO().delete(ev, structKeyExists(arguments, 'noFlush') ? arguments.noFlush : false);
	}
	
	public function deleteEventByID(id,noFlush){
		var args = {};
		args.name = 'Event';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		return getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function countEvents(String whereClause, Any params){
		var args = {};
		args.entity = 'Event';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		return getGenericDAO().count(argumentCollection=args);
	}
	
	public function listEvents(String whereClause, Array params){
		return getGenericDAO().list('Event', arguments.whereClause, arguments.params);
	}
	
	public function listEventsByUserID(userID){
		var user = getUserService().readUser(userID);
		var events = [];
		var event = {};
		
		for(var cm in user.getEventMemberships()){
			var c = cm.getEvent();
			event = {};
			event['__type__'] = 'com.slidesix.vo.events.Event';
			event.id = c.getID();
			event.name = c.getName();
			event.organizerInfo = c.getOrganizerInfo();
			event.descriptionShort = c.getDescriptionShort();
			event.descriptionFull = c.getDescriptionFull();
			event.tracks = c.getTracks();
			event.costInfo = c.getCostInfo();
			event.startDate = c.getStartDate();
			event.endDate = c.getEndDate();
			event.venue = c.getVenue();
			event.externalHomepageURL = c.getExternalHomepageURL();
			event.rssURL = c.getRssURL();
			event.scheduleURL = c.getScheduleURL();
			event.contactURL = c.getContactURL();
			event.isOwner = cm.getIsOwner();
			event.isApproved = cm.getIsApproved();	
			event.joinedOn = cm.getCreatedOn();
			event.createdOn = c.getCreatedOn();
			event.alias = c.getAlias();
			event.pathToBannerImage = !isNull(c.getPathToBannerImage()) ? c.getPathToBannerImage() : '';
			event.pathToImage = !isNull(c.getPathToImage()) ? c.getPathToImage() : '';
			event.pathToImageThumb = !isNull(c.getPathToImageThumb()) ? c.getPathToImageThumb() : '';
			event.autoAcceptMembers = c.getAutoAcceptMembers();
			event.pendingMembers = javacast('int', val(c.getPendingMembers()));
			event.isFeatured = c.getIsFeatured();
			arrayAppend(events, event);
		}
		return events;
	}
	
	public string function saveEventBannerImage(id, eventImgUpload, generateThumb=false, width=700, height=''){
		//isEventOwner(arguments.id);
		var event = readEvent(arguments.id);
		var eventImgRoot = '/eventFiles/' & event.getID() & '/';
		var storeRoot = getAppConfig().getConfigSetting('storageRootDir');
		var eventImgDir = storeRoot & eventImgRoot;
		
		if(!directoryExists(eventImgDir)){
			getFileService().createDir(eventImgDir);
		} 
		
		var fName = getUtils().getStrippedUUID();
		var eventImgPath = eventImgRoot & fName & '.jpg';
		
		var uploaded = getFileService().storeImage('eventImgUpload', storeRoot, eventImgPath, arguments.generateThumb ? eventThumbPath : javacast('null', ''), arguments.width, arguments.height);
		
		var existingImg = storeRoot & event.getPathToBannerImage();
		if(fileExists(existingImg)){
			getFileService().delete(existingImg);
		}
		var d = structNew();
		d.pathToBannerImage = eventImgPath;
		saveEventInfo(event.getID(), d);
		return eventImgPath;
	}
	
	public string function saveEventImage(id,eventImgUpload, generateThumb=true, width=150, height=150){
		//isEventOwner(arguments.id);
		var event = readEvent(arguments.id);
		var eventImgRoot = '/eventFiles/' & event.getID() & '/';
		var storeRoot = getAppConfig().getConfigSetting('storageRootDir');
		var eventImgDir = storeRoot & eventImgRoot;
		
		if(!directoryExists(eventImgDir)){
			getFileService().createDir(eventImgDir);
		} 
		
		var fName = getUtils().getStrippedUUID();
		var eventImgPath = eventImgRoot & fName & '.jpg';
		var eventThumbPath = eventImgRoot & fName & '_thumb.jpg';
		
		var uploaded = getFileService().storeImage('eventImgUpload', storeRoot, eventImgPath, arguments.generateThumb ? eventThumbPath : javacast('null', ''), arguments.width, arguments.height);
		
		var existingImg = storeRoot & event.getPathToImage();
		if(fileExists(existingImg)){
			getFileService().delete(existingImg);
		}
		var existingThumb = storeRoot & event.getPathToImageThumb();
		if(fileExists(existingThumb)){
			getFileService().delete(existingThumb);
		}
		var d = structNew();
		d.pathToImage = eventImgPath;
		d.pathToImageThumb = eventThumbPath;
		saveEventInfo(event.getID(), d);
		return eventImgPath;
	}
	
	public function savePendingMemberships(Array memberships, eventID){
		//expects an array of structs with the following prototype:
		//[{eventMembershipID,isApproved}]
		for(var cm in memberships){
			var m = readEventMembership(cm.eventMembershipID);
			var c = readEvent(m.getEvent().getID());
			var u = getUserService().readUser(m.getUser().getID());
			
			if(cm.isApproved){
				m.setIsApproved(1);
			}
			else{
				u.removeEventMembership(m);
				g.removeEventMembership(m);
				deleteEventMembershipByID(m.getID());
			}
		}
	}
	
	public function saveEventMembershipInfo(id,data,eventID,userID){
		var cmID = isNull(arguments.id) ? 0 : arguments.id;
		var cm = readEventMembership(cmID);		
		var u = getUserService().readUser(arguments.userID);
		var c = readEvent(eventID);
		cm.populate(data);
		cm.setEvent(g);
		cm.setUser(u);
		g.addEventMembership(cm);
		u.addEventMembership(cm);
		saveEventMembership(cm);
		return cm.getID();
	}
	
	public function saveEventSlideshowRelationship(target,noFlush){
		getGenericDAO().save(argumentCollection=arguments);
	}
	public function saveEventMembership(target,noFlush){
		getGenericDAO().save(argumentCollection=arguments);
	}
	
	public function readEventSlideshowRelationship(id){
		return getGenericDAO().read('EventSlideshowRelationship', arguments.id);
	}
	
	public function readEventMembership(id){
		return getGenericDAO().read('EventMembership', arguments.id);
	}
	
	public function deleteEventMembership(instance,noFlush){
		getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteEventMembershipByID(id,noFlush){
		var args = {};
		args.name = 'EventMembership';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		return getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function deleteEventRelationship(instance,noFlush){
		getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteEventRelationshipByID(id,noFlush){
		var args = {};
		args.name = 'EvenRelationship';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		return getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function listEventMemberships(String whereClause, Array params){
		return getGenericDAO().list('EventMembership', arguments.whereClause, arguments.params);
	}
	
	public function listEventMembershipsByEventID(eventID,isApproved){
		var event = readEvent(eventID);
		var memberships = listEventMemberships('event = ? and isApproved = ?', [event, arguments.isApproved]);
		var members = [];
		var member = {};
		for(var cm in memberships){
			member = {};
			member['__type__'] = 'com.slidesix.vo.events.EventMembership';
			member.username = cm.getUser().getUsername();
			member.firstName = cm.getUser().getFirstName();
			member.lastName = cm.getUser().getLastName();
			member.joinedOn = cm.getCreatedOn();
			member.isApproved = cm.getIsApproved();
			member.isOwner = cm.getIsOwner();
			member.eventMembershipID = cm.getID();
			member.eventID = cm.getEvent().getID();
			member.userID = cm.getUser().getID();
			arrayAppend(members, member);
		}
		return members;
	}
	/**
    	*@hint 'Remember, the dynamic list functionality requires that the dynamic properties are case sensitive!!'
    	*/
	public function onMissingMethod(missingMethodName, missingMethodArguments){
		return getGenericDAO().onMissingMethod(arguments.missingMethodName, arguments.missingMethodArguments);
	}
}

