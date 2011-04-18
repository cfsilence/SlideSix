/**
 * @hint I will validate the value passed to me matches the value of another property.
 */
component implements="IValidator" {

	public boolean function isValid(Struct prop){
		var valid = true;
		
		if(!structKeyExists(arguments.prop,"compareto")){
			valid = false;
		} else {		
			// By default we ignore case unless told not to
			if( structKeyExists(arguments.prop,"ignoreCase") ){				
				if( !arguments.prop.ignoreCase && compare(arguments.prop.value,arguments.prop.compareto) != 0){
					valid = false;
				}			
			} else {
				if(compareNoCase(arguments.prop.value,arguments.prop.compareto) != 0){
					valid = false;
				}
			}
		}
		return valid;
	}
}
