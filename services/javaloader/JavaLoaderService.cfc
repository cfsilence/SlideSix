<cfcomponent displayname="java loader service">
	
	<cfset variables.instance = structNew() />
	<cfset variables.instance.paths = arrayNew(1) />

	<cffunction name="init" access="public" returntype="JavaLoaderService">
		<cfset var libDir = getLibDir() />
		<cfset var paths = "" />
		<cfloop query="libDir">
		   <cfset addPath("#libDir.directory#\#libDir.name#") />
		</cfloop>
		<cfset paths = createObject("component", "JavaLoader").init(getPaths()) />
		<cfset setLoader(paths)>
		<cfreturn this />	
	</cffunction>
	
	<cffunction name="getLibDir" access="private" output="false" returntype="query" hint="i read the lib dir and return the files">
		<cfset var libDir = expandPath("/services/javaloader/slidesixLib") />
		<cfset var qLibDir = queryNew("") />
		<cfdirectory action="list" directory="#libDir#" name="qLibDir" />
		<cfreturn qLibDir />
	</cffunction>
	
	<cffunction name="setLoader" access="public" returntype="void" output="false">
		<cfargument name="loader" type="any" required="true" />
		<cfset variables.instance.loader = arguments.loader />
	</cffunction>
	<cffunction name="getLoader" access="public" returntype="any" output="false">
		<cfreturn variables.instance.loader />
	</cffunction>
	
	<cffunction name="setPaths" access="public" returntype="void" output="false">
		<cfargument name="paths" type="any" required="true" />
		<cfset variables.instance.paths = arguments.paths />
	</cffunction>
	<cffunction name="addPath" access="public" returntype="void" output="false">
		<cfargument name="path" type="any" required="true" />
		<cfset arrayAppend(variables.instance.paths, arguments.path) />
	</cffunction>
	<cffunction name="getPaths" access="public" returntype="array" output="false">
		<cfreturn variables.instance.paths />
	</cffunction>
	
</cfcomponent>