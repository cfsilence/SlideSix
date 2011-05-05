<cfset title = event.getValue('title', '') />
<cf_layout 
	pathToSiteRoot="" 
	cacheKey="#application.cacheKey#" 
	isLoggedIn="#event.getValue("isLoggedIn")#" 
	needJQuery="#event.getValue("needJQuery", false)#" 
	needJQueryUI="#event.getValue("needJQueryUI", false)#" 
	currentUser="#event.getValue("currentUser")#" 
	searchEnabled="#event.getValue("AppConfig").getConfigSetting('isSearchEnabled')#" 
	title="#title#">
	<cfoutput>#viewCollection.getView("body")#</cfoutput>
</cf_layout>