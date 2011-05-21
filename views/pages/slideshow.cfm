<cfset slideshow = event.getValue('slideshow') />
<cfset utils = event.getValue('utils') />
<cfset myself = event.getValue('myself') />
<cfset appConfig = event.getValue('AppConfig') />
<cfset currentUser = event.getValue('currentUser') />
<cfset event.setValue('needJquery', true) />
<cfset event.setValue('needJqueryUI', true) />
<cfset invalidPassword = viewstate.getValue("invalidPassword", false) />

<!---<cfdump var="#slideshow#" expand="false">--->

<!--- 
here's some javascript that can be used eventually somewhere to load a different slideshow on the fly

viewer = function(name){
    if(navigator.appName.indexOf('Microsoft') != -1){
        return window[name];
    }
    else{
        return document[name];
    }
};

viewer('PresentationViewer').loadSlideshow(41);

 --->
<cfoutput>
<cfif not len(slideshow.getPassword()) or arrayFind(session.privateAccess, trim(slideshow.getID())) or slideshow.getCreatedBy().getID() eq currentUser.getID()>
	<h2>#slideshow.getTitle()#</h2>
	
	<div class="margin-top-20 margin-bottom-20 width-full">
		<div class="float-left width-560-px">
			#slideshow.getEmbedCode()#
			<!--- disqus commenting ---> 
			
	    	<div id="disqus_thread"></div>
			<script type="text/javascript">
			    /* * * CONFIGURATION VARIABLES * * */
			    var disqus_shortname = '#len(trim(slideshow.getCreatedBy().getDisqusShortName())) ? trim(slideshow.getCreatedBy().getDisqusShortName()) : appConfig.getConfigSetting('disqusShortName')#';
			
			    // The following are highly recommended additional parameters. Remove the slashes in front to use.
			    var disqus_identifier = '#slideshow.getAlias()#';
			    var disqus_url = 'http://#cgi.server_name#/index.cfm?event=slideshow.view&slideshowid=#slideshow.getID()#';
				
				// Optional params
				var disqus_developer = #isDebugMode() ? 1 : 0#; 
				var disqus_title = '#slideshow.getTitle()#';
			    /* * * DON'T EDIT BELOW THIS LINE * * */
			    (function() {
			        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
			        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
			        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
			    })();
			</script>
			<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
			<a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>
		</div>
		<div class="float-left width-300-px pad-left-20 align-right">
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
			
			<table class="width-full">
				<tr>
					<td class="font-24 width-20 font-bold">Views</td>
					<td class="font-24 width-20 font-bold">Embedded Views</td>
					
				</tr>
				<tr>
					<td class="font-48 color-gray center">#val(slideshow.getNumViews())#</td>
					<td class="font-48 color-gray center">#val(slideshow.getNumEmbeddedViews())#</td>
				</tr>
				<tr>
					<td class="font-24 width-20">Rank</td>
					<td class="font-24 width-20">Favorites</td>
				</tr>
				<tr>
					<td class="font-48 color-gray center">#val(slideshow.getAvgRank())#</td>
					<td class="font-48 color-gray center">#val(slideshow.getNumFavorites())#</td>
				</tr>
			</table>
		</div>
		
		<div class="clear"></div>
	</div>
		
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

