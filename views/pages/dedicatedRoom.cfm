<cfheader name="expires" value="#now()#"> 
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">

<cfset request.modelGlueSuppressDebugging = "true" />
<cfsetting showdebugoutput="false" />

<cfset myself = event.getValue("myself") />
<cfset room = event.getValue("room") />

<cfsavecontent variable="head">
<title><cfoutput>Dedicated Room (#room#)</cfoutput></title>
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
  id: "DedicatedRoom"
};
swfobject.embedSWF("/includes/flex/DedicatedRoom/DedicatedRoom.swf?room=#room#", "DedicatedRoom", "100%", "100%", "9.0.0", "/includes/flash/expressInstall.swf", flashvars, params, attributes);
</script>

<div class="center" id="DedicatedRoom">
	<br /><br /><br /><br /><br /><br /><br />
	<div id="wrap">	
		<h1>Looks Like There's a Problem...</h1>
		<div class="textBox center">It looks like you don't have the proper version of Adobe Flash Player installed or you don't have JavaScript enabled.
			<br /><br /><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a>
		</div>
	</div>
</div>
</cfoutput>
