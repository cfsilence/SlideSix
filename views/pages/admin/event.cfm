<cfset ev = event.getValue('ev') />
<cfset myself = event.getValue('myself') />
<cfset errors = event.getValue("errors", arrayNew(1)) />

<h4>Edit User</h4>
<div>
	<cfoutput>
		<a href="#findNoCase('admin.events',cgi.http_referer) ? cgi.http_referer : 'index.cfm?event=admin.events'#">&lt;-- Back To Events</a>
	</cfoutput>
</div>
<cfdump var="#errors#">
<cfdump var="#ev#">

<div class="pad-top-10 pad-bottom-10">
	<cfoutput>
		<form id="editEventForm" name="editEventForm" action="#myself#admin.editEventAction&id=#event.getValue('id')#" method="post">
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="firstName">Event Name</label>
				</div>
				<div class="width-full">
					<input type="text" id="name" name="name" value="#event.getValue('name', ev.getName())#" class="width-400-px" />
				</div>
			</div>

			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="description">Description Short</label>
				</div>
				<div class="width-full">
					<textarea id="descriptionShort" name="descriptionShort" class="width-400-px height-150-px">#event.getValue('descriptionShort', ev.getDescriptionShort())#</textarea>
				</div>

			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="description">Description Full</label>
				</div>
				<div class="width-full">
					<textarea id="descriptionFull" name="descriptionFull" class="width-400-px height-150-px">#event.getValue('descriptionFull', ev.getDescriptionFull())#</textarea>
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="startDate">Start Date</label>
				</div>
				<div class="width-full">
					<input type="text" id="startDate" name="startDate" value="#dateFormat(event.getValue('startDate', ev.getStartDate()), "mm/dd/yyyy")#" class="width-400-px" />
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="endDate">End Date</label>
				</div>
				<div class="width-full">
					<input type="text" id="endDate" name="endDate" value="#dateFormat(event.getValue('endDate', ev.getEndDate()), "mm/dd/yyyy")#" class="width-400-px" />
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="venue">Venue</label>
				</div>
				<div class="width-full">
					<textarea id="venue" name="venue" class="width-400-px height-150-px">#event.getValue('venue', ev.getVenue())#</textarea>
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="tracks">Tracks</label>
				</div>
				<div class="width-full">
					<textarea id="tracks" name="tracks" class="width-400-px height-150-px">#event.getValue('tracks', ev.getTracks())#</textarea>
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="costInfo">Cost Info</label>
				</div>
				<div class="width-full">
					<textarea id="costInfo" name="costInfo" class="width-400-px height-150-px">#event.getValue('costInfo', ev.getCostInfo())#</textarea>
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="organizerInfo">Organizer Info</label>
				</div>
				<div class="width-full">
					<textarea id="organizerInfo" name="organizerInfo" class="width-400-px height-150-px">#event.getValue('organizerInfo', ev.getOrganizerInfo())#</textarea>
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="externalHomepageURL">External Homepage</label>
				</div>
				<div class="width-full">
					<input type="text" id="externalHomepageURL" name="externalHomepageURL" value="#event.getValue('externalHomepageURL', ev.getExternalHomepageURL())#" class="width-400-px" />
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="rssURL">RSS Feed</label>
				</div>
				<div class="width-full">
					<input type="text" id="rssURL" name="rssURL" value="#event.getValue('rssURL', ev.getRSSURL())#" class="width-400-px" />
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="scheduleURL">Schedule URL</label>
				</div>
				<div class="width-full">
					<input type="text" id="scheduleURL" name="scheduleURL" value="#event.getValue('scheduleURL', ev.getScheduleURL())#" class="width-400-px" />
				</div>
			</div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="contactURL">Contact URL</label>
				</div>
				<div class="width-full">
					<input type="text" id="contactURL" name="contactURL" value="#event.getValue('contactURL', ev.getContactURL())#" class="width-400-px" />
				</div>
			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<input type="checkbox" id="autoAcceptMembers" name="autoAcceptMembers" value="true" <cfif event.getValue('autoAcceptMembers', ev.getAutoAcceptMembers())>checked</cfif> />
					<label for="autoAcceptMembers">Auto approve event members?</label>
				</div>
			</div>
			<div class="width-full">
				<input type="submit" name="submit" id="submit" value="Save" /> 
			</div>
		</form>
	</cfoutput>
</div>
