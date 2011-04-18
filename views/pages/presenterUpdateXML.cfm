<cfset request.modelGlueSuppressDebugging = true />
<cfsetting showdebugoutput="false" />

<cfset version = event.getValue('currentVersion') />
<cfset dURL = event.getValue('downloadURL') />

<cfsavecontent variable="x"><cfoutput><?xml version="1.0" encoding="utf-8"?>
<update xmlns="http://ns.adobe.com/air/framework/update/description/1.0">
    <version>#version#</version>
    <url>#dURL#</url>
    <description><![CDATA[Present your material live and virtually.]]>
    </description>
</update>
</cfoutput>
</cfsavecontent>

<cfcontent type="text/xml"><cfoutput>#x#</cfoutput>