<cfcomponent>
	<cffunction name="getComponent" output="false" access="private">
		<cfreturn application.factory.getBean("TwitterService") />
	</cffunction>

	<cffunction name="twitterMsg" access="remote" output="false">
		<cfargument name="MSG" required="true" />
		<cfreturn getComponent().twitterMsg(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="tinyURL" output="false" access="remote">
		<cfargument name="theurl" required="true" type="string" />
		<cfreturn getComponent().tinyURL(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="savedsearch" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="func" required="true" type="string" />
		<cfargument name="search" required="true" type="string" />
		<cfreturn getComponent().savedsearch(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="checkFriend" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="userA" required="true" type="string" />
		<cfargument name="userB" required="true" type="string" />
		<cfreturn getComponent().checkFriend(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="extInfo" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="user" required="false" type="string" />
		<cfreturn getComponent().extInfo(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="friendship" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="user" required="true" type="string" />
		<cfargument name="func" required="true" type="string" />
		<cfreturn getComponent().friendship(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="activateURL" access="remote" output="false">
		<cfargument name="SACTIVE" required="true" />
		<cfreturn getComponent().activateURL(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="relations" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="func" required="true" type="string" />
		<cfargument name="user" required="true" type="string" />
		<cfargument name="page" required="false" type="numeric" />
		<cfreturn getComponent().relations(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="singlestatus" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="id" required="true" type="string" />
		<cfreturn getComponent().singlestatus(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="verify" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfreturn getComponent().verify(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="newmessage" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="user" required="true" type="numeric" />
		<cfargument name="msg" required="true" type="string" />
		<cfreturn getComponent().newmessage(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="twitterDate" access="remote">
		<cfargument name="DATE" required="true" />
		<cfargument name="OFFSET" required="true" />
		<cfreturn getComponent().twitterDate(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="rateLimits" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfreturn getComponent().rateLimits(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="getstatus" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="user" required="true" type="string" />
		<cfargument name="section" required="true" type="string" />
		<cfargument name="page" required="false" type="numeric" />
		<cfargument name="since" required="false" type="numeric" />
		<cfargument name="limit" required="false" type="numeric" />
		<cfreturn getComponent().getstatus(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="search" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="search" type="string" />
		<cfargument name="rpp" type="numeric" />
		<cfargument name="since_id" type="numeric" />
		<cfreturn getComponent().search(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="messages" output="false" access="remote">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="page" type="numeric" />
		<cfargument name="folder" default="inbox" />
		<cfreturn getComponent().messages(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="postStatus" output="false" access="remote" returnType="Any">
		<cfargument name="tu" required="true" type="string" />
		<cfargument name="tp" required="true" type="string" />
		<cfargument name="message" required="true" />
		<cfargument name="replyid" />
		<cfreturn getComponent().postStatus(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="strLen" access="remote" output="false">
		<cfargument name="SLEN" required="true" />
		<cfargument name="SVAL" required="true" />
		<cfreturn getComponent().strLen(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="stripHTML" access="remote" output="false">
		<cfargument name="HTMLTXT" required="true" />
		<cfreturn getComponent().stripHTML(argumentCollection=arguments) />
	</cffunction>

</cfcomponent>