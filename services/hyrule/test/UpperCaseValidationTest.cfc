﻿component extends="mxunit.framework.TestCase" {

	public void function setup(){
		validator = new hyrule.rules.UpperCaseValidator();
	}
	
	public void function testUpperCaseReturnsTrue(){
		var prop = {value="COLDFUSION"};
		assertTrue(validator.isValid(prop));	
	}

	public void function testUpperCaseReturnsFalse(){
		var prop = {value="coldfusion"};
		assertFalse(validator.isValid(prop));
	}
	
	public void function testNotSimpleValueReturnsFalse(){
		var prop = {value=[]};
		assertFalse(validator.isValid(prop));		
	}
	
	public void function testBlankReturnsTrue(){
		var prop = {value=""};
		assertTrue(validator.isValid(prop));
	}

}