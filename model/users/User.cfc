component extends="model.Base" persistent="true" entityname="User" table="users" displayname="user" hint="i am a user" output="false" accessors="true"
{
	/**
	*@notEmpty
	*@display Username
	*@max 50
	*@ormtype string
	*@length 50
	*@notnull true
	*@alphanum
	*@isuniqueusername
	*@min 4
	*/
	property name="username";
	
	/**
	*@display First Name
	*@notEmpty
	*@max 50
	*@ormtype string
	*@length 50
	*@notnull true
	*/
	property name="firstName";
	
	/**
	*@display Last Name
	*@notEmpty
	*@max 50
	*@ormtype string
	*@length 50
	*@notnull true
	*/
	property name="lastName";
	
	/**
	*@display Password
	*@notEmpty
	*@max 50
	*@ormtype string
	*@length 50
	*@isMatch {confirmPassword}
	*@notnull true
	*/
	property name="password";
	
	/**
	*@display Confirm Password		
	*@notEmpty
	*@max 50
	*@ormtype string
	*@length 50
	*@persistent false
	*@mustmatch Password
	*/
	property name="confirmPassword";
	
	/**
	*@display Email Address
	*@notEmpty
	*@max 500
	*@ormtype string
	*@length 500
	*@email
	*@notnull true
	*/
	property name="email";
	
	/**
	*@default 0
	*@ormtype boolean
	*@notnull true
	*/
	property name="isAdmin";
	
	/**
	*@default 0
	*@ormtype boolean
	*@notnull true
	*/
	property name="isArchived";
	
	/**
	*@display Dedicated Room Password
	*@max 50
	*@ormtype string
	*@length 50
	*@isMatch {confirmDedicatedRoomPassword}
	*/
	property name="dedicatedRoomPassword";
	
	/**
	*@display Confirm Dedicated Room Password		
	*@max 50
	*@ormtype string
	*@length 50
	*@persistent false
	*@mustmatch dedicatedRoomPassword
	*/
	property name="confirmDedicatedRoomPassword";
	
	/**
	*@max 3000
	*@ormtype string
	*@length 3000
	*/
	property name="bio";
	
	/**
    *@persistent false
    */
	property name="userImageUploadFile";
	
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
	*@default 0
	*@ormtype boolean
	*@notnull true
	*/
	property name="isVerified";
	/**
	*@sqltype char(35)
    */

	property name="verifyKey";
	
	/**
	*@default 0
	*@ormtype boolean
	*@notnull true
	*/
	property name="isSubscribed";
	
	/**
	*@ormtype timestamp
	*@notnull true
    */
	property name="lastLoggedInOn";

	/**
    *@fieldtype one-to-many
	*@cfc model.groups.GroupMembership
	*@fkcolumn userID
	*@inverseJoinColumn userID
	*@singularName groupMembership
	*@lazy true
	*@cascade save-update
	*@inverse true
    */
	property name="groupMemberships";
	
	/**
    *@fieldtype one-to-many
	*@cfc model.slideshows.Slideshow
	*@fkcolumn createdBy
	*@singularName slideshow
	*@lazy true
	*@cascade save-update
    */
	property name="slideshows";
	
	/**
    *@fieldtype many-to-many
	*@cfc model.slideshows.Slideshow
	*@linkTable favorites
	*@fkcolumn slideshowID
	*@inverseJoinColumn userID
	*@singularName favorite
	*@lazy true
	*@cascade save-update
	*@inverse true
    */
	property name="favorites";
	
	
	public function addGroupMembership(groupMembership){
		if(isNull(variables.groupMemberships)){
			variables.groupMemberships = arrayNew(1);
		}
		
		arrayAppend(variables.groupMemberships, arguments.groupMembership);
		
		if(!isNull(arguments.groupMembership) && !arguments.groupMembership.hasUser(this)){
			arguments.groupMembership.setUser(this);
		}
	}
	
	public function addFavorite(favorite){
		if(isNull(variables.favorites)){
			variables.favorites = arrayNew(1);
		}
		
		arrayAppend(variables.favorites, arguments.favorite);
		
		if(!isNull(arguments.favorite) && !arguments.favorite.hasFavoritedBy(this)){
			arguments.favorite.addFavoritedBy(this);
		}
	}
	
	//override the password setters
	
	public void function setPassword(password){
		if(structKeyExists(arguments, 'password')){
			variables.password = hash(arguments.password, "md5");
		}
		else{
			variables.password = javacast('null', '');
		}
	}
	
	public void function setConfirmPassword(confirmPassword){
		if(structKeyExists(arguments, 'confirmPassword')){
			variables.confirmPassword = hash(arguments.confirmPassword, "md5");
		}
		else{
			variables.confirmPassword = javacast('null', '');
		}
	}
	
	public void function setDedicatedRoomPassword(dedicatedRoomPassword){
		if(structKeyExists(arguments, 'dedicatedRoomPassword')){
			variables.dedicatedRoomPassword = hash(arguments.dedicatedRoomPassword, "md5");
		}
		else{
			variables.dedicatedRoomPassword = javacast('null', '');
		}
	}
	
	public void function setConfirmDedicatedRoomPassword(confirmDedicatedRoomPassword){
		if(structKeyExists(arguments, 'confirmDedicatedRoomPassword')){
			variables.confirmDedicatedRoomPassword = hash(arguments.confirmDedicatedRoomPassword, "md5");
		}
		else{
			variables.confirmDedicatedRoomPassword = javacast('null', '');
		}
	}
	
	public void function preInsert(){
		setCreatedOn(now());
		setUpdatedOn(now());
		setLastLoggedInOn(now());
		setVerifyKey(createUUID());
	}
	
	public void function postLoad(){
		if(!isNull(getPassword()) && len(trim(getPassword()))){
			variables.confirmPassword = variables.password;
		}
		if(!isNull(getDedicatedRoomPassword()) && len(trim(getDedicatedRoomPassword()))){
			variables.confirmDedicatedRoomPassword = variables.dedicatedRoomPassword;
		}
	}
}