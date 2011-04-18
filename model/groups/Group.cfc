component extends="model.Base" persistent="true" entityName="Group" table="groups" displayname="Group" hint="i am a group" output="false"
{
	/**
    *@display Group Name
	*@notEmpty
	*@max 255
	*@notnull
    */
	property name="name";
	/**
    *@display Group Description
	*@notEmpty
	*@notnull
	*@max 2000
    */
	property name="description";
	/**
    *@max 50
    */
	property name="alias";
	/**
    *@persistent false
    */
	property name="groupImageUploadFile";
	/**
    *@max 3000
	*@ormtype string
	*@length 3000
    */
	property name="pathToImage";
	/**
	*@max 3000
	*@ormtype string
	*@length 3000
	*/
	property name="pathToImageThumb";
	/**
	*@default 1
	*@ormtype boolean
	*@notnull true
    */
	property name="autoAcceptMembers";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.slideshows.Slideshow
	*@fkcolumn groupID
	*@lazy true
	*@cascade save-update
	*@singularname slideshow
    */
	property name="slideshows";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.groups.GroupMembership
	*@fkcolumn groupID
	*@inverseJoinColumn groupID
	*@lazy true
	*@cascade save-update
	*@singularname groupMembership
    */
	property name="groupMemberships";
	/**
	*
	*/
	property name="pendingMembers" formula="select count(*) from groupMemberships g where g.groupID=id and g.isApproved = 0";
	
}