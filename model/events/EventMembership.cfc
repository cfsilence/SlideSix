component extends='model.Base' persistent='true' entityname='EventMembership' table='eventMemberships' displayname='EventMembership' hint='i am a EventMembership' output='false'
{
	property name='event' fieldtype='many-to-one' cfc='model.events.Event' fkcolumn='eventID' lazy=true cascade='save-update' singularname='event' uniquekey='eventMembershipKey' sqltype='char(35)';
	property name='user' fieldtype='many-to-one' cfc='model.users.User' fkcolumn='userID' lazy=true cascade='save-update' singularname='user' uniquekey='eventMembershipKey' sqltype='char(35)';
	property name='isOwner' ormtype='boolean' notnull=true default=0;
	property name='isApproved' ormtype='boolean' notnull=true default=0;
}