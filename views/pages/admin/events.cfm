<cfset events = event.getValue('events') />
<cfset pagination = event.getValue('pagination') />
<cfset totalEvents = event.getValue('totalEvents') />
<cfset myself = event.getValue('myself') />
<cfset msg = event.getValue('msg') />

<h4>Events</h4>

<cfoutput>
	<cfif len(trim(msg))>
		<div class="msg pad-top-10 pad-bottom-10">#msg#</div>
	</cfif>
	<form id="searchEventsForm" name="searchEventForm" method="get" action="#myself#">
		<input type="hidden" name="event" id="event" value="admin.events" />
		<div id="eventSearchContainer" class="pad-top-10 pad-bottom-10">
			<div class="float-left pad-right-5">
				<label for="searchString">Search:</label>
				<input type="text" id="searchString" name="searchString" value="#event.getValue('searchString')#" />
			</div>
			<div class="float-left pad-left-5 pad-right-5">
				<label for="searchCol">in:</label>
				<select id="searchCol" name="searchCol">
					<option value="name" <cfif event.getValue('searchCol') eq 'name'>selected</cfif>>Name</option>
					<option value="description" <cfif event.getValue('searchCol') eq 'description'>selected</cfif>>Description</option>
				</select>
			</div>
			<div class="float-left pad-left-5 pad-right-5">
				<input type="submit" name="submit" value="Go" />
				<a href="#myself#admin.events">(Clear Search)</a>
			</div>
			<div class="clear"></div>
		</div>
	</form>
</cfoutput>
<div class="pad-top-10 pad-bottom-10">
	<cfoutput>
		<table class="blue-tbl width-full">
			<tr>
				<th>Name</th>
				<th>Description</th>
				<th colspan="4">Action</th>
			</tr>
			
			<cfloop array="#events#" index="e">
				<tr>
					<td title="#e.getName()#">#left(e.getName(), 50)#</td>
					<td title="#e.getDescriptionShort()#">#left(e.getDescriptionShort(), 50)#</td>
					<td class="center"><a href="#myself#event.view&eventid=#e.getID()#">View</a></td>
					<td class="center"><a href="#myself#admin.feature&id=#e.getID()#&type=event&isFeatured=#!e.getIsFeatured()#"><cfif e.getIsFeatured()>Remove </cfif>Feature</a></td>
					<td class="center"><a href="#myself#admin.editEvent&id=#e.getID()#">Edit</a></td>
					<td class="center"><a href="#myself#admin.deleteEvent&id=#e.getID()#">Delete</a></td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
</div>

<div class="pad-top-10">
	<cfoutput>#pagination.getRenderedHTML()#</cfoutput>
</div>
