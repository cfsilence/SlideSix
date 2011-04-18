<cfset users = event.getValue('users') />
<cfset pagination = event.getValue('pagination') />
<cfset totalUsers = event.getValue('totalUsers') />
<cfset myself = event.getValue('myself') />
<cfset msg = event.getValue('msg') />

<h4>Users</h4>

<cfoutput>
	<cfif len(trim(msg))>
		<div class="msg pad-top-10 pad-bottom-10">#msg#</div>
	</cfif>
	<form id="searchUserForm" name="searchUserForm" method="get" action="#myself#">
		<input type="hidden" name="event" id="event" value="admin.users" />
		<div id="userSearchContainer" class="pad-top-10 pad-bottom-10">
			<div class="float-left pad-right-5">
				<label for="searchString">Search:</label>
				<input type="text" id="searchString" name="searchString" value="#event.getValue('searchString')#" />
			</div>
			<div class="float-left pad-left-5 pad-right-5">
				<label for="searchCol">in:</label>
				<select id="searchCol" name="searchCol">
					<option value="username" <cfif event.getValue('searchCol') eq 'username'>selected</cfif>>Username</option>
					<option value="firstName" <cfif event.getValue('searchCol') eq 'firstName'>selected</cfif>>First Name</option>
					<option value="lastName" <cfif event.getValue('searchCol') eq 'lastName'>selected</cfif>>Last Name</option>
				</select>
			</div>
			<div class="float-left pad-left-5 pad-right-5">
				<input type="submit" name="submit" value="Go" />
				<a href="#myself#admin.users">(Clear Search)</a>
			</div>
			<div class="clear"></div>
		</div>
	</form>
</cfoutput>
<div class="pad-top-10 pad-bottom-10">
	<cfoutput>
		<table class="blue-tbl width-full">
			<tr>
				<th>Username</th>
				<th>Name</th>
				<th>Bio</th>
				<th colspan="3">Action</th>
			</tr>
			<cfloop array="#users#" index="u">
				<tr>
					<td title="#u.getUsername()#">#left(u.getUsername(), 30)#</td>
					<td>#u.getFirstName()# #u.getLastName()#</td>
					<td title="#u.getBio()#">#left(u.getBio(), 30)#</td>
					<td class="center"><a href="#myself#user.view&userid=#u.getID()#">View</a></td>
					<td class="center"><a href="#myself#admin.editUser&id=#u.getID()#">Edit</a></td>
					<td class="center"><a href="#myself#admin.deleteUser&id=#u.getID()#">Delete</a></td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
</div>

<div class="pad-top-10">
	<cfoutput>#pagination.getRenderedHTML()#</cfoutput>
</div>
