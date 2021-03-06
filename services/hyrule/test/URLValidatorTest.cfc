﻿component extends="mxunit.framework.TestCase" {

	public void function setup(){
		validator = new hyrule.rules.URLValidator();
	}

	public void function testIsValidReturnsTrue(){
		var prop = {value="http://www.google.com"};
		assertTrue(validator.isValid(prop));
	}

	public void function testIsValidReturnsFalse(){
		var prop = {value="www.abc"};
		assertFalse(validator.isValid(prop));
	}

	public void function testBlankReturnsTrue(){
		var prop = {value=""};
		assertTrue(validator.isValid(prop));
	}
	
}