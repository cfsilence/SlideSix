component extends="model.Base" persistent="true" entityname="User" table="users" displayname="user" hint="i am a user" output="false" accessors="true"
{
	property name='username' ormtype='string' notempty='yes' display='Username' max='50' min='4' isuniqueusername='yes' notnull='true' alphanum='yes' length='50';
	property name='firstName' ormtype='string' max='50' notnull='true' notempty='yes' length='50' display='First Name';
	property name='lastName' max='50' ormtype='string' notnull='true' notempty='yes' length='50' display='Last Name';
	property name='disqusShortName' max='500' ormtype='string' length='500' display='Disqus Short Name';
	property name='bio' max='3000' ormtype='string' length='3000';
	property name='email' max='500' ormtype='string' notnull='true' email='yes' notempty='yes' length='500' display='Email Address';
	property name='password' max='50' ormtype='string' notnull='true' notempty='yes' length='50' ismatch='{confirmPassword}' display='Password';
	property name='confirmPassword' max='50' mustmatch='Password' ormtype='string' notempty='yes' persistent='false' length='50' display='Confirm Password';
	property name='isSubscribed' notnull='true' ormtype='boolean' default='0';
	property name='favorites' inverse='true' lazy='true' linktable='favorites' fieldtype='many-to-many' singularname='favorite' inversejoincolumn='userID' cascade='save-update' cfc='model.slideshows.Slideshow' fkcolumn='slideshowID';
	property name='userImageUploadFile' persistent='false';
	property name='verifyKey' sqltype='char(35)';
	property name='pathToImage' max='3000' ormtype='string' length='3000';
	property name='lastLoggedInOn' notnull='true' ormtype='timestamp';
	property name='isArchived' notnull='true' ormtype='boolean' default='0';
	property name='eventMemberships' inverse='true' lazy='true' fieldtype='one-to-many' singularname='eventMembership' inversejoincolumn='userID' cascade='save-update' cfc='model.events.EventMembership' fkcolumn='userID';
	property name='isVerified' notnull='true' ormtype='boolean' default='0';
	property name='confirmDedicatedRoomPassword' max='50' mustmatch='dedicatedRoomPassword' ormtype='string' persistent='false' length='50' display='Confirm Dedicated Room Password';
	property name='dedicatedRoomPassword' max='50' ormtype='string' length='50' ismatch='{confirmDedicatedRoomPassword}' display='Dedicated Room Password';
	property name='pathToImageThumb' max='3000' ormtype='string' length='3000';
	property name='groupMemberships' inverse='true' lazy='true' fieldtype='one-to-many' singularname='groupMembership' inversejoincolumn='userID' cascade='save-update' cfc='model.groups.GroupMembership' fkcolumn='userID';
	property name='isAdmin' notnull='true' ormtype='boolean' default='0';
	property name='slideshows' fieldtype='one-to-many' singularname='slideshow' cascade='save-update' lazy='true' cfc='model.slideshows.Slideshow' fkcolumn='createdBy';
	property name='isFeatured' notnull='true' ormtype='boolean' default='0' dbdefault='0';
	
	public function addEventMembership(eventMembership){
		if(isNull(variables.eventMemberships)){
			variables.eventMemberships = arrayNew(1);
		}
		
		arrayAppend(variables.eventMemberships, arguments.eventMembership);
		
		if(!isNull(arguments.eventMembership) && !arguments.eventMembership.hasUser(this)){
			arguments.eventMembership.setUser(this);
		}
	}
	
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