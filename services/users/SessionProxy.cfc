<cfcomponent output="false">
	<cfsetting showdebugoutput="false" enablecfoutputonly="true" />
	<cffunction name="getInactivity" access="remote" output="false" hint="i return the amount of session inactivity for the current logged in user" returntype="numeric">
		<cfif structKeyExists(session, "lastHit")>
			<cfreturn dateDiff("n", session.lastHit, now()) />
		</cfif>
		<cfreturn 20 />
	</cffunction>
	
	<cffunction name="ping" access="remote" output="false" hint="i ping the session based on user confirmation to keep it alive" returntype="void">
		<cfset session.lastHit = now() />
	</cffunction>
	
	<cffunction name="getCurrentUser" access="remote" output="false" returntype="Struct">
		<cfset var uid = structKeyExists(session, "currentUserID") ? session.currentUserID : 0 />
		<cfset var ret = {} />
		<cfset ret.user = application.factory.getBean("UserService").getUserByUserID(uid) />
		<cfset ret.sessionid = session.sessionid />
		<cfreturn ret />
	</cffunction>
	
</cfcomponent>