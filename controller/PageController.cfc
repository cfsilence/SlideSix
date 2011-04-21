component  extends="ModelGlue.gesture.controller.Controller" hint="i am a model-glue controller" output="false"
	beans="UserService,AppConfig,SearchService,SlideshowService,Utils,GroupService"
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

	public function getPresenterUpdateXML(Any event){
		arguments.event.setValue('currentVersion', beans.AppConfig.getConfigSetting('presenterCurrentVersion'));
		arguments.event.setValue('downloadURL', beans.AppConfig.getConfigSetting('presenterDownloadURL'));
	}
	
	public function getSlideManagerPage(Any event){
	}

	public function getDedicatedRoom(Any event){
	}
	
}
