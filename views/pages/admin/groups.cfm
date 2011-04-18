<cfset groups = event.getValue('groups') />
<cfset pagination = event.getValue('pagination') />
<cfset totalGroups = event.getValue('totalGroups') />
<cfset myself = event.getValue('myself') />
<cfset msg = event.getValue('msg') />

<h4>Groups</h4>

<cfoutput>
	<cfif len(trim(msg))>
		<div class="msg pad-top-10 pad-bottom-10">#msg#</div>
	</cfif>
	<form id="searchGroupsForm" name="searchGroupForm" method="get" action="#myself#">
		<input type="hidden" name="event" id="event" value="admin.groups" />
		<div id="groupSearchContainer" class="pad-top-10 pad-bottom-10">
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
				<a href="#myself#admin.groups">(Clear Search)</a>
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
				<th colspan="3">Action</th>
			</tr>
			
			<cfloop array="#groups#" index="g">
				<tr>
					<td title="#g.getName()#">#left(g.getName(), 50)#</td>
					<td title="#g.getDescription()#">#left(g.getDescription(), 50)#</td>
					<td class="center"><a href="#myself#group.view&groupid=#g.getID()#">View</a></td>
					<td class="center"><a href="#myself#admin.editGroup&id=#g.getID()#">Edit</a></td>
					<td class="center"><a href="#myself#admin.deleteGroup&id=#g.getID()#">Delete</a></td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
</div>

<div class="pad-top-10">
	<cfoutput>#pagination.getRenderedHTML()#</cfoutput>
</div>
