component extends='model.Base' persistent='true' entityName='Event' table='events' displayname='Event' hint='i am a event' output='false'
{
	property name='name' display='Event Name' notEmpty=true max=255 length=255 notnull=true sqltype='varchar(255)';
	property name='alias' length=300 ormtype='string' sqltype='varchar(300)';
	property name='organizerInfo' display='Who is putting on the event?' length=1000 ormtype='string' sqltype='varchar(1000)';
	property name='descriptionShort' display='Event Description (Short)' ormtype='string' length=300 sqltype='varchar(300)';
	property name='descriptionFull' display='Event Description (Full)' ormtype='string' length=2000 sqltype='varchar(2000)';
	property name='tracks' display='Tracks' ormtype='string' length=500 sqltype='varchar(500)';
	property name='costInfo' display='Information About cost' ormtype='string' length=1000 sqltype='varchar(1000)';
	property name='startDate' ormtype='date';
	property name='endDate' ormtype='date';
	property name='venue' ormtype='string' length=500 sqltype='varchar(500)';
	property name='externalHomepageURL' ormtype='string' length=1000 sqltype='varchar(1000)';
	property name='rssURL' ormtype='string' length=1000 sqltype='varchar(1000)';
	property name='scheduleURL' ormtype='string' length=1000 sqltype='varchar(1000)';
	property name='contactURL' ormtype='string' length=1000 sqltype='varchar(1000)';
	property name='eventImageUploadFile' persistent=false;
	property name='pathToBannerImage' ormtype='string' length=3000 sqltype='varchar(3000)';
	property name='pathToImage' ormtype='string' length=3000 sqltype='varchar(3000)';
	property name='pathToImageThumb' ormtype='string' length=3000 sqltype='varchar(3000)';
	property name='autoAcceptMembers' default='1' ormtype='boolean' notnull=true;
	property name='eventSlideshowRelationships' fieldtype='one-to-many' cfc='model.events.EventSlideshowRelationship' fkcolumn='eventID' inverseJoinColumn='eventID' lazy=true cascade='save-update' singularname='EventSlideshowRelationship';
	property name='eventMemberships' fieldtype='one-to-many' cfc='model.events.EventMembership' fkcolumn='eventID' inverseJoinColumn='eventID' lazy=true cascade='save-update' singularname='eventMembership';
	property name='pendingMembers' formula='select count(*) from eventMemberships g where g.eventID=id and g.isApproved = 0';
	property name='isFeatured' notnull='true' ormtype='boolean' default='0' dbdefault='0';
	
	public function addEventSlideshowRelationship(eventSlideshowRelationship){
		if(isNull(variables.eventSlideshowRelationships)){
			variables.eventSlideshowRelationships = arrayNew(1);
		}
		
		arrayAppend(variables.eventSlideshowRelationships, arguments.eventSlideshowRelationship);
		
		if(!isNull(arguments.eventSlideshowRelationship) && !arguments.eventSlideshowRelationship.hasEvent(this)){
			arguments.eventSlideshowRelationship.setEvent(this);
		}
	}

	public function addEventMembership(eventMembership){
		if(isNull(variables.eventMemberships)){
			variables.eventMemberships = arrayNew(1);
		}
		
		arrayAppend(variables.eventMemberships, arguments.eventMembership);
		
		if(!isNull(arguments.eventMembership) && !arguments.eventMembership.hasEvent(this)){
			arguments.eventMembership.setUser(this);
		}
	}
}