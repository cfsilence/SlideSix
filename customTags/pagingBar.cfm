<cfif thisTag.executionMode eq "start">
	<cfparam name="attributes.startIndex" default="1" />
	<cfparam name="attributes.startVariableName" default="s" />
	<cfparam name="attributes.maxIndex" />
	<cfparam name="attributes.pageSize" />
	<cfparam name="attributes.maxLinks" default="10" />
	<cfparam name="attributes.baseLink" />
	<cfset variables._pagingBar = {} />
	
	<cfset variables._pagingBar.firstPageIndex = 1 />
	<cfset variables._pagingBar.startLink = fix(val(REReplace(attributes.startIndex,"[^/.0123456789-]","","all"))) />
	<cfset variables._pagingBar.lastPageIndex = attributes.maxIndex - attributes.pageSize + 1 />
	<cfset variables._pagingBar.endLink = variables._pagingBar.lastPageIndex />
	
	<cfset variables._pagingBar.linkCount = attributes.maxIndex / attributes.pageSize />
	
	<cfif variables._pagingBar.linkCount gt attributes.maxLinks>
		<cfset variables._pagingBar.endLink = variables._pagingBar.startLink + (attributes.pageSize * attributes.maxLinks) /> 
		<cfif variables._pagingBar.endLink gt variables._pagingBar.lastPageIndex>
			<cfset variables._pagingBar.endLink = variables._pagingBar.lastPageIndex />
		</cfif>
	</cfif>
	<style>
	.float-left{float:left;}
	.clear{clear: both;}
	.current{background-color: red;}
	div{padding-left: 5px; padding-right: 5px;}
	</style>
	
	<cfoutput>
		<div id="navBar_#replace(createUUID(), "-", "", "all")#">
			<cfif variables._pagingBar.startLink neq variables._pagingBar.firstPageIndex>
				<div class="float-left">
					<a href="#attributes.baseLink#&#attributes.startVariableName#=#variables._pagingBar.firstPageIndex#">first</a>			
				</div>
				<div class="float-left">
					...			
				</div>
			</cfif>	
			<cfset variables._pagingBar.loopStart = variables._pagingBar.startLink />
			
			<cfif variables._pagingBar.startLink gt (variables._pagingBar.endLink - (attributes.pageSize * attributes.maxLinks))>
				<cfset variables._pagingBar.links = fix((variables._pagingBar.endLink - variables._pagingBar.startLink) / attributes.pageSize) />
				<cfset variables._pagingBar.stepsBack = attributes.pageSize - variables._pagingBar.links />
				<cfset variables._pagingBar.loopStart = variables._pagingBar.startLink - (variables._pagingBar.stepsBack * attributes.pageSize) />
			</cfif>
			
			<cfloop from="#variables._pagingBar.loopStart#" to="#variables._pagingBar.endLink#" index="l" step="#attributes.pageSize#">
				<div class="float-left">
					<cfif l neq variables._pagingBar.startLink><a href="#attributes.baseLink#&#attributes.startVariableName#=#l#"></cfif>
						#ceiling(l/attributes.pageSize)#
					<cfif l neq variables._pagingBar.startLink></a></cfif>			
				</div>	
			</cfloop>
			<cfif variables._pagingBar.endLink neq variables._pagingBar.lastPageIndex>
				<div class="float-left">
					...			
				</div>
				<div class="float-left">
					<a href="#attributes.baseLink#&#attributes.startVariableName#=#variables._pagingBar.lastPageIndex#">last</a>			
				</div>
			</cfif>	
			<div class="clear"></div>
		</div>
		<cfdump var="#variables._pagingBar#">
	</cfoutput>
<cfelse>
	<cfexit method="exittag" />
</cfif>