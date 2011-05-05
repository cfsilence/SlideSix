<cfcomponent output="false" hint="Note:  save/delete are set to run as a transaction by default, and will flush the orm session unless an attrib of ""noflush"" is passed with value of false!">

	<cffunction name="count" output="false">
		<cfargument name="entity" type="string" required="false" />
		<cfargument name="countField" type="string" required="false" default="id" />
		<cfargument name="whereClause" type="string" required="false" hint="*just* the part after ""where"", e.g., ""attrib = ?"" " />
		<cfargument name="params" type="any" required="false" />
		<cfset var ret = 0 />
		<cfset var hql = "select count(" & arguments.countField& ")" & "from " & entity />
		
		<cfif structKeyExists( arguments, "whereClause" )>
			<cfset hql = hql & " where #arguments.whereClause#" />
		</cfif>
		<cfif structKeyExists( arguments, "params" )>
			<cfset ret = ormExecuteQuery( hql, params, true ) />
			<cfreturn ret />
		<cfelse>
			<cfreturn ormExecuteQuery( hql, {}, true ) />
		</cfif>
			
	</cffunction>

	<cffunction name="query" output="false">
		<cfargument name="hql" type="string" required="false" />
		<cfargument name="params" type="Any" required="false" hint="can be an array or a struct depending on if named params are used" />
		<cfargument name="unique" type="boolean" required="false" default="false" />
		<cfargument name="queryOptions" type="struct" required="false" default="#{}#" />
		<cfset var ret = arrayNew(1) />
		<cfif structKeyExists(arguments, "queryOptions") and structKeyExists(arguments.queryOptions, "offset")>
			<!--- make the zero based index transparent --->
			<cfset arguments.queryOptions.offset = (arguments.queryOptions.offset - 1) />
		</cfif>
		<cfif structKeyExists( arguments, "params" )>
			<cfset ret = ormExecuteQuery( hql, params, unique, queryOptions ) />
			<cfreturn ret />
		<cfelse>
			<cfreturn ormExecuteQuery( hql ) />
		</cfif>
	</cffunction>

	<cffunction name="list" output="false">
		<cfargument name="entity" type="string" required="false" />
		<cfargument name="whereClause" type="string" required="false" hint="*just* the part after ""where"", e.g., ""attrib = ?"" " />
		<cfargument name="params" type="Any" required="false" hint="can be an array or a struct depending on if named params are used" />
		<cfargument name="unique" type="boolean" required="false" default="false" />
		<cfargument name="queryOptions" type="struct" required="false" default="#{}#" />
		<cfset var ret = arrayNew(1) />
		<cfset var hql = "from " & entity />
		
		<cfif structKeyExists( arguments, "whereClause" )>
			<cfset hql = hql & " where #arguments.whereClause#" />
		</cfif>
		<cfif structKeyExists(arguments, "queryOptions") and structKeyExists(arguments.queryOptions, "offset")>
			<!--- make the zero based index transparent --->
			<cfset arguments.queryOptions.offset = (arguments.queryOptions.offset - 1) />
		</cfif>
		<cfif structKeyExists( arguments, "params" )>
			<cfset ret = ormExecuteQuery( hql, params, unique, queryOptions ) />
			<cfreturn ret />
		<cfelse>
			<cfreturn ormExecuteQuery( hql ) />
		</cfif>
			
	</cffunction>

	<cffunction name="deleteById" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="id" type="any" required="yes" />
		<cfargument name="noFlush" type="boolean" default="false" />
		
		<cfset delete( read( name, id ) ) />
		
		<cfif not noFlush>
			<cfset ormFlush() />
		</cfif>
	</cffunction>

	<cffunction name="save" output="false">
		<cfargument name="target" type="any" required="yes" />
		<cfargument name="noFlush" type="boolean" default="false" />
		
		<cfset var i = "" />
		
		<cfif isArray( target )>
			<cfloop from="1" to="#arrayLen( target )#" index="i">
				<cfset target[i] = save( target[i], true ) />
			</cfloop>
		<cfelse>
			<cfset entitySave( target ) />
		
			<cfif not noFlush>
				<cfset ormFlush() />
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="delete" output="false">
		<cfargument name="instance" type="any" required="yes" />
		<cfargument name="noFlush" type="boolean" default="false" />
		<!---<cflog text="delete() for #getMetadata( instance ).name#::#instance.getId()#">--->
		<cfset entityDelete( instance ) />

		<cfif not noFlush>
			<cfset ormFlush() />
		</cfif>
	</cffunction>

	<cffunction name="read" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="id" type="any" required="yes" />
		
		<cfset var entities = entityLoad( name, id ) />
		
		<cfif not arrayLen( entities ) or arrayLen( entities ) gt 1 >
			<!---<cfreturn javaCast("null","") />--->	
			<cfreturn entityNew(name) />
		<cfelse>
			<cfreturn entities[1] />
		</cfif>
	</cffunction>
	
	<cffunction name="onMissingMethod" output="false">
		<cfargument name="missingMethodName" />
		<cfargument name="missingMethodArguments" />
		
		<cfif left( missingMethodName, 4 ) eq "list">
			<cfreturn listDynamically( right( missingMethodName, len( missingMethodName ) - 4 ), missingMethodArguments ) />
		</cfif> 
	</cffunction>
	
	<cffunction name="listDynamically" output="false">
		<cfargument name="missingMethodName" />
		<cfargument name="missingMethodArguments" />
		<cfset var tokens = "" />
		<cfset var entityName = "" />
		<cfset var where = "" />
		<cfset var token = "" />
		<cfset var params = arrayNew(1) />
		<cfset var paramKey = "" />
		
		<cfset tokens = missingMethodName.split( "By" ) />
		
		<cfset entityName = tokens[ 1 ] />
		
		<cfif arrayLen( tokens ) eq 1 >
			<cfreturn list( entityName ) />
		<cfelse>
			<cfset tokens = tokens[ 2 ].split( "And" ) />
			
			<cfloop array="#tokens#" index="token">
				<cfif len( where )>
					<cfset where = "#where# and "/>
				</cfif>
				
				<cfset where = "#where# #token# = ?" />
				
			</cfloop>
			
			<cfloop collection="#missingMethodArguments#" item="paramKey">
				<cfset arrayAppend(params, missingMethodArguments[ paramKey ]) />
			</cfloop>
			<cfreturn list( entityName, where, params ) />
		</cfif>
		
		
	</cffunction>
	
</cfcomponent>