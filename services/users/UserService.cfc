component accessors="true"  hint="i am the user service" output="false"
{
	property name="GenericDAO" type="any" displayname="GenericDAO";
	property name="EmailService" type="any" displayname="EmailService";
	property name="AppConfig" type="any" displayname="AppConfig";
	property name="Utils" type="any" displayname="Utils";
	property name="FileService" type="any" displayname="FileService";
	property name="SlideshowService" type="any" displayname="SlideshowService";
	
	public  function init(){
		return this;
	}
	
	public function isAdmin(id){
		var profile = readUser(id);
		var isAdmin = false;
		var cuID = getCurrentUserID();
		
		if(cuID != 0 && !isNull(profile) && profile.getID() == cuID && profile.getIsAdmin()){
			isAdmin = true;
		}
		return isAdmin;
	}
	
	public function isProfileOwner(id){
		var profile = readUser(id);
		var isOwner = false;
		var cuID = getCurrentUserID();
		
		if(cuID != 0 && !isNull(profile) && profile.getID() == cuID){
			isOwner = true;
		}
		if(!isNull(profile) && profile.getIsAdmin()){
			isOwner = true;
		}
		return isOwner;
	}
	
	public function checkAdmin(id){
		if(!isAdmin(arguments.id)){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public function checkProfileOwner(id){
		if(!isProfileOwner(arguments.id)){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public function checkProfileOwnerByUsername(username){
		var user = readUserByUsername(arguments.username);
		if(!isProfileOwner(user.getID())){
			getUtils().addUnauthHeader();
			abort;
		}
	}
	
	public function setCurrentUserID(id){
		session.currentUserID = id;
	}
	public function getCurrentUserID(){
		return structKeyExists(session, "currentUserID") ? session.currentUserID : 0;
	}
	
	public function saveProfile(id, data){
		id = isNull(id) ? 0 : id;
		var u = readUser(id);		
		u.populate(data);
		saveUser(u);
		return u.getID();
	}
	
	public function saveUser(target,noFlush){
		var exists = len(target.getCreatedOn()) ? 1 : 0;
		
		getGenericDAO().save(argumentCollection=arguments);
		
		if(!exists){
			sendVerificationEmail(target);
		}
	}
	
	public function logoutUser(){
		setCurrentUserID(0);	
	}
	
	public function authenticateUser(u,p){
		var users = listUsers('username=? and password=?', [u,p]);
		var v = arrayLen(users) == 1;
		if(v){
			var user = users[1];
			var d = structNew();
			d.lastLoggedInOn = now();
			setCurrentUserID(user.getID());
			saveProfile(user.getID(), d);
 		}
		return v;
	}
	
	public function sendVerificationEmail(user){
		var body = '';
		var appName = getAppConfig().getConfigSetting('appFriendlyName');
		var link = 'http://#cgi.SERVER_NAME#/index.cfm?event=user.verify&u=#user.getID()#&v=#user.getVerifyKey()#';
		
		savecontent variable = "body"{
			writeOutput('<p>Thanks for signing up for #appName#!  Before getting started, please use the following URL to verify your email address.</p>');
			writeOutput('<p><a href="#link#">#link#</a></p>');
		}
		
		var email = getEmailService().createEmail();
		email.setTo(user.getEmail());
		email.setSubject(appName & ' - Please Verify Your Account');
		email.setBody(body);
		email.send();
	}
	
	public function sendPassword(user){
		var body = '';
		var appName = getAppConfig().getConfigSetting('appFriendlyName') ;
		var link = 'http://#cgi.SERVER_NAME#/index.cfm?event=user.loginPage';
		var newpass = getUtils().getRandString(6);
		user.setPassword(newpass);
		save(user);
		
		savecontent variable = "body"{
			writeOutput('<p>Your password has been reset to #newpass#</p>');
			writeOutput('<p>You may now login with your new password at:</p>');
			writeOutput('<p><a href="#link#">#link#</a></p>');
		}
		
		var email = getEmailService().createEmail();
		email.setTo(user.getEmail());
		email.setSubject(appName & ' - Password Reset');
		email.setBody(body);
		email.send();
	}
	
	public function readUser(id){
		return getGenericDAO().read('User', arguments.id);
	}
	
	public function readUserByUsername(username){
		var users = listUsers('username = ?', [arguments.username]);
		if(arrayLen(users) == 1){
			return users[1];
		}
		return readUser(0);
	}
	
	public function deleteUser(instance,noFlush){
		return getGenericDAO().delete(argumentCollection=arguments);
	}
	
	public function deleteUserByID(id,noFlush){
		return getGenericDAO().deleteByID("User", arguments.id, arguments.noFlush);
	}
	
	public function countUsers(String whereClause, Any params){
		var args = {};
		args.entity = 'User';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		return getGenericDAO().count(argumentCollection=args);
	}
	
	public function listUsers(String whereClause, Any params, Struct options){
		var args = {};
		args.entity = 'User';
		if(structKeyExists(arguments, 'whereClause')) args.whereClause = arguments.whereClause;
		if(structKeyExists(arguments, 'params')) args.params = arguments.params;
		if(structKeyExists(arguments, 'options')){
			 args.queryOptions = arguments.options;
		}
		return getGenericDAO().list(argumentCollection=args);
	}
	
	public function getUserByUsername(username){
		var user = readUserByUsername(arguments.username);
		return getUserByUserID(user.getID());
	}
	
	public function getUserByUserID(userID){
		var users = listUsers('id = ?', [arguments.userID]);
		var tu = {};
		var user = arrayLen(users) ? users[1] : readUser(0);
		
		tu['__type__'] = 'com.slidesix.vo.users.User';
		tu.id = !isNull(user.getID()) ? user.getID() : 0;
		tu.firstName = user.getFirstName();
		tu.lastName = user.getLastName();
		tu.disqusShortName = user.getDisqusShortName();
		tu.username = user.getUsername();
		tu.password = user.getPassword();
		tu.email = user.getEmail();
		tu.isAdmin = user.getIsAdmin();
		tu.isArchived = user.getIsArchived();
		tu.dedicatedRoomPassword = user.getDedicatedRoomPassword();
		tu.bio = !isNull(user.getBio()) ? user.getBio() : '';
		tu.pathToImage = !isNull(user.getPathToImage()) ? user.getPathToImage() : '';
		tu.pathToImageThumb = !isNull(user.getPathToImageThumb()) ? user.getPathToImageThumb() : '';
		tu.isVerified = user.getIsVerified();
		tu.verifyKey = !isNull(user.getVerifyKey()) ? user.getVerifyKey() : '';
		tu.isSubscribed = user.getIsSubscribed();
		tu.lastLoggedInOn = !isNull(user.getLastLoggedInOn()) ? user.getLastLoggedInOn() : '';
		tu.createdOn = user.getCreatedOn();
		tu.updatedOn = user.getUpdatedOn();
		tu.isFeatured = user.getIsFeatured();
		
		return tu;
	}
	
	public string function saveUserImage(id,userImgUpload){
		isProfileOwner(arguments.id);
		var user = readUser(arguments.id);
		var userImgRoot = '/userFiles/' & user.getID() & '/';
		var storeRoot = getAppConfig().getConfigSetting('storageRootDir');
		var userImgDir = storeRoot & userImgRoot;

		if(!directoryExists(userImgDir)){
			getFileService().createDir(userImgDir);
		} 
		var fName = getUtils().getStrippedUUID();
		var userImgPath = userImgRoot & fName & '.jpg';
		var userThumbPath = userImgRoot & fName & '_thumb.jpg';
		
		var uploaded = getFileService().storeImage('userImgUpload', storeRoot, userImgPath, userThumbPath);
		
		var existingImg = storeRoot & user.getPathToImage();
		if(fileExists(existingImg)){
			getFileService().delete(existingImg);
		}
		var existingThumb = storeRoot & user.getPathToImageThumb();
		if(fileExists(existingThumb)){
			getFileService().delete(existingThumb);
		}
		var d = structNew();
		d.pathToImage = userImgPath;
		d.pathToImageThumb = userThumbPath;
		saveProfile(user.getID(), d);
		return userImgPath;
	}

	/**
    *@hint 'Remember, the dynamic list functionality requires that the dynamic properties are case sensitive!!'
    */
	public function onMissingMethod(missingMethodName, missingMethodArguments){
		return getGenericDAO().onMissingMethod(arguments.missingMethodName, arguments.missingMethodArguments);
	}
}
