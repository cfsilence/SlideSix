component hint="i am the remote EventService" output="false"
{
	public function getComponent(){
		return application.factory.getBean('EventService');
	}

	remote function deleteEventByID(id,noFlush){
		return getComponent().deleteEventByID(argumentCollection=arguments);
	}
	
	remote function listEventMembershipsByEventID(eventID,isApproved){
		getComponent().checkEventOwner(arguments.eventID);
		return getComponent().listEventMembershipsByEventID(argumentCollection=arguments);
	}
	
	remote function readEventMembership(id){
		return getComponent().readEventMembership(argumentCollection=arguments);
	}

	remote function saveEventBannerImage(id, eventImgUpload, generateThumb=false, width=700, height=''){
		return getComponent().saveEventBannerImage(argumentCollection=arguments);
	}

	remote function saveEventImage(id,eventImgUpload, generateThumb=true, width=150, height=150){
		return getComponent().saveEventImage(argumentCollection=arguments);
	}
	
	remote function listEvents(String whereClause,Array params){
		return getComponent().listEvents(argumentCollection=arguments);
	}
	
	remote function saveNewEvent(data,createdByID){
		return getComponent().saveNewEvent(argumentCollection=arguments);
	}
	
	remote function saveEventInfo(id,data){
		return getComponent().saveEventInfo(argumentCollection=arguments);
	}
	
	remote function deleteEvent(instance,noFlush){
		return getComponent().deleteEvent(argumentCollection=arguments);
	}
	
	remote function deleteEventMembership(instance,noFlush){
		return getComponent().deleteEventMembership(argumentCollection=arguments);
	}
	
	remote function saveEventMembership(target,noFlush){
		return getComponent().saveEventMembership(argumentCollection=arguments);
	}
	
	remote function saveEvent(target,noFlush){
		return getComponent().saveEvent(argumentCollection=arguments);
	}
	
	remote function readEvent(id){
		return getComponent().readEvent(argumentCollection=arguments);
	}
	
	remote function listEventsByUserID(userID){
		return getComponent().listEventsByUserID(argumentCollection=arguments);
	}
	
	remote function savePendingMemberships(Array memberships,eventID){
		getComponent().checkEventOwner(arguments.eventID);
		return getComponent().savePendingMemberships(argumentCollection=arguments);
	}
	
	remote function saveEventMembershipInfo(id,data,eventID,userID){
		return getComponent().saveEventMembershipInfo(argumentCollection=arguments);
	}
	
	remote function listEventMemberships(String whereClause,Array params){
		return getComponent().listEventMemberships(argumentCollection=arguments);
	}

	remote function deleteEventMembershipByID(id,noFlush){
		return getComponent().deleteEventMembershipByID(argumentCollection=arguments);
	}
	
}