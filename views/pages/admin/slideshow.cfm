<cfset s = event.getValue('slideshow') />
<cfset myself = event.getValue('myself') />
<cfset errors = event.getValue("errors", arrayNew(1)) />

<h4>Edit Slideshow</h4>
<div>
	<cfoutput>
		<a href="#findNoCase('admin.slideshows',cgi.http_referer) ? cgi.http_referer : 'index.cfm?event=admin.slideshows'#">&lt;-- Back To Slideshows</a>
	</cfoutput>
</div>
<cfdump var="#errors#">

<div class="pad-top-10 pad-bottom-10">
	<cfoutput>
		<form id="editSlideshowForm" name="editSlideshowForm" action="#myself#admin.editSlideshowAction&id=#event.getValue('id')#" method="post">
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="title">Title</label>
				</div>
				<div class="width-full">
					<input type="text" id="title" name="title" value="#event.getValue('title', s.getTitle())#" class="width-400-px" />
				</div>
			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="abstract">Description</label>
				</div>
				<div class="width-full">
					<textarea id="abstract" name="abstract" class="width-400-px height-150-px">#event.getValue('abstract', s.getAbstract())#</textarea>
				</div>
			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="tags">Tags</label>
				</div>
				<div class="width-full">
					<input type="text" id="tags" name="tags" value="#event.getValue('tags', s.getTagList())#" class="width-400-px" />
				</div>
			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="groupID">Group</label>
				</div>
				<div class="width-full">
					<select id="groupID" name="groupID">
						<cfset groupID = isNull(s.getGroup()) ? 0 : s.getGroup().getID() />
						<option value="" <cfif groupID eq 0>selected</cfif>></option>
						<cfloop array="#s.getCreatedBy().getGroupMemberships()#" index="g">
							<option value="#g.getGroup().getID()#" <cfif groupID eq g.getGroup().getID()>selected</cfif> >#g.getGroup().getName()#</option>
						</cfloop>
					</select>
				</div>
			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="password"><cfif len(trim(s.getPassword()))>New </cfif>Password (currently <cfif not len(trim(s.getPassword()))><em>not</em></cfif> private)</label>
				</div>
				<div class="width-full">
					<input type="password" id="password" name="password" value="#event.getValue('password', '')#" class="width-400-px" />
				</div>
			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<label for="confirmPassword">Confirm Password</label>
				</div>
				<div class="width-full">
					<input type="password" id="confirmPassword" name="confirmPassword" value="#event.getValue('confirmPassword', '')#" class="width-400-px" />
				</div>
			</div>
			<cfif len(trim(s.getPassword()))>
				<div class="width-full pad-top-5 pad-bottom-5">
					<div class="">
						<input type="checkbox" id="removePassword" name="removePassword" value="true" <cfif event.getValue('removePassword', false)>checked</cfif> />
						<label for="removePassword">Remove Password? (Will make public)</label>
					</div>
				</div>
			</cfif>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<input type="checkbox" id="allowComments" name="allowComments" value="true" <cfif event.getValue('allowComments', s.getAllowComments())>checked</cfif> />
					<label for="allowComments">Allow Comments?</label>
				</div>
			</div>
			<div class="width-full pad-top-5 pad-bottom-5">
				<div class="">
					<input type="checkbox" id="notifyComments" name="notifyComments" value="true" <cfif event.getValue('notifyComments', s.getNotifyComments())>checked</cfif> />
					<label for="notifyComments">Notify Author of Comments?</label>
				</div>
			</div>
			<div class="width-full">
				<input type="submit" name="submit" id="submit" value="Save" /> 
			</div>
		</form>
	</cfoutput>
</div>
