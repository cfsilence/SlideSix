component hint="i am the remote GroupService" output="false"
{
	public function getComponent(){
		return application.factory.getBean('GroupService');
	}

	remote function deleteGroupByID(id,noFlush){
		return getComponent().deleteGroupByID(argumentCollection=arguments);
	}
	
	remote function listGroupMembershipsByGroupID(groupID,isApproved){
		getComponent().checkGroupOwner(arguments.groupID);
		return getComponent().listGroupMembershipsByGroupID(argumentCollection=arguments);
	}
	
	remote function readGroupMembership(id){
		return getComponent().readGroupMembership(argumentCollection=arguments);
	}

	remote function saveGroupImage(id,groupImgUpload){
		return getComponent().saveGroupImage(argumentCollection=arguments);
	}
	
	remote function listGroups(String whereClause,Array params){
		return getComponent().listGroups(argumentCollection=arguments);
	}
	
	remote function saveNewGroup(data,createdByID){
		return getComponent().saveNewGroup(argumentCollection=arguments);
	}
	
	remote function saveGroupInfo(id,data){
		return getComponent().saveGroupInfo(argumentCollection=arguments);
	}
	
	remote function deleteGroup(instance,noFlush){
		return getComponent().deleteGroup(argumentCollection=arguments);
	}
	
	remote function deleteGroupMembership(instance,noFlush){
		return getComponent().deleteGroupMembership(argumentCollection=arguments);
	}
	
	remote function saveGroupMembership(target,noFlush){
		return getComponent().saveGroupMembership(argumentCollection=arguments);
	}
	
	remote function saveGroup(target,noFlush){
		return getComponent().saveGroup(argumentCollection=arguments);
	}
	
	remote function readGroup(id){
		return getComponent().readGroup(argumentCollection=arguments);
	}
	
	remote function listGroupsByUserID(userID){
		return getComponent().listGroupsByUserID(argumentCollection=arguments);
	}
	
	remote function savePendingMemberships(Array memberships,groupID){
		getComponent().checkGroupOwner(arguments.groupID);
		return getComponent().savePendingMemberships(argumentCollection=arguments);
	}
	
	remote function saveGroupMembershipInfo(id,data,groupID,userID){
		return getComponent().saveGroupMembershipInfo(argumentCollection=arguments);
	}
	
	remote function listGroupMemberships(String whereClause,Array params){
		return getComponent().listGroupMemberships(argumentCollection=arguments);
	}

	remote function deleteGroupMembershipByID(id,noFlush){
		return getComponent().deleteGroupMembershipByID(argumentCollection=arguments);
	}
	
}