<cfset u = event.getValue('user') />
<cfset myself = event.getValue('myself') />
<cfset errors = event.getValue("errors", arrayNew(1)) />

<h4>Edit User</h4>
<div>
	<cfoutput>
		<a href="#findNoCase('admin.users',cgi.http_referer) ? cgi.http_referer : 'index.cfm?event=admin.users'#">&lt;-- Back To Users</a>
	</cfoutput>
</div>
<cfdump var="#errors#">

<div class="pad-top-10 pad-bottom-10">
	<cfoutput>
		<form id="editUserForm" name="editUserForm" action="#myself#admin.editUserAction&id=#event.getValue('id')#" method="post">
			<div class="width-50 float-left pad-top-5 pad-bottom-5">
				<div class="">
					<label for="firstName">First Name</label>
				</div>
				<div class="width-full">
					<input type="text" id="firstName" name="firstName" value="#event.getValue('firstName', u.getFirstName())#" class="width-400-px" />
				</div>
			</div>
			<div class="width-50 float-left pad-top-5 pad-bottom-5">
				<div class="">
					<label for="lastName">Last Name</label>
				</div>
				<div class="width-full">
					<input type="text" id="lastName" name="lastName" value="#event.getValue('lastName', u.getLastName())#" class="width-400-px" />
				</div>
			</div>
			<div class="clear"></div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="email">Email Address</label>
				</div>
				<div class="width-full">
					<input type="text" id="email" name="email" value="#event.getValue('email', u.getEmail())#" class="width-400-px" />
				</div>
			</div>
			
			<div class="width-50 float-left pad-top-5 pad-bottom-5">
				<div class="">
					<label for="password">Password (leave blank to remain unchanged)</label>
				</div>
				<div class="width-full">
					<input type="password" id="password" name="password" value="#event.getValue('password', '')#" class="width-400-px" />
				</div>
			</div>
			<div class="width-50 float-left pad-top-5 pad-bottom-5">
				<div class="">
					<label for="confirmPassword">Confirm Password</label>
				</div>
				<div class="width-full">
					<input type="password" id="confirmPassword" name="confirmPassword" value="#event.getValue('confirmPassword', '')#" class="width-400-px" />
				</div>
			</div>
			<div class="clear"></div>
			
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="abstract">Bio</label>
				</div>
				<div class="width-full">
					<textarea id="bio" name="bio" class="width-400-px height-150-px">#event.getValue('bio', u.getBio())#</textarea>
				</div>
			</div>
			
			<!---<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="groupID">Group</label>
				</div>
				<div class="width-full">
					<select id="groupID" name="groupID">
						<cfset groupID = isNull(u.getGroup()) ? 0 : u.getGroup().getID() />
						<option value="" <cfif groupID eq 0>selected</cfif>></option>
						<cfloop array="#u.getCreatedBy().getGroupMemberships()#" index="g">
							<option value="#g.getGroup().getID()#" <cfif groupID eq g.getGroup().getID()>selected</cfif> >#g.getGroup().getName()#</option>
						</cfloop>
					</select>
				</div>
			</div>--->
			
			<div class="width-50 float-left pad-top-5 pad-bottom-5">
				<div class="">
					<label for="dedicatedRoomPassword"><cfif len(trim(u.getDedicatedRoomPassword()))>New </cfif>Dedicated Room Password</label>
				</div>
				<div class="width-full">
					<input type="password" id="dedicatedRoomPassword" name="dedicatedRoomPassword" value="#event.getValue('dedicatedRoomPassword', '')#" class="width-400-px" />
				</div>
			</div>
			<div class="width-50 float-left pad-top-5 pad-bottom-5">
				<div class="">
					<label for="confirmDedicatedRoomPassword">Confirm Dedicated Room Password</label>
				</div>
				<div class="width-full">
					<input type="password" id="confirmDedicatedRoomPassword" name="confirmDedicatedRoomPassword" value="#event.getValue('confirmDedicatedRoomPassword', '')#" class="width-400-px" />
				</div>
			</div>
			<div class="clear"></div>
			<cfif len(trim(u.getDedicatedRoomPassword()))>
				<div class="width-full pad-top-5 pad-bottom-5">
					<div class="">
						<input type="checkbox" id="removeDedicatedRoomPassword" name="removeDedicatedRoomPassword" value="true" <cfif event.getValue('removeDedicatedRoomPassword', false)>checked</cfif> />
						<label for="removeDedicatedRoomPassword">Remove Dedicated Room Password? (Will make public)</label>
					</div>
				</div>
			</cfif>
			<!---<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<input type="checkbox" id="notifyComments" name="notifyComments" value="true" <cfif event.getValue('notifyComments', u.getNotifyComments())>checked</cfif> />
					<label for="notifyComments">Notify Author of Comments?</label>
				</div>
			</div>--->
			<div class="width-full">
				<input type="submit" name="submit" id="submit" value="Save" /> 
			</div>
		</form>
	</cfoutput>
</div>
