component extends="model.Base" persistent="true" entityName="Group" table="groups" displayname="Group" hint="i am a group" output="false"
{
	property name='groupImageUploadFile' persistent='false';
	property name='name' max='255' notnull='yes' notempty='yes' display='Group Name';
	property name='slideshows' fieldtype='one-to-many' singularname='slideshow' cascade='save-update' lazy='true' cfc='model.slideshows.Slideshow' fkcolumn='groupID';
	property name='description' max='2000' notnull='yes' notempty='yes' display='Group Description';
	property name='autoAcceptMembers' notnull='true' ormtype='boolean' default='1';
	property name='alias' max='50';
	property name='pathToImageThumb' max='3000' ormtype='string' length='3000';
	property name='groupMemberships' fieldtype='one-to-many' singularname='groupMembership' inversejoincolumn='groupID' cascade='save-update' lazy='true' cfc='model.groups.GroupMembership' fkcolumn='groupID';
	property name='pathToImage' max='3000' ormtype='string' length='3000';
	property name="pendingMembers" formula="select count(*) from groupMemberships g where g.groupID=id and g.isApproved = 0";
	property name='isFeatured' notnull='true' ormtype='boolean' default='0' dbdefault='0';
}