component implements='hyrule.rules.IValidator' {

    public boolean function isValid(Struct prop){
        var valid = true;
        var us = application.factory.getBean('UserService');
		var users = [];
		
		if(structKeyExists(prop, 'Value') and len(trim(prop.value))){
			users = us.listUsers('username=?', [prop.value]);
		}

        // database lookup to see if its valid. returns true if username is found
        if(arrayLen(users)){
            valid = false;
        }

        return valid;
    }

    public string function getMessage(Struct prop,String message){
        return 'That username already exists in our system. Please choose another username.';
    }

}
