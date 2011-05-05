<cfset slidesixSlideshows = event.getValue('slidesixSlideshows') />
<cfset importedSlideshows = event.getValue('importedSlideshows') />
<cfset importedTitle = event.getValue('importedTitle') />
<cfset config = event.getValue('config') />
<cfset myself = event.getValue('myself') />
<cfset columns = slidesixSlideshows.columns />
<cfset data = slidesixSlideshows.data />
<cfset storeRoot = config.getConfigSetting('storageRootDir') />
<cfset storeBase = config.getConfigSetting('storeBaseURL') />

<cfdump var="#importedSlideshows#" expand="false" top="1" />
<cfdump var="#slidesixSlideshows#" expand="false" />

<div class="">
	<cfif len(trim(importedTitle))>
		<cfoutput><h4>Import of '#importedTitle#' has been queued.</h4></cfoutput>
	</cfif>	
	<div class="float-left width-600-px pad-right-20">
		<h3>SlideSix Presentations</h3>
		<table>
			<cfoutput>
            	<cfloop array="#data#" index="pendingImportSlideshows">
					<cfset imported = false />
					<cfset importedID = arrayFindNoCase(columns, 'slideshowid') />
					<cfloop array="#importedSlideshows#" index="slideshow">
						<cfif trim(slideshow.getImportedID()) eq trim(pendingImportSlideshows[importedID])>
							<cfset imported = true />
							<cfbreak />
						</cfif> 
					</cfloop>
					<cfif !imported>
						<cfset title = arrayFindNoCase(columns, 'slideshowtitle') />
						<cfset thumb = arrayFindNoCase(columns, 'thumbnailimageurl') />
						<cfset ssid = arrayFindNoCase(columns, 'slideshowid') />
						<cfset alias = arrayFindNoCase(columns, 'alias') />
						<cfset lastPublishedDate = arrayFindNoCase(columns, 'lastPublishedDate') />
						<tr>
							<td><image src="#pendingImportSlideshows[thumb]#" alt="#pendingImportSlideshows[title]#" /></td>
							<td>
								<h4>#pendingImportSlideshows[title]#</h4>
								<p>Published on: #dateFormat(pendingImportSlideshows[lastPublishedDate], "mm/dd/yyyy")#</p>
								<a href="#myself#page.importslidesixslideshow&alias=#pendingImportSlideshows[alias]#">Import</a>
							</td>
						</tr>			
					</cfif>
				</cfloop>
            </cfoutput>	
		</table>
	</div>
	<div class="float-left">
		<h3>Imported Presentations</h3>
		<table>
			<cfoutput>
				<cfset idx = 0 />
            	<cfloop array="#importedSlideshows#" index="slideshow">
					<cfset idx++ />
					<cfif (idx+1) mod 2 eq 0><tr></cfif>
						<td class="width-160-px">
							<cfset pLink = myself & "slideshow.view&slideshowid=" & slideshow.getID() />
							<a href="#pLink#">
								<img src="#storeBase##slideshow.getPathToThumb()#" alt="#slideshow.getTitle()#" title="#slideshow.getTitle()#" />
								<br />
								<span class="align-left">#slideshow.getTitle()#</span>
							</a>
						</td>					
					<cfif idx mod 2 eq 0></tr></cfif>
				</cfloop>
            </cfoutput>
		</table>
	</div>
	<div class="clear"></div>
</div>