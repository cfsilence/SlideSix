<cfset g = event.getValue('group') />
<cfset myself = event.getValue('myself') />
<cfset errors = event.getValue("errors", arrayNew(1)) />

<h4>Edit User</h4>
<div>
	<cfoutput>
		<a href="#findNoCase('admin.groups',cgi.http_referer) ? cgi.http_referer : 'index.cfm?event=admin.groups'#">&lt;-- Back To Groups</a>
	</cfoutput>
</div>
<cfdump var="#errors#">

<div class="pad-top-10 pad-bottom-10">
	<cfoutput>
		<form id="editGroupForm" name="editGroupForm" action="#myself#admin.editGroupAction&id=#event.getValue('id')#" method="post">
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="firstName">Group Name</label>
				</div>
				<div class="width-full">
					<input type="text" id="name" name="name" value="#event.getValue('name', g.getName())#" class="width-400-px" />
				</div>
			</div>

			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="description">Description</label>
				</div>
				<div class="width-full">
					<textarea id="bio" name="description" class="width-400-px height-150-px">#event.getValue('description', g.getDescription())#</textarea>
				</div>
			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<input type="checkbox" id="autoAcceptMembers" name="autoAcceptMembers" value="true" <cfif event.getValue('autoAcceptMembers', g.getAutoAcceptMembers())>checked</cfif> />
					<label for="autoAcceptMembers">Auto approve group members?</label>
				</div>
			</div>
			<div class="width-full">
				<input type="submit" name="submit" id="submit" value="Save" /> 
			</div>
		</form>
	</cfoutput>
</div>
