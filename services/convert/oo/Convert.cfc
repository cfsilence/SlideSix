<cfcomponent output="true" accessors="true">
	<cfproperty name="Loader" />
	<cfproperty name="AppConfig" />
	<cfproperty name="Utils" />
	
	<cffunction name="init" access="public" returntype="Convert" output="false">
		<cfargument name="loaderService" required="true" />
		<cfset setLoader(arguments.loaderService.getLoader()) />
		<cfreturn this />
	</cffunction>
		
	<cffunction name="convert" access="public" output="true" returntype="array">
		<cfargument name="iFile" required="true" />
		<cfset var oPath = getTempDirectory() & "/" & getUtils().getStrippedUUID() & "/"/>
		<cfset var connection = getLoader().create("com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection").init(8100) />
		<cfset var documentFormat = getLoader().create("com.artofsolving.jodconverter.DocumentFormat").init("HTML Document (OpenOffice.org Impress)", "impress_html_Export", "html") />
		<cfset var documentFamily = getLoader().create("com.artofsolving.jodconverter.DocumentFamily") />
		<cfset var converter = getLoader().create("com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter").init(connection) />
		<cfset var options = createObject("java", "java.util.HashMap") />
		<cfset var i = createObject("java", "java.io.File").init(arguments.iFile) />
		<cfset var oFile = oPath & listFirst(i.getName(), ".") & ".html" />
		<cfset var o = createObject("java", "java.io.File").init(oFile) />
		<cfset var width = getAppConfig().getConfigSetting("ooWidth") />
		<cfset var compression = getAppConfig().getConfigSetting("ooCompression") />
		<cfset var exportNotes = getAppConfig().getConfigSetting("ooExportNotes") />
		<cfset var filter = getAppConfig().getConfigSetting("ooExportFilter") />
		<cfset var qFiles = "" />
		<cfset var retArr = arrayNew(1) />
		<cfset var slide = structNew() />
		<cfset var html = "" />
		<cfset var c = "" />
		<cfset var textFile = "" />
		<cfset var notes = "" />
		<cfset var title = "" />
		<cfset var r = "" />
		<cfset var qSorted = "" />
		
		<cfset documentFormat.setExportFilter(documentFamily.PRESENTATION, filter) />
		
		<cfset options.put("Width",javacast("int", width)) />
		<cfset options.put("Compression", compression) />
		<cfset options.put("IsExportNotes", javacast("boolean",exportNotes)) />
		<cfset documentFormat.setExportOption(documentFamily.PRESENTATION, "FilterData", options) />
		
		<cftry>
			<cfset connection.connect() />
			<cfset converter.convert(i,o,documentFormat) />
			
			<cfdirectory directory="#oPath#" action="list" name="qFiles" filter="*.jpg" sort="name asc" />

			<cfset queryAddColumn(qFiles,"sortOrder","Integer",arrayNew(1)) />
			
			<cfloop from="1" to="#qFiles.recordCount#" index="r">
				<cfset querySetCell(qFiles,"sortOrder",reReplaceNoCase(qFiles.name[r],"[^0-9]", "", "all"),r) />
			</cfloop>
			
			<cfquery name="qSorted" dbtype="query">
			select *
			from qFiles
			order by sortOrder
			</cfquery>
			
			<cfloop query="qSorted">
				<cfset slide = structNew() />
				
				
				<cfset html = "" />
				<cfset c = currentRow - 1 />
				<cfset textFile = qSorted.directory & "/text" & c & ".html" />
				
				<cfif fileExists(textFile)>
					<cffile action="read" file="#textFile#" variable="html" />
				</cfif>
				
				<cfset slide.text = getUtils().stripHTML(getUtils().removeNonPrintingCharacters(html)) />
				<cfset slide.text = trim(replaceNoCase(slide.text, "First page Back Continue Last page Graphics", "", "one")) />
								
				<cfif findNoCase("<h3>Notes:</h3>",html)>
					<cfset notes = REReplaceNoCase(html, ".*<h3[^>]*>Notes:</h3[^>]*>", "", "All") />
					<cfset notes = REReplaceNoCase(notes, "</body[^>]*>.*", "", "All")>
				<cfelse>
					<cfset notes = "" />
				</cfif>
				
				<cfset slide.notes = notes />
				<!--- remove the notes from the text --->
				<cfif len(notes)>
					<cfset slide.text = replaceNoCase(slide.text, notes, "") />	
					<cfset slide.text = replaceNoCase(slide.text, "Notes:", "") />		
				</cfif>
				
				<cfset title = getUtils().getTagContent("title",html) />
				
				<cfif not len(title)>
					<cfset title = "Slide " & currentRow />
				</cfif>
				
				<cfset slide.text = trim(replaceNoCase(slide.text, title, "")) />	
					
				<cfset slide.title = title />
				<cfset slide.img = imageNew(qSorted.directory & "/" & qSorted.name) />
				<cfset arrayAppend(retArr, slide) />
			</cfloop>
			
			<cfset connection.disconnect() />
			
			<cfdirectory action="delete" directory="#oPath#" recurse="true"/>
			
			<cfcatch>
				<cfset connection.disconnect() />
				<cfrethrow />
			</cfcatch>
		</cftry>
		<cfreturn retArr />
		
	</cffunction>
</cfcomponent>