<cfset users = event.getValue('users') />
<cfset countUsers = event.getValue('countUsers') />
<cfset myself = event.getValue('myself') />
<cfset event.setValue('needJquery', false) />
<cfset event.setValue('needJqueryUI', false) />
<cfset config = event.getValue("config") />
<cfset storeRoot = config.getConfigSetting('storageRootDir') />
<cfset storeBase = config.getConfigSetting('storeBaseURL') />
<cfset hasNext = event.getValue('hasNext') />
<cfset hasPrev = event.getValue('hasPrev') />
<cfset nextStart = event.getValue('nextStart') />
<cfset prevStart = event.getValue('prevStart') />

<cfdump var="#arrayLen(users)#" top=1 />
<cfdump var="#users#" top=1 expand="false" />

<cfoutput>
countUsers: #countUsers#<br/>
hasNext: #hasNext#<br/>
hasPrev: #hasPrev#<br/>
nextStart: #nextStart#<br/>
prevStart: #prevStart#<br/>
</cfoutput>