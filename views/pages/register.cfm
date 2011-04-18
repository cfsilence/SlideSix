<cfset me = event.getValue("myself") />
<cfset errors = event.getValue("userErrors", arrayNew(1)) />

<cfdump var="#errors#">

<div id="userFormContainer" class="width-600-px">
	<cfoutput>
			<form name="registerForm" id="registerForm" action="#me#user.new" method="POST">
				<div class="width-full">
					<div class="width-50 float-left">
						<label for="username">Username</label>
					</div>
					<div class="width-50 float-left">
						<label for="email">Email Address</label>
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="width-full">
					<div class="width-50 float-left">
						<input type="text" name="username" id="username" value="#event.getValue("username")#" />
					</div>
					<div class="width-50 float-left">
						<input type="text" name="email" id="email" value="#event.getValue("email")#" />
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="width-full">
					<div class="width-50 float-left">
						<label for="firstName">First Name</label>
					</div>
					<div class="width-50 float-left">
						<label for="lastName">Last Name</label>
					</div>
					<div class="clear"></div>
				</div>
				<div class="width-full">
					<div class="width-50 float-left">
						<input type="text" name="firstName" id="firstName" value="#event.getValue("firstName")#" />
					</div>
					<div class="width-50 float-left">
						<input type="text" name="lastName" id="lastName" value="#event.getValue("lastName")#" />
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="width-full">
					<div class="width-50 float-left">
						<label for="password">Password</label>		
					</div>
					<div class="width-50 float-left">
						<label for="confirmPassword">Confirm Password</label>
					</div>
					<div class="clear"></div>
				</div>
				<div class="width-full">
					<div class="width-50 float-left">
						<input type="password" name="password" id="password" value="" />
					</div>
					<div class="width-50 float-left">
						<input type="password" name="confirmPassword" id="confirmPassword" value="" />
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="width-full">
					<div class="">
						<label for="bio">Bio</label>
					</div>
					<div class="width-full">
						<textarea id="bio" name="bio" class="width-470-px">#event.getValue("bio")#</textarea>
					</div>
				</div>
				
				<div class="width-full">
					<input type="submit" name="submit" id="submit" value="Submit" />
				</div>
			</form>
	</cfoutput>
</div>