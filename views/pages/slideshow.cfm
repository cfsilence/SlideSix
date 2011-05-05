<cfset slideshow = event.getValue('slideshow') />
<cfset utils = event.getValue('utils') />
<cfset myself = event.getValue('myself') />
<cfset currentUser = event.getValue('currentUser') />
<cfset event.setValue('needJquery', true) />
<cfset event.setValue('needJqueryUI', true) />
<cfset invalidPassword = viewstate.getValue("invalidPassword", false) />

<cfdump var="#slideshow#" expand="false">

<cfoutput>
<cfif not len(slideshow.getPassword()) or arrayFind(session.privateAccess, trim(slideshow.getID())) or slideshow.getCreatedBy().getID() eq currentUser.getID()>
	<h2>#slideshow.getTitle()#</h2>
	
	<div class="margin-top-20 margin-bottom-20 width-full">
		<div class="float-left">
			#slideshow.getEmbedCode()#
		</div>
		<div class="float-left width-380-px pad-left-20 align-right">
			<div>
				<h4>about:</h4>
				<div>
					#utils.paragraphFormat2(slideshow.getAbstract())#
				</div>
			</div>
			<div class="pad-top-10">
				<h4>created by:</h4>
				<div>
					<cfset createdBy = slideshow.getCreatedBy() /> 
					<a href="#myself#user.view&id=#createdBy.getID()#">
						#createdBy.getFirstName()# #createdBy.getLastName()#
					</a>
				</div>
			</div>
			<div class="pad-top-10">
				<h4>created on:</h4>
				<div>
					#dateFormat(slideshow.getCreatedOn(), "mm/dd/yyyy")#
				</div>
			</div>
		</div>
		
		<div class="clear"></div>
	</div>
	
	<table class="width-full">
		<tr>
			<th class="font-24 width-20">Views</th>
			<th class="font-24 width-20">Embedded Views</th>
			<th class="font-24 width-20">Rank</th>
			<th class="font-24 width-20">Favorites</th>
			<th class="font-24 width-20">Comments</th>
		</tr>
		<tr>
			<td class="font-48 color-gray center">#val(slideshow.getNumViews())#</td>
			<td class="font-48 color-gray center">#val(slideshow.getNumEmbeddedViews())#</td>
			<td class="font-48 color-gray center">#val(slideshow.getAvgRank())#</td>
			<td class="font-48 color-gray center">#val(slideshow.getNumFavorites())#</td>
			<td class="font-48 color-gray center">#val(slideshow.getNumComments())#</td>
		</tr>
	</table>	
<cfelse>
	<form name="privateSlideShowForm" method="post" action="#myself#slideshow.access&slideshowid=#slideshow.getID()#" class="uniForm" target="_self">
		<cfif invalidPassword>
			<div id="errorMsg">
				<h3>Ooops!  The following error(s) must be addressed!</h3>
				<ol>
					<li>Invalid Password</li>
				</ol>
			</div>
		</cfif>
		<div>
			<div class="pad-bottom-20">
				<h4>Please enter a password to view this presentation.</h4>
			</div>
			
			<div class="float-left width-100-px pad-top-10">
				<label for="slideshowPassword">Password</label>
			</div>
			<div class="float-left">
		       	<input type="password" name="password" id="password" class="textInput" value="" />
	        </div>
			<div class="clear"></div>
		</div>
		<div>
			<div class="float-left width-100-px">
				<label for="submit">&nbsp;</label>
			</div>
			<div class="float-left">
		       	<input type="submit" name="submit" value="Submit" class="submitButton" />
	        </div>
			<div class="clear"></div>
		</div>
	</form>
</cfif>

</cfoutput>

