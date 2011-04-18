component hint="i am the remote user service" output="false"
{
	
	public function getComponent(){
		return application.factory.getBean('UserService');
	}
	
	remote function authenticateUser(u,p){
		return getComponent().authenticateUser(argumentCollection=arguments);
	}
	
	remote function saveProfile(id, data){
		getComponent().checkProfileOwner(arguments.id);
		return getComponent().saveProfile(argumentCollection=arguments);
	}
	
	remote function getUserByUsername(username){
		getComponent().checkProfileOwnerByUsername(arguments.username);
		return getComponent().getUserByUsername(argumentCollection=arguments);
	}
	
	public function readUser(id){
		return getComponent().readUser(arguments.id);
	}
	
	remote function deleteUserByID(id,noFlush){
		getComponent().checkProfileOwner(arguments.id);
		return getComponent().deleteUserByID(argumentCollection=arguments);
	}
	
	remote function listUsers(String whereClause, Array params){
		return getComponent().listUsers(argumentCollection=arguments);
	}
	
	remote string function saveUserImage(id,userImgUpload){
		return getComponent().saveUserImage(argumentCollection=arguments);
	}
}
