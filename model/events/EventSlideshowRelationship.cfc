component extends='model.Base' persistent='true' entityname='EventSlideshowRelationship' table='eventToSlideshow' displayname='EventSlideshowRelationship' hint='i am a EventSlideshow relationship' output='false'
{
	property name='event' fieldtype='many-to-one' cfc='model.events.Event' fkcolumn='eventID' lazy=true cascade='save-update' singularname='event' uniquekey='eventMembershipKey' sqltype='char(35)';
	property name='slideshow' fieldtype='many-to-one' cfc='model.slideshows.Slideshow' fkcolumn='slideshowID' lazy=true cascade='save-update' singularname='user' uniquekey='eventMembershipKey' sqltype='char(35)';
}