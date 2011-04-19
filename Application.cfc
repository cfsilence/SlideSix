component output="false"{
	//s3 settings (keeps them out of Git) remove this include if you don't need it
	include 'config/s3.cfm';
	
	this.name = 'slidesix_os';
	//orm settings
	this.ormenabled = true;
	this.datasource = 'slidesix_os';
	this.ormsettings = {dbcreate='update', dialect='MySQL', logsql='true', eventhandling='true', eventHandler="model.ORMEventHandler", sqlscript='db.sql'}; // 
	//mappings
	this.mappings['/hyrule'] = expandPath('/services/hyrule'); 
	this.mappings['/ModelGlue'] = expandPath('../frameworks/ModelGlue');
	this.mappings['/ColdSpring'] = expandPath('../frameworks/coldspring'); 
	this.mappings['/model'] = getDirectoryFromPath(getCurrentTemplatePath()) & 'model';
	this.customTagPaths = expandPath('/customTags');
	this.sessionManagement = true;
	this.clientManagement = true;
	this.clientStorage = 'cookie';
	
	//s3 settings
	this.s3.accessKeyid = variables.s3Access;
    this.s3.awsSecretKey = variables.s3Secret;
     
	public void function onApplicationStart(){
		
		//application specific settings stored in settings.cfm (see config/settings.template.cfm)
		include 'config/settings.cfm';
		
		if(!directoryExists(coldspringDefaults.virtualTempRoot)) directoryCreate(coldspringDefaults.virtualTempRoot);
		if(!directoryExists(coldspringDefaults.physicalTempRoot)) directoryCreate(coldspringDefaults.physicalTempRoot);
		
		application.defaults = coldspringDefaults;
		
		//create a struct used to store chat info for live broadcasting
		application.collaboration = {};
		
		application.factory = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init(defaultProperties=coldspringDefaults);
		application.factory.loadBeansFromXmlFile(expandPath("/config/ColdSpring.xml"),true); 
		
		application.cacheKey = '1';
		
		//mixin the cfexecute calls to start open office.  since there is no equivalent to <cfexecute> in script
		include 'applicationStart.cfm';
		
	}
	public void function onRequestStart(){
		if(structKeyExists(url, 'init')){
			ormReload();
			onApplicationStart();
		}
		if(!structKeyExists(url, 'method')) url.method = '';
		if(url.method != 'getInactivity'){
			session.lastHit = now();
		}
	}
	
	public void function onSessionStart(){
		request._modelglue.bootstrap.sessionStart = true;
		session.privateAccess = [];
	}
	
	/*public Any function onCFCRequest(String cfc, String methodName, Any methodArguments){
		if(arguments.methodName != 'getInactivity'){
			session.lastHit = now();
		}
		var comp = createObject("component", arguments.cfc);
		var res = evaluate("comp.#arguments.methodName#(argumentCollection=arguments.methodArguments)");
		if(!isNull(res)) return res;
	}*/
	
	public void function onSessionEnd(Any appScope, Any sessionScope){
		invokeSessionEvent("modelglue.onSessionEnd", arguments.sessionScope, appScope);
	}
	
	public any function invokeSessionEvent(String eventName, Any appScope, Any sessionScope){ 
		var mgInstances = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator").findInScope(appScope);
		var values = structNew();
		values.sessionScope = arguments.sessionScope;
		
		for(var i = 1; i <= arrayLen(mgInstances);  i++){
			mgInstances[i].executeEvent(arguments.eventName, values);		
		}
	}
	//public void function onError(Any e, Any f){}
}
