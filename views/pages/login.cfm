<cfset me = event.getValue("myself") />
<cfset loginMsg = event.getValue("loginMsg") />

<div>
	<cfoutput>
		<div id="msg">
			<cfif len(loginMsg)>#loginMsg#</cfif>
		</div>
		<form action="#me#user.login" method="post" id="loginForm">
			<div>
				<div class="">
					<label for="username">Username: </label>
				</div>
			</div>
			<div>
				<div class="">
					<input type="text" name="username" id="username" />
				</div>
			</div>
			<div>
				<div class="">
					<label for="password">Password: </label>
				</div>
			</div>
			<div>
				<div class="">
					<input type="password" id="password" name="password" />
				</div>
			</div>
			<div class="width-full">
				<a href="#me#user.resetPassword">Forgot Password?</a>
			</div>
			<div>
				<div class="">
					<input type="submit" id="submit" value="Submit" />
				</div>
			</div>
		</form>
	</cfoutput>
</div>