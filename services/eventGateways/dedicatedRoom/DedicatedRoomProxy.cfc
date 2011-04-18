<cfcomponent output="false" accessors="true">
	<cfsetting showdebugoutput="false" />
	<cfset variables.userService = application.factory.getBean("userService") />	
	<cfset variables.AppConfig = application.factory.getBean("AppConfig") />

	<cffunction name="getIsUserNameAvailable" output="false" access="remote" returntype="boolean">
		<cfargument name="room" required="true" />
		<cfargument name="username" required="true" />
		<cfset var qUserCheck = queryNew("") />
		<cfset var isUsernameAvailable = true />
		<cfset var qUsers = queryNew("") />
	
		<cfif structKeyExists(application.collaboration, arguments.room)>
			<cfset qUsers = application.collaboration[arguments.room]["users"]>
			<cfif structKeyExists(application.collaboration, arguments.room) and structKeyExists(application.collaboration[arguments.room], "users")>
				<cfquery name="qUserCheck" dbtype="query">
				select *
				from qUsers
				where lower(username) = <cfqueryparam value="#lcase(arguments.username)#" cfsqltype="cf_sql_varchar" />
				</cfquery>
				<cfif qUserCheck.recordCount>
					<cfset isUsernameAvailable = false />
				</cfif>
			</cfif>
			<!--- catch users who try to sign in as the room owner but aren't logged in as the room owner --->
			<cfset var user = variables.userService.readUser(variables.userService.getCurrentUserID()) />
			<cfif arguments.room eq arguments.username and arguments.username neq user.getUsername()>
				<cfset isUsernameAvailable = false />
			</cfif>
		</cfif>	
		<cfreturn isUsernameAvailable />
	</cffunction>
	
	<cffunction name="getGatewayName" output="false" access="remote" returntype="string">
		<cfreturn variables.AppConfig.getConfigSetting("decicatedRoomGatewayName") />
	</cffunction>
	
	<cffunction name="getScreenChannel" output="false" access="remote" returntype="string">
		<cfargument name="room" required="true" />
		
		<!--- create a new session for this presentation if it doesn't exist --->
		<cfif not structKeyExists(application.collaboration, arguments.room)>
			<cflock scope="application" timeout="30" type="exclusive">
				<cfset application.collaboration[arguments.room] = structNew() />
				<cfset application.collaboration[arguments.room]["users"] = queryNew("userid,username,role", "varchar, varchar, varchar") />
				<cfset application.collaboration[arguments.room]["isBroadcasting"] = false />
				<cfset application.collaboration[arguments.room]["currentPresentation"] = "" />
				<cfset application.collaboration[arguments.room]["currentSlide"] = "" />
				<cfset application.collaboration[arguments.room]["lastActivity"] = now() />
				<cfset application.collaboration[arguments.room]["chatLog"] = arrayNew(1) />
				<!--- we may have already set teh channel in the proxy --->
				<cfif not structKeyExists(application.collaboration[arguments.room], "screenChannel")>
					<cfset application.collaboration[arguments.room]["screenChannel"] = createUUID() />
				</cfif>
			</cflock>
		</cfif>
		
		<cfreturn application.collaboration[arguments.room]["screenChannel"] />
	</cffunction>

</cfcomponent>