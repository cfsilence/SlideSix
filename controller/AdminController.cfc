component  extends="ModelGlue.gesture.controller.Controller" hint="i am a model-glue controller" output="false"
	beans="UserService,AppConfig,SearchService,SlideshowService,GroupService,Hyrule"
{
	public function onApplicationStart(event){
	}
	public function onSessionStart(event){
	}
	public function onSessionEnd(event){
	}
	
	public function init(framework)
	 hint="Constructor" output="false"{
		super.init(framework);
		return this;
	}
	
	public function onRequestStart(Any event){
	}

	public function getAdminMain(Any event){
			
	}
	
	public function getAdminUsers(Any event){
		var recs = 10;
		var pagination = createObject('component', 'services.utils.Pagination').init();
		
		pagination.setItemsPerPage(recs);
		pagination.setUrlPageIndicator("page");
		pagination.setShowNumericLinks(true);
		
		var searchString = arguments.event.getValue('searchString');
		var searchCol = arguments.event.getValue('searchCol'); 
		var page = arguments.event.getValue('page',1);
		var sRow = page >= 1 ? ((page - 1) * pagination.getItemsPerPage()) + 1 : 0;
		
		var whereClause = len(trim(searchString)) && len(trim(searchCol)) ? searchCol & ' like ?' : '1=1';
		var orderBy = 'createdOn desc';
		var params = len(trim(searchString)) && len(trim(searchCol)) ? ['%'&searchString&'%'] : [];

		pagination.setBaseLink('index.cfm?event=admin.users&searchString=#searchString#&searchCol=#searchCol#');
		 
		var users = beans.UserService.listUsers(whereClause & ' order by ' & orderBy, params, {maxresults=recs, offset=sRow});
		var totalUsers = beans.UserService.countUsers(whereClause & ' order by ' & orderBy, params);
		
		pagination.setRecordsToPaginate(totalUsers);
		
		arguments.event.setValue('pagination', pagination);
		arguments.event.setValue('users', users);
		arguments.event.setValue('totalUsers', totalUsers);
	}

	public function getEditUser(Any event){
		var id = arguments.event.getValue('id');
		var user = beans.UserService.readUser(id);
		arguments.event.setValue("user", user);
	}
	
	public function getEditUserAction(Any event){
		var id = arguments.event.getValue('id');
		var user = beans.UserService.readUser(id);
		var args = duplicate(arguments.event.getAllValues());
		if(!len(trim(arguments.event.getValue('password')))){
			structDelete(args, 'password');
		}
		if(!len(trim(arguments.event.getValue('confirmPassword')))){
			structDelete(args, 'confirmPassword');
		}
		if(!len(trim(arguments.event.getValue('dedicatedRoomPassword')))){
			structDelete(args, 'dedicatedRoomPassword');
		}
		if(!len(trim(arguments.event.getValue('confirmDedicatedRoomPassword')))){
			structDelete(args, 'confirmDedicatedRoomPassword');
		}
		user.populate(args);
		
		if(arguments.event.getValue('removeDedicatedRoomPassword', false)){
			user.setDedicatedRoomPassword(javacast('null', ''));
			user.setConfirmDedicatedRoomPassword(javacast('null', ''));
		}
		
		//we're editing so forget about checking unique username
		var props = getMetaData(user).properties;
		for(var p = 1; p<=arrayLen(props); p++){
			if(props[p]['name'] == 'username'){
				structDelete(props[p], 'isUniqueUsername');
				break;
			}
		}
		var result = beans.Hyrule.validate(user);
		arguments.event.setValue('errors', result);
		
		if(result.hasErrors()){
			arguments.event.setValue('user', user);
			arguments.event.addResult('failure');
		}
		else{
			beans.SlideshowService.saveProfile(user.getID(),args);
			arguments.event.addResult('success');
		}
	}
	
	public function getDeleteUser(Any event){
		var id = arguments.event.getValue('id');
		var user = beans.UserService.readUser(id);
		var msg = 'User "' & user.getFirstName() & ' ' & user.getLastName() & '" has been deleted.';
		var deleted = beans.UserService.deleteUser(user);
		
		arguments.event.setValue("msg", msg);
		arguments.event.addResult('deleted');
	}	
	
	public function getAdminSlideshows(Any event){
		var recs = 10;
		var pagination = createObject('component', 'services.utils.Pagination').init();
		
		pagination.setItemsPerPage(recs);
		pagination.setUrlPageIndicator("page");
		pagination.setShowNumericLinks(true);
		
		var searchString = arguments.event.getValue('searchString');
		var searchCol = arguments.event.getValue('searchCol'); 
		var page = arguments.event.getValue('page',1);
		var sRow = page >= 1 ? ((page - 1) * pagination.getItemsPerPage())+1 : 0;
		
		var whereClause = len(trim(searchString)) && len(trim(searchCol)) ? searchCol & ' like ?' : '1=1';
		var orderBy = 'createdOn desc';
		var params = len(trim(searchString)) && len(trim(searchCol)) ? ['%'&searchString&'%'] : [];

		pagination.setBaseLink('index.cfm?event=admin.slideshows&searchString=#searchString#&searchCol=#searchCol#');
		 
		var slideshows = beans.SlideshowService.listSlideshows(whereClause & ' order by ' & orderBy, params, {maxresults=recs, offset=sRow});
		var totalSlideshows = beans.SlideshowService.countSlideshows(whereClause & ' order by ' & orderBy, params);
		
		pagination.setRecordsToPaginate(totalSlideshows);
		
		arguments.event.setValue('pagination', pagination);
		arguments.event.setValue('slideshows', slideshows);
		arguments.event.setValue('totalSlideshows', totalSlideshows);
	}
	
	public function getEditSlideshow(Any event){
		var id = arguments.event.getValue('id');
		var slideshow = beans.SlideshowService.readSlideshow(id);
		arguments.event.setValue("slideshow", slideshow);
	}

	public function getEditSlideshowAction(Any event){
		var id = arguments.event.getValue('id');
		var slideshow = beans.SlideshowService.readSlideshow(id);
		var args = duplicate(arguments.event.getAllValues());
		if(!len(trim(arguments.event.getValue('password')))){
			structDelete(args, 'password');
		}
		if(!len(trim(arguments.event.getValue('confirmPassword')))){
			structDelete(args, 'confirmPassword');
		}
		slideshow.populate(args);
		if(arguments.event.getValue('removePassword', false)){
			slideshow.setPassword(javacast('null', ''));
			slideshow.setConfirmPassword(javacast('null', ''));
		}
		slideshow.setNotifyComments(arguments.event.getValue('notifyComments', false));
		slideshow.setAllowComments(arguments.event.getValue('allowComments', false));
		
		var result = beans.Hyrule.validate(slideshow);
		arguments.event.setValue('errors', result);
		
		if(result.hasErrors()){
			arguments.event.setValue('slideshow', slideshow);
			arguments.event.addResult('failure');
		}
		else{
			beans.SlideshowService.saveSlideshowInfo(slideshow.getID(),args,slideshow.getCreatedBy().getID(), args.groupID);
			arguments.event.addResult('success');
		}
	}
	
	public function getDeleteSlideshow(Any event){
		var id = arguments.event.getValue('id');
		var slideshow = beans.SlideshowService.readSlideshow(id);
		arguments.event.setValue("slideshow", slideshow);
	}
	
	public function getAdminGroups(Any event){
		var recs = 10;
		var pagination = createObject('component', 'services.utils.Pagination').init();
		
		pagination.setItemsPerPage(recs);
		pagination.setUrlPageIndicator("page");
		pagination.setShowNumericLinks(true);
		
		var searchString = arguments.event.getValue('searchString');
		var searchCol = arguments.event.getValue('searchCol'); 
		var page = arguments.event.getValue('page',1);
		var sRow = page >= 1 ? ((page - 1) * pagination.getItemsPerPage())+1 : 0;
		
		var whereClause = len(trim(searchString)) && len(trim(searchCol)) ? searchCol & ' like ?' : '1=1';
		var orderBy = 'createdOn desc';
		var params = len(trim(searchString)) && len(trim(searchCol)) ? ['%'&searchString&'%'] : [];

		pagination.setBaseLink('index.cfm?event=admin.groups&searchString=#searchString#&searchCol=#searchCol#');
		 
		var groups = beans.GroupService.listGroups(whereClause & ' order by ' & orderBy, params, {maxresults=recs, offset=sRow});
		var totalGroups = beans.GroupService.countGroups(whereClause & ' order by ' & orderBy, params);
		
		pagination.setRecordsToPaginate(totalGroups);
		
		arguments.event.setValue('pagination', pagination);
		arguments.event.setValue('groups', groups);
		arguments.event.setValue('totalGroups', totalGroups);
	}
	
	public function getEditGroup(Any event){
		var id = arguments.event.getValue('id');
		var group = beans.GroupService.readGroup(id);
		arguments.event.setValue("group", group);
	}

	public function getEditGroupAction(Any event){
		var id = arguments.event.getValue('id');
		var group = beans.GroupService.readGroup(id);
		var args = duplicate(arguments.event.getAllValues());
		group.populate(args);
		group.setAutoAcceptMembers(arguments.event.getValue('autoAcceptMembers', false));
		
		var result = beans.Hyrule.validate(group);
		arguments.event.setValue('errors', result);
		
		if(result.hasErrors()){
			arguments.event.setValue('group', group);
			arguments.event.addResult('failure');
		}
		else{
			beans.SlideshowService.saveGroupInfo(group.getID(),args);
			arguments.event.addResult('success');
		}
	}
	
	public function getDeleteGroup(Any event){
		var id = arguments.event.getValue('id');
		var group = beans.GroupService.readGroup(id);
		var msg = 'Group "' & group.getName() & '" has been deleted.';
		var slideshows = group.getSlideshows();
		for(var s in slideshows){
			s.setGroup(javacast('null', ''));
			beans.SlideshowService.saveSlideshow(s);
		}
		var deleted = beans.GroupService.deleteGroup(group);
		
		arguments.event.setValue("msg", msg);
		arguments.event.addResult('deleted');
	}
	
}
