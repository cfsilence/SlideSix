component accessors='true' hint='i am the GroupService' output='false'
{
	property name='GenericDAO' type='any' displayname='GenericDAO';
	property name='Utils' type='any' displayname='Utils';
	property name='UserService' type='any' displayname='UserService';
	property name='EmailService' type='any' displayname='EmailService';
	property name='FileService' type='any' displayname='FileService';
	property name='AppConfig' type='any' displayname='AppConfig';
	
	public  function init(){
		return this;
	}
	
	public function isGroupOwner(id){
		var g = readGroup(id);
		var isOwner = false;
		var cuID = getUserService().getCurrentUserID();
		var u = getUserService().readUser(cuID);
		var e = [];
		
		if(cuID != 0){
			e = listGroupMemberships('user = ? and group = ? and isOwner=?', [u, g, 1]);
		}
		
		if(arrayLen(e) && e[1].getIsOwner()){
			isOwner = true;
		}
		return isOwner;
	}	
	
	public function isGroupMember(id){
		var g = readGroup(id);
		var isMember = false;
		var cuID = getUserService().getCurrentUserID();
		var u = getUserService().readUser(cuID);
		var e = [];
		
		if(cuID != 0){
			e = listGroupMemberships('user = ? and group = ?', [u, g]);
		}
		
		if(arrayLen(e) && e[1].getIsApproved()){
			isMember = true;
		}
		return isMember;
	}
	
	public function checkGroupOwner(id){
		if(!isGroupOwner(arguments.id)){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public function checkGroupMember(id){
		if(!isGroupMember(arguments.id)){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public function saveNewGroup(data,createdByID){
		var g = readGroup(0);		
		g.populate(arguments.data);
		saveGroup(g);
		
		var gm = readGroupMembership(0);
		gm.setUser(getUserService().readUser(createdByID));
		gm.setGroup(g);
		gm.setIsApproved(1);
		gm.setIsOwner(1);
		
		g.addGroupMembership(gm);
		
		saveGroupMembership(gm);
		return g.getID();
	}
	
	public function saveGroupInfo(id,data){
		var gID = isNull(arguments.id) ? 0 : arguments.id;
		var g = readGroup(gID);		
		g.populate(data);
		saveGroup(g);
		return g.getID();
	}
	
	public function saveGroup(target,noFlush){
		var exists = len(target.getCreatedOn()) ? 1 : 0;
		if(!exists){
			var alias = getUtils().makeAlias(target.getName());
			var tries = 0;
			while(arrayLen(listGroups('alias=?',[alias])) > 0 && tries < 100){
				tries++;
				alias = getUtils().makeAlias(target.getName()) & '-' & getUtils().getRandString(6);
				if(tries == 99) alias = getUtils().getStrippedUUID();
			}
			target.setAlias(alias);
		}
		return getGenericDAO().save(argumentCollection=arguments);
	}
	
	public function readGroup(id){
		return getGenericDAO().read('Group', arguments.id);
	}
	
	public function deleteGroup(instance,noFlush){
		return getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteGroupByID(id,noFlush){
		var args = {};
		args.name = 'Group';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		return getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function countGroups(String whereClause, Any params){
		var args = {};
		args.entity = 'Group';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		return getGenericDAO().count(argumentCollection=args);
	}
	
	public function listGroups(String whereClause, Array params){
		return getGenericDAO().list('Group', arguments.whereClause, arguments.params);
	}
	
	public function listGroupsByUserID(userID){
		var user = getUserService().readUser(userID);
		var groups = [];
		var group = {};
		
		for(var gm in user.getGroupMemberships()){
			group = {};
			group['__type__'] = 'com.slidesix.vo.groups.Group';
			group.id = gm.getGroup().getID();
			group.name = gm.getGroup().getName();
			group.description = gm.getGroup().getDescription();
			group.isOwner = gm.getIsOwner();
			group.isApproved = gm.getIsApproved();	
			group.joinedOn = gm.getCreatedOn();
			group.createdOn = gm.getGroup().getCreatedOn();
			group.alias = gm.getGroup().getAlias();
			group.pathToImage = !isNull(gm.getGroup().getPathToImage()) ? gm.getGroup().getPathToImage() : '';
			group.pathToImageThumb = !isNull(gm.getGroup().getPathToImageThumb()) ? gm.getGroup().getPathToImageThumb() : '';
			group.autoAcceptMembers = gm.getGroup().getAutoAcceptMembers();
			group.pendingMembers = javacast('int', val(gm.getGroup().getPendingMembers()));
			group.isFeatured = gm.getGroup().getIsFeatured();
			arrayAppend(groups, group);
		}
		return groups;
	}
	
	public string function saveGroupImage(id,groupImgUpload){
		//isGroupOwner(arguments.id);
		var group = readGroup(arguments.id);
		var groupImgRoot = '/groupFiles/' & group.getID() & '/';
		var storeRoot = getAppConfig().getConfigSetting('storageRootDir');
		var groupImgDir = storeRoot & groupImgRoot;
		
		if(!directoryExists(groupImgDir)){
			getFileService().createDir(groupImgDir);
		} 
		
		var fName = getUtils().getStrippedUUID();
		var groupImgPath = groupImgRoot & fName & '.jpg';
		var groupThumbPath = groupImgRoot & fName & '_thumb.jpg';
		
		var uploaded = getFileService().storeImage('groupImgUpload', storeRoot, groupImgPath, groupThumbPath);
		
		var existingImg = storeRoot & group.getPathToImage();
		if(fileExists(existingImg)){
			getFileService().delete(existingImg);
		}
		var existingThumb = storeRoot & group.getPathToImageThumb();
		if(fileExists(existingThumb)){
			getFileService().delete(existingThumb);
		}
		var d = structNew();
		d.pathToImage = groupImgPath;
		d.pathToImageThumb = groupThumbPath;
		saveGroupInfo(group.getID(), d);
		return groupImgPath;
	}
	
	public function savePendingMemberships(Array memberships, groupID){
		//expects an array of structs with the following prototype:
		//[{groupMembershipID,isApproved}]
		for(var gm in memberships){
			var m = readGroupMembership(gm.groupMembershipID);
			var g = readGroup(m.getGroup().getID());
			var u = getUserService().readUser(m.getUser().getID());
			
			if(gm.isApproved){
				m.setIsApproved(1);
			}
			else{
				u.removeGroupMembership(m);
				g.removeGroupMembership(m);
				deleteGroupMembershipByID(m.getID());
			}
		}
	}
	
	public function saveGroupMembershipInfo(id,data,groupID,userID){
		var gmID = isNull(arguments.id) ? 0 : arguments.id;
		var gm = readGroupMembership(gmID);		
		var u = getUserService().readUser(arguments.userID);
		var g = readGroup(groupID);
		gm.populate(data);
		gm.setGroup(g);
		gm.setUser(u);
		g.addGroupMembership(gm);
		u.addGroupMembership(gm);
		saveGroupMembership(gm);
		return gm.getID();
	}
	
	public function saveGroupMembership(target,noFlush){
		getGenericDAO().save(argumentCollection=arguments);
	}
	
	public function readGroupMembership(id){
		return getGenericDAO().read('GroupMembership', arguments.id);
	}
	
	public function deleteGroupMembership(instance,noFlush){
		getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteGroupMembershipByID(id,noFlush){
		var args = {};
		args.name = 'GroupMembership';
		args.id = arguments.id;
		if(structKeyExists(arguments, 'noFlush')) args.noFlush = arguments.noFlush;
		return getGenericDAO().deleteByID(argumentCollection=args);
	}
	
	public function listGroupMemberships(String whereClause, Array params){
		return getGenericDAO().list('GroupMembership', arguments.whereClause, arguments.params);
	}
	
	public function listGroupMembershipsByGroupID(groupID,isApproved){
		var group = readGroup(groupID);
		var memberships = listGroupMemberships('group = ? and isApproved = ?', [group, arguments.isApproved]);
		var members = [];
		var member = {};
		for(var gm in memberships){
			member = {};
			member['__type__'] = 'com.slidesix.vo.groups.GroupMember';
			member.username = gm.getUser().getUsername();
			member.firstName = gm.getUser().getFirstName();
			member.lastName = gm.getUser().getLastName();
			member.joinedOn = gm.getCreatedOn();
			member.isApproved = gm.getIsApproved();
			member.isOwner = gm.getIsOwner();
			member.groupMembershipID = gm.getID();
			member.groupID = gm.getGroup().getID();
			member.userID = gm.getUser().getID();
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

