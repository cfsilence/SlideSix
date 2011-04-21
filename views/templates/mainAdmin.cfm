<cfset title = event.getValue('title', '') />
<cfset isLoggedIn = event.getValue("isLoggedIn") />
<cfset currentUser = event.getValue("currentUser") />

<cf_layout 
	pathToSiteRoot="" 
	cacheKey="#application.cacheKey#" 
	isLoggedIn="#isLoggedIn#" 
	needJQuery="#event.getValue("needJQuery", false)#" 
	needJQueryUI="#event.getValue("needJQueryUI", false)#" 
	currentUser="#currentUser#" 
	title="#title#">
	<cfoutput>#viewCollection.getView("body")#</cfoutput>
	<div id="nav">
		<div class="wrap">
			<cfif isLoggedIn and currentUser.getIsAdmin()>
				<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
					<a href="index.cfm?event=admin.slideshows">SlideShow Admin</a>
				</div>
				<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
					<a href="index.cfm?event=admin.users">User Admin</a>
				</div>
				<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
					<a href="index.cfm?event=admin.groups">Groups Admin</a>
				</div>
			</cfif>
			
			<div class="clear"></div>
		</div>
	</div>
</div>
</cf_layout>