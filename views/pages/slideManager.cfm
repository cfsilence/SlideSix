<cfheader name="expires" value="#now()#"> 
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">

<cfset request.modelGlueSuppressDebugging = "true" />
<cfsetting showdebugoutput="false" />

<cfset myself = event.getValue("myself") />
<cfset youtubeAPIID = event.getValue("youtubeAPIID") />
<cfset upload = event.getValue("upload", false)>

<cfsavecontent variable="head">
<title>Management Console</title>
<style>
body{
	margin: 0;
}
</style>
</cfsavecontent>
<cfhtmlhead text="#head#" />

<script type="text/javascript" src="/includes/js/swfobject/swfobject.js"></script>

<cfoutput>
<script type="text/javascript">
var flashvars = {};
var params = {
  menu: "false",
  allowScriptAccess: "always",
  scale: "noscale"
};
var attributes = {
  id: "SlideManager"
};
swfobject.embedSWF("/includes/flex/SlideManager/SlideManager.swf?enablejsapi=true&playerapiid=&#session.URLToken#&upload=#upload#", "slideMgr", "100%", "100%", "9.0.0", "/includes/flash/expressInstall.swf", flashvars, params, attributes);

//init the youTubeLoader JavaScript methods
SWFID = "SlideManager"
</script>

<div class="center" id="slideMgr">
	<br /><br /><br /><br /><br /><br /><br />
	<div id="wrap">	
		<h1>Looks Like There's a Problem...</h1>
		<div class="textBox center">We'd really love for you to check out our management console, but it looks like you don't have the proper version of Adobe Flash Player installed or you don't have JavaScript enabled.
			<br /><br /><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a>
		</div>
	</div>
</div>
</cfoutput>
