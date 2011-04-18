/**
 * @hint I will validate that the property match the regular expression given a match flag.
 */
component implements="IValidator" {

	public boolean function isValid(Struct prop){
		return !reFindNoCase("[^[:alnum:]]",arguments.prop.value,1, "true").len[1];
	}

}
