<cfcomponent displayname="collaboration" output="false">
	<cfset variables.dedicatedRoomProxy = createObject("component", "DedicatedRoomProxy") />
	<cfset variables.userService = application.factory.getBean("userService") />	
	
	<cffunction name="onIncomingMessage" returntype="any">
		<cfargument name="event" type="struct" required="true" />
		<cfset var subtopic = event.data.headers.dssubtopic />
		<cfset var DSSubtopic = subtopic />
		<cfset var body = arguments.event.data.body />
		<cfset var msg = structNew() />
		<cfset var m = "" />
		<cfset var nextRow = "" />
		<cfset var cLog = arrayNew(1) />
		<cfparam name="body.presentation" default="" />
		<cfparam name="body.isBroadcasting" default="false" />
		<cfparam name="body.chat" default="" />
		<cfparam name="body.slide" default="" />
		<cfparam name="body.username" default="" />
		<cfparam name="body.userid" default="" />
		<cfparam name="body.login" default="false" />
		<cfparam name="body.logout" default="false" />
		<cfparam name="body.clearChat" default="false" />
		
		<cfset subtopic = listLast(DSSubtopic, "-") />
		<!--- does this presentation currently exist in memory? --->
		<cfif structKeyExists(body, "room")>
			<cfif not structKeyExists(application, "collaboration")>
				<cflock scope="application" timeout="30" type="exclusive">
					<cfset application.collaboration = structNew() />
				</cflock>
			</cfif>
			<!--- create a new session for this presentation if it doesn't exist --->
			<cfif not structKeyExists(application.collaboration, body.room)>
				<cflock scope="application" timeout="30" type="exclusive">
					<cfset application.collaboration[body.room] = structNew() />
					<cfset application.collaboration[body.room]["users"] = queryNew("userid,username,role", "varchar, varchar, varchar") />
					<cfset application.collaboration[body.room]["isBroadcasting"] = body.isBroadcasting />
					<cfset application.collaboration[body.room]["currentPresentation"] = body.presentation />
					<cfset application.collaboration[body.room]["currentSlide"] = "" />
					<cfset application.collaboration[body.room]["lastActivity"] = now() />
					<cfset application.collaboration[body.room]["chatLog"] = arrayNew(1) />
					<!--- we may have already set teh channel in the proxy --->
					<cfif not structKeyExists(application.collaboration[body.room], "screenChannel")>
						<cfset application.collaboration[body.room]["screenChannel"] = createUUID() />
					</cfif>
				</cflock>
			</cfif>
		</cfif>
		
		<cfswitch expression="#subtopic#">
			<cfcase value="slideChanged">
				<cflock scope="application" timeout="30" type="exclusive">
					<cfset application.collaboration[body.room]["currentPresentation"] = body.presentation />
					<cfset application.collaboration[body.room]["currentSlide"] = body.slide />
					<cfset application.collaboration[body.room]["lastActivity"] = body.timestamp />
					<cfset application.collaboration[body.room]["isBroadcasting"] = body.isBroadcasting />
				</cflock>
			</cfcase>
			<cfcase value="chat">
				<cflock scope="application" timeout="30" type="exclusive">
					<cfset application.collaboration[body.room]["lastActivity"] = body.timestamp />
					<cfif not body.clearChat>
						<cfset arrayAppend(application.collaboration[body.room]["chatLog"], body.chat) />
					<cfelse>
						<cfset application.collaboration[body.room]["chatLog"] = arrayNew(1) />
					</cfif>
				</cflock>
			</cfcase>
		</cfswitch>
		
		<cfif body.login>
			<cfset cLog = application.collaboration[body.room]["chatLog"] />
			<cfset loginUser(body.userid,body.username,body.room,body.role) />
		</cfif>
		
		<cfset msg = structNew() />
		<cfset msg.body = structNew() />
		<cfset m = replaceList(body.chat, "<i>,</i>,<b>,</b>", "[i],[/i],[b],[/b]")>
		<cfset m = HTMLEditFormat(m) />
		<cfset m = replaceList(m, "[i],[/i],[b],[/b]", "<i>,</i>,<b>,</b>")>
		<cfset msg.body.msg = m />
		<cfset msg.body.userid = body.userid />
		<cfset msg.body.username = body.username />
		<cfset msg.body.logout = lcase(trim(yesNoFormat(body.logout))) />
		<cfset msg.body.login = lcase(trim(yesNoFormat(body.login))) />
		<cfset msg.body.chatLog = cLog />
		
		<cfset msg.body.presentation = application.collaboration[body.room]["currentPresentation"] />
		<cfset msg.body.currentUsers = application.collaboration[body.room]['users'] />
		<cfset msg.body.slide = application.collaboration[body.room]["currentSlide"] />
		<cfset msg.body.isBroadcasting = lcase(yesNoFormat(application.collaboration[body.room]["isBroadcasting"])) />
		
		<cfset msg["headers"]["DSSubtopic"] = DSSubtopic />
		<cfset msg.destination = "ColdFusionGateway" />
		
		<cfif body.logout>
			<cfset logoutUser(body.userid,body.username,body.room) />
		</cfif>
		
		<cfset SendGatewayMessage(variables.dedicatedRoomProxy.getGatewayName(), msg) />
				
	</cffunction>
	
	<cffunction name="loginUser" access="remote" returntype="void" output="false">
		<cfargument name="userid" required="false" default="0" />
		<cfargument name="username" required="true" />
		<cfargument name="room" required="true" />
		<cfargument name="role" required="false" default="participant" />
		<cfset var uExist = queryNew("") />
		<cfset var nextRow = application.collaboration[arguments.room]["users"].recordCount + 1 />
		<cfset var r = arguments.role />
		<cfset var qUsers = application.collaboration[arguments.room]["users"] />
		
		<cfquery name="uExist" dbtype="query">
		select *
		from qUsers
		where username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cflock scope="application" timeout="30" type="exclusive">
			<cfif not uExist.recordCount>
				<cfset queryAddRow(application.collaboration[arguments.room]["users"], 1) />
				<cfset querySetCell(application.collaboration[arguments.room]["users"], "userid", arguments.userid, nextRow) />
				<cfset querySetCell(application.collaboration[arguments.room]["users"], "username", arguments.username, nextRow) />
				<cfset querySetCell(application.collaboration[arguments.room]["users"], "role", r, nextRow) />
			</cfif>
		</cflock>
	</cffunction>
	
	<cffunction name="logoutUser" access="public" returntype="void" output="false">
		<cfargument name="userid" required="true" />
		<cfargument name="username" required="true" />
		<cfargument name="room" required="true" />
		<cfset var qUsers = application.collaboration[arguments.room]["users"] />
		<cfset var qofQUsers = queryNew("") />
		
		<cfquery name="qofQUsers" dbtype="query">
		select *
		from qUsers
		where userid != <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cflock scope="application" timeout="30" type="exclusive">
			<cfif not qofQUsers.recordCount>
				<cfif structKeyExists(application.collaboration, arguments.room)>
					<cfset structDelete(application.collaboration, arguments.room) />
				</cfif>
			<cfelse>
				<cfset application.collaboration[arguments.room]["users"] = qofQUsers />
			</cfif>
		</cflock>
	</cffunction>
	
</cfcomponent>