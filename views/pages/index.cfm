<cfset msg = event.getValue("msg", "") />
<cfset recentSlideshows = event.getValue("recentSlideshows") />
<cfset countSlideshows = event.getValue("countSlideshows") />
<cfset recentUsers = event.getValue("recentUsers") />
<cfset recentGroups = event.getValue("recentGroups") />
<cfset myself = event.getValue("myself") />
<cfset config = event.getValue("config") />
<cfset storeRoot = config.getConfigSetting('storageRootDir') />
<cfset storeBase = config.getConfigSetting('storeBaseURL') />

<cfif len(trim(msg))>
	<cfoutput>
		<p>#msg#</p>
	</cfoutput>
</cfif>

<!---
<cfset u = event.getValue("currentUser")  />
<cfdump var="#event.getValue("isLoggedIn")#">
<cfdump var="#u#" expand="false">
<cfdump var="#session#">
--->

<div>
	<div class="float-left width-710-px">
		<cfoutput>
			<div class="pad-bottom-10">
				<h3>Recent Presentations</h3>
			</div>
			<cfset i = 0 />
			
        	<table id="recentPresoContainer">
				<cfloop array="#recentSlideshows#" index="p">
					<cfset i++ />
					<cfset padLeft = "pad-left-10" />
					<cfif (i+3) mod 4 eq 0>
						<tr>
						<cfset padLeft = "" />
					</cfif>
					
					<td class="width-170-px #padLeft# pad-right-10 center align-top">
						<cfset pLink = myself & "slideshow.view&slideshowid=" & p.getID() />
						
						<a href="#pLink#">
							<img src="#storeBase##p.getPathToThumb()#" alt="#p.getTitle()#" title="#p.getTitle()#" />
							<br />
							<span class="align-left">#p.getTitle()#</span>
						</a>
					</td>
					<cfif i mod 4 eq 0>
						</tr>
					</cfif>
				</cfloop>
			</table>
			<cfif countSlideshows gt arrayLen(recentSlideshows)>
				<div class="width-full align-right pad-10 font-20">
					<a href="#myself#slideshows.list&s=#arrayLen(recentSlideshows)+1#">More Presentations</a>
				</div>
			</cfif>
        </cfoutput>
	</div>
	<div class="float-left width-240-px">
		<cfoutput>
			<div class="pad-bottom-10">
				<h3>Newest Users</h3>
			</div>
        	<table id="recentUserContainer">
				<cfset i = 0 />
				<cfloop array="#recentUsers#" index="u">
					<cfset i++ />
					<cfif (i+3) mod 4 eq 0>
						<tr>
					</cfif>

					<cfset img = "/images/no_user_image_50.jpg" />

					<cfif fileExists(storeRoot & u.getPathToImageThumb())>
						<cfset img = storeBase & u.getPathToImageThumb() />
					</cfif>

					<td class="pad-left-5 pad-right-5 center align-top">
						<cfset uLink = myself & "user.view&userid=" & u.getID() />
						<a href="#uLink#">
							<img src="#img#" alt="#u.getFirstName()# #u.getLastName()# (#u.getUsername()#)" title="#u.getFirstName()# #u.getLastName()# (#u.getUsername()#)" />
						</a>
					</td>
					<cfif i mod 4 eq 0>
						</tr>
					</cfif>
				</cfloop>

			</table>
			
			<div class="pad-bottom-10">
				<h3>Newest Groups</h3>
			</div>
			
        	<table id="recentGroupContainer">
				<cfset i = 0 />
				<cfloop array="#recentGroups#" index="g">
					<cfset i++ />
					<cfif (i+3) mod 4 eq 0>
						<tr>
					</cfif>

					<cfset img = "/images/no_user_image_50.jpg" />

					<cfif fileExists(storeRoot & g.getPathToImageThumb())>
						<cfset img = storeBase & g.getPathToImageThumb() />
					</cfif>

					<td class="pad-left-5 pad-right-5 center align-top">
						<cfset gLink = myself & "group.view&groupid=" & g.getID() />
						<a href="#gLink#">
							<img src="#img#" alt="#g.getName()#" title="#g.getName()#" />
						</a>
					</td>
					<cfif i mod 4 eq 0>
						</tr>
					</cfif>
				</cfloop>
			</table>
        </cfoutput>
		
	</div>
	<div class="clear"></div>
</div>
