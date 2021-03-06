﻿component extends="mxunit.framework.TestCase" {

	public void function setup(){
		validator = new hyrule.rules.ZipCodeValidator();
	}

	public void function testIsValidReturnsTrue(){
		var prop = {value="44113"};
		assertTrue(validator.isValid(prop));
	}

	public void function testIsValidReturnsFalse(){
		var prop = {value="abc1234"};
		assertFalse(validator.isValid(prop));
	}
	
	public void function testBlankReturnsTrue(){
		var prop = {value=""};
		assertTrue(validator.isValid(prop));
	}	

}
