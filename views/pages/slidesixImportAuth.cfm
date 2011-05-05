<cfset me = event.getValue("myself") />
<cfset authMsg = event.getValue("authMsg") />

<div>
	<cfoutput>
		<div class="pad-top-20 pad-bottom-20">
			<h3>Enter SlideSix Username & Password</h3>
		</div>
		
		<div id="msg" class="pad-top-20 pad-bottom-20">
			<cfif len(authMsg)>#authMsg#</cfif>
		</div>
		
		<form action="#me#page.handleslidesixauth" method="post" id="authForm">
			<div>
				<div class="">
					<label for="username">SlideSix Username: </label>
				</div>
			</div>
			<div>
				<div class="">
					<input type="text" name="username" id="username" />
				</div>
			</div>
			<div>
				<div class="">
					<label for="password">SlideSix Password: </label>
				</div>
			</div>
			<div>
				<div class="">
					<input type="password" id="password" name="password" />
				</div>
			</div>
			<div>
				<div class="">
					<input type="submit" id="submit" value="Retrieve Presentations" />
				</div>
			</div>
		</form>
	</cfoutput>
</div>