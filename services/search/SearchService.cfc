<cfcomponent displayname="SearchService" accessors="true">
	<cfproperty name="AppConfig" displayname="AppConfig" />
	<cfproperty name="Utils" displayname="Utils" />
	<cfproperty name="SlideshowService" displayname="SlideshowService" />

	<cffunction name="init">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="index" access="public" output="false">
		<cfargument name="attCollection" required="true" type="struct" />
		<cfset var collection = getAppConfig().getConfigSetting('searchCollectionName') />
		<cfset var isSearchEnabled = getAppConfig().getConfigSetting('isSearchEnabled') />
		<cfif isSearchEnabled>
			<cfif not getUtils().isInCFThread()>
				<cfthread action="run" name="#getUtils().getStrippedUUID()#" att="#arguments.attCollection#" collection="#collection#">
					<cfindex collection="#attributes.collection#" attributecollection="#attributes.att#" />
				</cfthread>
			<cfelse>
				<!--- we may have been called from another thread and we can not nest them --->
				<cfindex collection="#collection#" attributecollection="#arguments.attCollection#" />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="search" access="public" output="false">
		<cfargument name="criteria" required="false" type="string" default="" />
		<cfargument name="sRow" required="false" default="1" />
		<cfargument name="pageSize" required="false" default="10" />
		<cfset var ret = {} />
		<cfset ret.meta = {} />
		<cfset ret.slideshows = [] />
		<cfset var collection = getAppConfig().getConfigSetting('searchCollectionName') />
		<cfset var isSearchEnabled = getAppConfig().getConfigSetting('isSearchEnabled') />
		<cfset var results = queryNew("") />
		<cfset var q = "" />
		<cfset var whereClause = "1=1" />
		<cfset var params = {} />
		<cfset var orderBy = ' ORDER BY createdOn desc' />
		<cfset var start = fix(val(REReplace(arguments.sRow,"[^/.0123456789-]","","all"))) />
		<cfset var keys = "" />
		
		<cfset start = start eq 0 ? start : start - 1 />
		
		<cfif isSearchEnabled and len(trim(arguments.criteria))>
			<cfsearch collection="#collection#" name="results" criteria="#arguments.criteria#" suggestions="always" />
			<cfset ret.meta.totalRecords = results.recordCount />
			<cfset whereClause = 'ID IN (:idList)' />
			<cfset keys = valueList(results.key) />
			<cfset params = {idList=listToArray(keys)} />
		</cfif>
		
		<cfif not len(trim(arguments.criteria))>
			<cfset ret.meta.totalRecords = getSlideshowService().countSlideshows() />
		</cfif>
		
		<cfset var maxRecords = len(trim(arguments.pageSize)) && isNumeric(val(arguments.pageSize)) ? arguments.pageSize : results.recordCount />
		
		<cfif len(trim(keys))>
			<cfset ret.slideshows = getSlideshowService().listSlideshows(whereClause & orderBy, params, {maxresults=maxRecords, offset=start}) />
			<cfif !arrayLen(ret.slideshows)><!--- if somehow a record got 'stranded' in Solr --->
				<cfset ret.meta.totalRecords = 0 />
			</cfif>
		</cfif>
		
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="moreLikeThis" output="false" access="public" returnType="query">
		<cfargument name="searchString" required="true" />
		<cfargument name="collectionName" required="false" default="#getAppConfig().getConfigSetting('searchCollectionName')#" />
		<cfargument name="searchFields" required="false" default="title,body,summary" />
		<cfargument name="host" required="false" default="localhost" />
		<cfargument name="port" required="false" default="8983" />
		<cfset var mltURL = "http://" & arguments.host & ":" & arguments.port & "/solr/" & arguments.collectionName & "/select?q= " & urlEncodedFormat(arguments.searchString) & " &mlt=true&mlt.fl=" & arguments.searchFields />
		<cfset var r = "" />
		<cfset var q = queryNew("author,custom1,custom2,custom3,custom4,key,modified,summary,title,uid,url") />
		<cfset var i = "" />
		<cfset var c = "" />
		
		<cfhttp method="GET" url="#mltURL#" result="r" />
		
		<cfif r.statusCode eq "200 OK">
			<cfset var mlt = xmlParse(r.fileContent) />
			<cfset var resultCount = val(xmlSearch(mlt, "string(//result/@numFound)")) />
			
			<cfif resultCount>
				<cfset queryAddRow(q,resultCount) />
				
				<cfloop from="1" to="#resultCount#" index="i">
					<cfset var cols = xmlSearch(mlt, "//result/doc[#i#]/str/") />
					<cfloop list="#q.columnList#" index="c">
						<cfset querySetCell(q,c,xmlSearch(mlt, "string(//result/doc[#i#]/str[@name='#lcase(c)#'])"),i) />
					</cfloop>
				</cfloop>
				
			</cfif>
		</cfif>
		
		<cfreturn q />
	</cffunction>
</cfcomponent>