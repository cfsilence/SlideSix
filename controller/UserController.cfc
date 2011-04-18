component  extends='ModelGlue.gesture.controller.Controller' hint='i am a model-glue controller' output='false' beans='UserService, Hyrule'
{

	public  function init( framework)
	 hint='Constructor' output='false'{
		super.init(framework);
		return this;
	}
	
	public function onApplicationStart(event){
	}
	
	public function onSessionStart(event){
	}

	public function onSessionEnd(event){
	}
	
	public function onRequestStart(Any event){
		var e = arguments.event.getValue('event');
		var currentUserID = beans.UserService.getCurrentUserID();
		var currentUser = currentUserID != 0 ? beans.UserService.readUser(currentUserID) : 0;
		
		arguments.event.setValue('isLoggedIn', currentUserID != 0);
		arguments.event.setValue('currentUser', currentUser);
	}
	
	public function getIsAdmin(Any event){
		var currentUserID = beans.UserService.getCurrentUserID();
		var isAdmin = beans.UserService.isAdmin(currentUserID);
		if(!isAdmin){
			arguments.event.addResult('notAdmin');
		}
	}
	
	public function getIsNotLoggedIn(Any event){
		var loggedIn = event.getValue("isLoggedIn", false);
		if(loggedIn){
			arguments.event.setValue("msg", 'You must be logged out to access that page.');
			arguments.event.addResult('loggedIn');
		}
	}
	
	public function getIsLoggedIn(Any event){
		var loggedIn = event.getValue("isLoggedIn", false);
		if(!loggedIn){
			arguments.event.setValue("loginMsg", 'You must be logged in to access that page.');
			arguments.event.addResult('notLoggedIn');
		}
	}
	
	public function  getRegisterPage(Any event){
	}
	
	public function handleRegisterPage(Any event){
		var u = entityNew('User');
		u.populate(arguments.event.getAllValues());
		var result = beans.Hyrule.validate(u);
		arguments.event.setValue('userErrors', result);
		
		if(result.hasErrors()){
			arguments.event.addResult('failure');
		}
		else{
			beans.UserService.saveUser(u);
			beans.UserService.setCurrentUserID(u.getID());
			
			arguments.event.setValue('msg', 'User saved.  Email verification message sent to the email adress on file.');
			arguments.event.addResult('success');
		}
	}
	
	public function getVerifyUser(Any event){
		var uid = arguments.event.getValue('u');
		var vkey = arguments.event.getValue('v');
		var u = beans.UserService.readUser(uid);
		
		if(!len(uid) || !len(vkey) || isNull(u) || isNull(u.getVerifyKey())){
			arguments.event.forward('page.index');
		}
		 var d = structNew();
		 d.verifyKey = '';
		 d.isVerified = 1;
		 
		 arguments.event.setValue('msg', 'Account verified.');
		 beans.UserService.saveProfile(uid, d);			
	}
	
	public function sendVerifyEmail(Any event){
		var uid = arguments.event.getValue('u');
		var u = beans.UserService.readUser(uid);
		
		if(!len(uid) ||  isNull(u.getVerifyKey())){
			arguments.event.forward('page.index');
		}
		else if(u.getIsVerified()){
			arguments.event.setValue('msg', 'Email address is already verified.');
		}
		else{
			beans.UserService.sendVerificationEmail(u);
			arguments.event.setValue('msg', 'Verification email has been resent to the email address on file.');
		}
	}

		
	public function getResetPassword(Any event){
		var u = event.getValue('username');
		var user = beans.UserService.listUsers('username=?', [u]);
		
		if(arrayLen(user)){
			beans.UserService.sendPassword(user[1]);
			arguments.event.setValue('msg', 'A new password has been sent to the email address on file.');
			arguments.event.addResult('success');
		}
		else{
			arguments.event.addResult('failure');
		}
	}
    
	public function getLoginPage(Any event){
		var u = '';
	}
	
	public function handleLogin(Any event){
		var u = arguments.event.getValue('username');
		var p = hash(arguments.event.getValue('password'), 'md5');
		var success = false;
		var verified = true;
		var users = beans.UserService.listUsers('username=?', [u]);
		var user = arrayLen(users) ? users[1] : javacast('null', '');
		var loginMsg = 'Incorrect username or password, please try again';
		
		if(!len(u) || !len(p)){
			success = false;
		}

		if(!isNull(user) && !user.getIsVerified()){
			var link = 'http://#cgi.SERVER_NAME#/index.cfm?event=user.sendVerifyEmail&u=#user.getID()#';
			verified = false;
			loginMsg = 'You have not yet verified your account.  <a href="#link#">Resend verification email?</a>';
			success = false;
		}
		
		if(verified && len(u) && len(p)){
			success = beans.UserService.authenticateUser(u,p);
		}			
		
		if(!success){
			arguments.event.setValue('loginMsg', loginMsg);
			arguments.event.addResult('failure');
		}
		else{
			var to = structKeyExists(cookie, 'lastPage') && len(cookie.lastPage) ? cookie.lastPage : '/';
			location(url=to,addToken=false);
		}
	}
	
	public function handleLogout(){
		beans.UserService.logoutUser();
	}
    
    
    
}
