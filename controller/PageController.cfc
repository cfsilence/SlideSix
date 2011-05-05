component  extends="ModelGlue.gesture.controller.Controller" hint="i am a model-glue controller" output="false"
	beans="UserService,AppConfig,SearchService,SlideshowService,Utils,GroupService,EventService,SlideSixImportService"
{
	public function onApplicationStart(event){
	}
	public function onSessionStart(event){
	}
	public function onSessionEnd(event){
	}
	public function init( framework)
	 hint="Constructor" output="false"{
		super.init(framework);
		return this;
	}
	
	public function onRequestStart(Any event){
		if(!reFindNoCase('user.loginPage|user.login|user.resetPassword|user.verify|user.sendVerifyEmail', cgi.query_string)){
			cookie.lastPage = cgi.script_name & '?' & cgi.query_string;	
		}
	}
    
	public function getHomePage(Any event){
		var whereClause = 'lastBuildDate is not null and password is null ORDER BY createdOn desc';
		arguments.event.setValue('recentSlideshows', beans.SlideshowService.listAllSlideshows(whereClause, [], {maxresults=8, offset=1}));
		arguments.event.setValue('countSlideshows', beans.Slideshowservice.countSlideshows(whereClause));
		arguments.event.setValue('recentUsers', beans.UserService.listUsers('1=1 ORDER BY createdOn desc', [], {maxresults=20, offset=1}));
		arguments.event.setValue('recentGroups', beans.GroupService.listGroups('1=1 ORDER BY createdOn desc', [], {maxresults=20, offset=1}));
		arguments.event.setValue('recentEvents', beans.EventService.listEvents('1=1 ORDER BY createdOn desc', [], {maxresults=20, offset=1}));
		arguments.event.setValue('config', beans.AppConfig);
	}
	
	public function getSlideshowsSearch(Any event){
		var q = htmlEditFormat(event.getValue('q',''));
		if(!len(trim(q))){
			arguments.event.setValue('msg', 'You didn''t specify a search term.');
			arguments.event.forward('page.index', 'msg');
		}
		var max = 10;
		
		var start = beans.Utils.cleanVarForPaging(arguments.event.getValue('s',1));
		var search = beans.SearchService.search(q,start);
		var count = search.meta.totalRecords;
		var slideshows = search.slideshows;

		if(!count){
			arguments.event.setValue('msg', 'No presentations found matching the search term ' & '"' & q & '".');
			arguments.event.forward('page.index', 'msg');
		}
		if(start > count){
			arguments.event.setValue('s',1);
			arguments.event.forward('slideshows.list','s');
		}

		arguments.event.setValue('hasNext', count >= start + arrayLen(slideshows));
		arguments.event.setValue('nextStart', start + arrayLen(slideshows));
		arguments.event.setValue('hasPrev', start > 1);
		arguments.event.setValue('prevStart', start - max < 0 ? 1 : start - max);
		arguments.event.setValue('slideshows', slideshows);
		arguments.event.setValue('countSlideshows', count);
		arguments.event.setValue('config', beans.AppConfig);
	}
	
	public function getSlideshowsList(Any event){
		var whereClause = 'lastBuildDate is not null and password is null ORDER BY createdOn desc';
		var count = beans.Slideshowservice.countSlideshows(whereClause);
		var max = 10;
		
		var start = beans.Utils.cleanVarForPaging(arguments.event.getValue('s',1));
		
		if(!count){
			arguments.event.setValue('msg', 'No Presentations Found.');
			arguments.event.forward('page.index', 'msg');
		}
		if(start > count){
			arguments.event.setValue('s',1);
			arguments.event.forward('slideshows.list','s');
		}

		var slideshows = beans.SlideshowService.listAllSlideshows(whereClause, [], {maxresults=max, offset=start});
		
		arguments.event.setValue('hasNext', count >= start + arrayLen(slideshows));
		arguments.event.setValue('nextStart', start + arrayLen(slideshows));
		arguments.event.setValue('hasPrev', start > 1);
		arguments.event.setValue('prevStart', start - max < 0 ? 1 : start - max);
		arguments.event.setValue('slideshows', slideshows);
		arguments.event.setValue('countSlideshows', count);
		arguments.event.setValue('config', beans.AppConfig);
	}
	
	public function getUsersList(Any event){
		var whereClause = '1=1 ORDER BY createdOn desc';
		var count = beans.UserService.countUsers(whereClause);
		var max = 10;
		
		var start = beans.Utils.cleanVarForPaging(arguments.event.getValue('s',1));
		
		if(!count){
			arguments.event.setValue('msg', 'No Users Found.');
			arguments.event.forward('page.index', 'msg');
		}
		if(start > count){
			arguments.event.setValue('s',1);
			arguments.event.forward('users.list','s');
		}

		var users = beans.UserService.listUsers(whereClause, [], {maxresults=max, offset=start});
		
		arguments.event.setValue('hasNext', count >= start + arrayLen(users));
		arguments.event.setValue('nextStart', start + arrayLen(users));
		arguments.event.setValue('hasPrev', start > 1);
		arguments.event.setValue('prevStart', start - max < 0 ? 1 : start - max);
		arguments.event.setValue('users', users);
		arguments.event.setValue('countUsers', count);
		arguments.event.setValue('config', beans.AppConfig);
	}
	
	public function getGroupsList(Any event){
		var whereClause = '1=1 ORDER BY createdOn desc';
		var count = beans.GroupService.countGroups(whereClause);
		var max = 10;
		
		var start = beans.Utils.cleanVarForPaging(arguments.event.getValue('s',1));
		
		if(!count){
			arguments.event.setValue('msg', 'No Groups Found.');
			arguments.event.forward('page.index', 'msg');
		}
		if(start > count){
			arguments.event.setValue('s',1);
			arguments.event.forward('groups.list','s');
		}

		var groups = beans.GroupService.listGroups(whereClause, [], {maxresults=max, offset=start});
		
		arguments.event.setValue('hasNext', count >= start + arrayLen(groups));
		arguments.event.setValue('nextStart', start + arrayLen(groups));
		arguments.event.setValue('hasPrev', start > 1);
		arguments.event.setValue('prevStart', start - max < 0 ? 1 : start - max);
		arguments.event.setValue('groups', groups);
		arguments.event.setValue('countGroups', count);
		arguments.event.setValue('config', beans.AppConfig);
	}
	
	public function getEventsList(Any event){
		var whereClause = '1=1 ORDER BY createdOn desc';
		var count = beans.EventService.countEvents(whereClause);
		var max = 10;
		
		var start = beans.Utils.cleanVarForPaging(arguments.event.getValue('s',1));
		
		if(!count){
			arguments.event.setValue('msg', 'No Events Found.');
			arguments.event.forward('page.index', 'msg');
		}
		if(start > count){
			arguments.event.setValue('s',1);
			arguments.event.forward('events.list','s');
		}

		var events = beans.EventService.listEvents(whereClause, [], {maxresults=max, offset=start});
		
		arguments.event.setValue('hasNext', count >= start + arrayLen(events));
		arguments.event.setValue('nextStart', start + arrayLen(events));
		arguments.event.setValue('hasPrev', start > 1);
		arguments.event.setValue('prevStart', start - max < 0 ? 1 : start - max);
		arguments.event.setValue('events', events);
		arguments.event.setValue('countEvents', count);
		arguments.event.setValue('config', beans.AppConfig);
	}
	
	public function getSlideshowView(Any event){
		var slideshowid = val(trim(arguments.event.getValue('slideshowid')));
		var slideshow = beans.SlideshowService.listAllSlideshows('lastBuildDate is not null and id = ? ORDER BY createdOn desc', [slideshowid]);
		if(arrayLen(slideshow) != 1){
			arguments.event.forward('page.index');
		}
		else{
			slideshow = slideshow[1];
		}
		arguments.event.setValue('currentUser', beans.UserService.readUser(beans.UserService.getCurrentUserID()));
		arguments.event.setValue('slideshow', slideshow);
		arguments.event.setValue('utils', beans.Utils);
	}
	
	public function getPrivateSlideshowAccess(Any event){
		var id = val(trim(arguments.event.getValue('slideshowid')));
		var pass = hash(arguments.event.getValue('password'), "md5");
		var slideshow = beans.SlideshowService.listAllSlideshows('lastBuildDate is not null and id = ? ORDER BY createdOn desc', [id]);
		if(arrayLen(slideshow) != 1){
			arguments.event.forward('page.index');
		}
		else{
			slideshow = slideshow[1];
		}
		if(slideshow.getPassword() != pass){
			arguments.event.setValue('invalidPassword', true);
		}
		else{
			if(!arrayFind(session.privateAccess, id)){
				arrayAppend(session.privateAccess, id);
			}
		}
	}
	
	public function getAuthSlideSix(Any event){
		var u = arguments.event.getValue('username');
		var p = arguments.event.getValue('password');
		var res = beans.SlideSixImportService.authenticate(u,p); 
		if(isArray(res) && arrayLen(res)){
			arguments.event.setValue('authMsg', 'SlideSix authentication failed.  Please check username & password and try again');
			arguments.event.addResult('invalidAuth');
			abort;
		}
		else if(isStruct(res) && structKeyExists(res, 'remoteSessionToken')){
			if(structKeyExists(res, 'remoteSessionToken')){
				session.slidesixToken = res.remoteSessionToken;
				session.slidesixUserID = res.userid;
				arguments.event.addResult('authenticated');	
			}
			else{
				arguments.event.setValue('authMsg', 'An error occurred.  Please try again.');
				arguments.event.addResult('sessionTokenMissing');
			}
		}
	}

	public function getSlideSixSlideshows(Any event){
		var validKey = checkSlideSixKey();

		if(!validKey){
			arguments.event.setValue('authMsg', 'Your import session may have expired.  Please re-authenticate.');
			arguments.event.forward('page.slidesixauth', 'authMsg');
		}

		var slidesixSlideshows = beans.SlideSixImportService.getSlideshows(getSlideSixUserID(), getSlideSixKey()); 
		var ids = '';
		var cols = slidesixSlideshows.columns;
		var idcol = arrayFindNoCase(cols, 'slideshowid');

		for(var c in slidesixSlideshows.data){
			ids = listAppend(ids, c[idcol]);
		}
		var cuID = beans.UserService.getCurrentUserID();
		var whereClause = 'select s from Slideshow s join s.createdBy u where s.importedID IN (:idList) and u.id = :createdBy';
		var params = {idList=listToArray(ids),createdBy=cuID};
		var importedSlideshows = beans.SlideshowService.querySlideshows(whereClause, params);

		arguments.event.setValue('config', beans.AppConfig);
		arguments.event.setValue('slidesixSlideshows', slidesixSlideshows);
		arguments.event.setValue('importedSlideshows', importedSlideshows);
	}

	public function getSlideSixImport (Any event){
		var validKey = checkSlideSixKey();
		if(!validKey){
			arguments.event.setValue('authMsg', 'Your import session may have expired.  Please re-authenticate.');
			arguments.event.forward('page.slidesixauth', 'authMsg');
		}
		var alias = arguments.event.getValue('alias');
		var slideshow = beans.SlideSixImportService.getSlideshow(alias); 
		var importedTitle = beans.SlideSixImportService.importSlideshow(slideshow);
		arguments.event.setValue('importedTitle', importedTitle);
	}
	
	public string function getSlideSixKey(){
		if(checkSlideSixKey()){
			return session.slidesixToken;
		}
		return '';
	}
	
	public string function getSlideSixUserID(){
		if(checkSlideSixKey()){
			return session.slidesixUserID;
		}
		return '';
	}
	
	public boolean function checkSlideSixKey(){
		return structKeyExists(session, 'slidesixToken') && session.slidesixToken != '';
	}

	public function getUserView(Any event){
		var id = val(trim(arguments.event.getValue('userid')));
		var user = beans.UserService.listUsers('id = ?', [id], {});
		if(arrayLen(user) != 1){
			arguments.event.forward('page.index');
		}
		else{
			user = user[1];
		}
		arguments.event.setValue('user', user);
	}
	
	public function getGroupView(Any event){
		var id = val(trim(arguments.event.getValue('groupid')));
		var group = beans.GroupService.listGroups('id = ?', [id], {});
		if(arrayLen(group) != 1){
			arguments.event.forward('page.index');
		}
		else{
			group = group[1];
		}
		arguments.event.setValue('group', group);
	}
	
	public function getEventView(Any event){
		var id = val(trim(arguments.event.getValue('eventid')));
		var ev = beans.EventService.listEvents('id = ?', [id], {});
		if(arrayLen(ev) != 1){
			arguments.event.forward('page.index');
		}
		else{
			ev = ev[1];
		}
		arguments.event.setValue('ev', ev);
	}

	public function getPresenterUpdateXML(Any event){
		arguments.event.setValue('currentVersion', beans.AppConfig.getConfigSetting('presenterCurrentVersion'));
		arguments.event.setValue('downloadURL', beans.AppConfig.getConfigSetting('presenterDownloadURL'));
	}
	
	public function getSlideManagerPage(Any event){
	}

	public function getDedicatedRoom(Any event){
	}
	
}
