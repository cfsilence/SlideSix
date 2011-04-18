component extends="model.Base" persistent="true" entityname="GroupMembership" table="groupMemberships" displayname="GroupMembership" hint="i am a GroupMembership" output="false"
{
	/**
    *@fieldtype many-to-one
	*@cfc model.groups.Group
	*@fkcolumn groupID
	*@lazy true
	*@cascade save-update
	*@singularname group
	*@uniqueKey groupMembershipKey
	*@sqltype char(35)
    */
	property name="group";
	/**
    *@fieldtype many-to-one
	*@cfc model.users.User
	*@fkcolumn userID
	*@lazy true
	*@cascade save-update
	*@singularname user
	*@uniqueKey groupMembershipKey
	*@sqltype char(35)
    */
	property name="user";
	/**
    *@ormtype boolean
	*@notnull
	*@default 0
    */
	property name="isOwner";
	/**
    *@ormtype boolean
	*@notnull
	*@default 0
    */
	property name="isApproved";

}