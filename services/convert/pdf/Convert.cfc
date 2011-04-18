<cfcomponent output="true" accessors="true">
	<cfproperty name="AppConfig" />
	<cfproperty name="Utils" />
	
	<cffunction name="init" access="public" returntype="Convert" output="false">
		<cfreturn this />
	</cffunction>
		
	<cffunction name="convert" access="public" output="true" returntype="array">
		<cfargument name="iFile" required="true" />
		<cfset var slide = structNew() />
		<cfset var notes = "" />
		<cfset var title = "" />
		<cfset var html = "" />
		<cfset var pdfQ = "" />
		<cfset var sortOrder = "" />
		<cfset var r = "" />
		<cfset var slideNumStart = "" />
		<cfset var orderNum = "" />
		<cfset var slides = "" />
		<cfset var dirName = getUtils().getStrippedUUID() />
		<cfset var oPath = getTempDirectory() & "/" & dirName & "/"/>
		<cfset var retArr = arrayNew(1) />
		<cfset var img = "" />
		<cfset var text = "" />
		<cfset var t = "" />
		
		<cfpdf action="extracttext" source="#arguments.iFile#" name="text" />		
		<cfset text = xmlParse(text) />

		<cfset var textStruct = structNew() /> 
		
		<cfloop array="#text.docText.textPerPage.xmlChildren#" index="t">
			<cfif structKeyExists(t, "xmlText")>
				<cfset textStruct[t.xmlAttributes.pageNumber] = t.xmlText />
			</cfif>
		</cfloop>
		
		<cfdirectory action="create" directory="#oPath#" />
		
		<cfpdf action="thumbnail" source="#iFile#" destination="#oPath#" format="png" pages="1-100" imagePrefix="#dirName#" overwrite="true" resolution="high" scale="100">

		<cfdirectory directory="#oPath#" filter="#dirName#_page_*" action="list" name="pdfQ" />
		<cfset queryAddColumn(pdfQ,"sortOrder","Integer",arrayNew(1)) />
		
		<cfloop from="1" to="#pdfQ.recordCount#" index="r">
			<cfset slideNumStart = findNoCase("page_",pdfQ.name[r]) />
			<cfset orderNum = right(pdfQ.name[r],len(pdfQ.name[r])-(slideNumStart-1)) />
			<cfset querySetCell(pdfQ,"sortOrder",reReplaceNoCase(orderNum,"[^0-9]", "", "all"),r) />
		</cfloop>
			
		<cfquery name="slides" dbtype="query">
		select *
		from pdfQ
		order by sortOrder
		</cfquery>

		<cfloop query="slides">
			<cfset img = imageNew(slides.directory & "/" & slides.name) />
			<cfset imageCrop(img,0,0,(img.width-15), (img.height-5)) />
			<cfset slide = structNew() />	
			<cfset slide.text = "" />
			<cfif structKeyExists(textStruct, currentRow)>
				<cfset slide.html = textStruct[currentRow] />
			</cfif>
			<cfset slide.notes = "" />
			<cfset slide.title = "Slide " & currentRow />
			<cfset slide.img = img />
			<cfset arrayAppend(retArr, slide) />
		</cfloop>	
		<cftry>	
			<cfcatch type="any"><!--- fail silently, no sense borking the thing if i can't delete it ---></cfcatch>	
		</cftry>
		<cffile action="delete" file="#iFile#" />
		<cfreturn retArr />
		
	</cffunction>
</cfcomponent>