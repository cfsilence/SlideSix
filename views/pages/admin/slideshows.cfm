<cfset slideshows = event.getValue('slideshows') />
<cfset pagination = event.getValue('pagination') />
<cfset totalSlideshows = event.getValue('totalSlideshows') />
<cfset myself = event.getValue('myself') />
<cfset msg = event.getValue('msg') />

<h4>Slideshows</h4>

<cfoutput>
	<cfif len(trim(msg))>
		<div class="msg pad-top-10 pad-bottom-10">#msg#</div>
	</cfif>
	<form id="searchSlideshowForm" name="searchSlideshowForm" method="get" action="#myself#">
		<input type="hidden" name="event" id="event" value="admin.slideshows" />
		<div id="slideshowSearchContainer" class="pad-top-10 pad-bottom-10">
			<div class="float-left pad-right-5">
				<label for="searchString">Search:</label>
				<input type="text" id="searchString" name="searchString" value="#event.getValue('searchString')#" />
			</div>
			<div class="float-left pad-left-5 pad-right-5">
				<label for="searchCol">in:</label>
				<select id="searchCol" name="searchCol">
					<option value="title" <cfif event.getValue('searchCol') eq 'title'>selected</cfif>>Title</option>
					<option value="abstract" <cfif event.getValue('searchCol') eq 'abstract'>selected</cfif>>Description</option>
				</select>
			</div>
			<div class="float-left pad-left-5 pad-right-5">
				<input type="submit" name="submit" value="Go" />
				<a href="#myself#admin.slideshows">(Clear Search)</a>
			</div>
			<div class="clear"></div>
		</div>
	</form>
</cfoutput>
<div class="pad-top-10 pad-bottom-10">
	<cfoutput>
		<table class="blue-tbl width-full">
			<tr>
				<th>Title</th>
				<th>Description</th>
				<th>Private</th>
				<th>Created By</th>
				<th colspan="3">Action</th>
			</tr>
			<cfloop array="#slideshows#" index="s">
				<tr>
					<td title="#s.getTitle()#">#left(s.getTitle(), 30)#</td>
					<td title="#s.getAbstract()#">#left(s.getAbstract(), 30)#</td>
					<td>#yesNoFormat(len(trim(s.getPassword())))#</td>
					<td><a href="#myself#user.view&id=#s.getCreatedBy().getID()#">#s.getCreatedBy().getFirstName()# #s.getCreatedBy().getLastName()#</a></td>
					<td class="center"><a href="#myself#slideshow.view&slideshowid=#s.getID()#">View</a></td>
					<td class="center"><a href="#myself#admin.editSlideshow&id=#s.getID()#">Edit</a></td>
					<td class="center"><a href="#myself#admin.deleteSlideshow&id=#s.getID()#">Delete</a></td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
</div>

<div class="pad-top-10">
	<cfoutput>#pagination.getRenderedHTML()#</cfoutput>
</div>
