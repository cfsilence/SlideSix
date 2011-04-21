<cfif thistag.executionMode eq "start"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<cfparam name="attributes.pathToSiteRoot" default="" />
<cfparam name="attributes.pageTitle" default="Default" />
<cfparam name="attributes.needJQuery" default="false" />
<cfparam name="attributes.needJQueryUI" default="false" />
<cfparam name="attributes.needBlockUI" default="false" />
<cfparam name="attributes.needJSON" default="false" />
<cfparam name="attributes.needFacebox" default="false" />
<cfparam name="attributes.needTooltip" default="false" />
<cfparam name="attributes.needSelectBoxes" default="false" />
<cfparam name="attributes.cacheKey" default="" />
<cfparam name="attributes.scripts" default="" />
<cfparam name="attributes.isLoggedIn" default="false" />
<cfparam name="attributes.currentUser" default="" />
<cfparam name="variables.scriptPath" default="#attributes.pathToSiteRoot#/includes/js/scripts/">
</cfsilent>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<cfoutput>
<title>#attributes.pageTitle#</title>
</cfoutput>
<!--- styles --->
<link href='http://fonts.googleapis.com/css?family=Droid+Sans:regular,bold&subset=latin' rel='stylesheet' type='text/css'>

<cfoutput>
<link href="#attributes.pathToSiteRoot#/css/layout.css?c=#attributes.cacheKey#" rel="stylesheet" type="text/css" />
<link href="#attributes.pathToSiteRoot#/css/paging.css?c=#attributes.cacheKey#" rel="stylesheet" type="text/css" />
</cfoutput>
<cfif attributes.needJQuery>
<cfoutput>
<script src="#attributes.pathToSiteRoot#/includes/js/jquery/jquery-1.5.2.min.js?c=#attributes.cacheKey#" type="text/javascript"></script>
</cfoutput>
</cfif>
<cfif attributes.needJQueryUI>
<cfoutput>
<link href="#attributes.pathToSiteRoot#/css/black-tie/jquery-ui-1.8.6.custom.css?c=#attributes.cacheKey#" rel="stylesheet" type="text/css" />
<script src="#attributes.pathToSiteRoot#/includes/js/jquery-ui/jquery-ui-1.8.6.custom.min.js?c=#attributes.cacheKey#" type="text/javascript"></script>
</cfoutput>
</cfif>

<cfif listLen(attributes.scripts)>
	<cfoutput>
		<cfloop list="#attributes.scripts#" index="_s" delimiters=",">
<script src="#variables.scriptPath##_s#?c=#attributes.cacheKey#" type="text/javascript"></script>
		</cfloop>
	</cfoutput>
</cfif>

</head>

<body>
<div id="header" class="pad-top-20">
	<div class="wrap">
		<h1>SlideSix</h1>
	</div>
	<hr />
</div>

<div id="nav">
	<div class="wrap">
		<div class="pad-top-10 margin-bottom-20">
			<div class="float-left pad-right-10 pad-bottom-10">
				<a href="/">home</a>
			</div>
			<cfif !attributes.isLoggedIn>
				<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
					<a href="index.cfm?event=user.register">register</a>
				</div>
				<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
					<a href="index.cfm?event=user.loginPage">login</a>
				</div>
			<cfelse>
				<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
					<a href="index.cfm?event=user.logout">logout</a>
				</div>
			</cfif>
			<cfif attributes.isLoggedIn>
				<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
					<a href="index.cfm?event=slidemanager">slide manager</a>
				</div>
				<cfif attributes.currentUser.getIsAdmin()>
					<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
						<a href="index.cfm?event=admin.main">Admin</a>
					</div>
					<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
						<a href="index.cfm?event=admin.slideshows">SlideShow Admin</a>
					</div>
					<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
						<a href="index.cfm?event=admin.users">User Admin</a>
					</div>
					<div class="float-left pad-left-10 pad-right-10 pad-bottom-10">
						<a href="index.cfm?event=admin.groups">Groups Admin</a>
					</div>
				</cfif>
			</cfif>
			
			<div class="float-right pad-left-10 pad-right-10 pad-bottom-10">
				<form action="index.cfm" method="get">
					<div class="float-left">
						<input type="text" id="q" name="q" value="" class="width-100-px" />										
						<input type="hidden" id="event" name="event" value="slideshows.search" />
					</div>
					<div class="float-left">
						<input type="submit" name="submit" value="Search" />
					</div>
					<div class="clear"></div>
				</form>
			</div>
			<div class="clear"></div>
		</div>
	</div>
</div>
<div class="wrap">

<cfelse>

</div>
<div id="footer" class="width-full margin-top-20 margin-bottom-20 height-250-px">
	<div class="wrap font-12 pad-top-20">
		<div class="float-left width-190-px">
			<span>
				Col 1
			</span>
		</div>
		<div class="float-left width-190-px">
			<span>
				Col 2
			</span>
		</div>
		<div class="float-left width-190-px">
			<span>
				Col 3
			</span>
		</div>
		<div class="float-left width-190-px">
			<span>
				Col 4
			</span>
		</div>
		<div class="float-left width-190-px">
			<span>
				Col 5
			</span>
		</div>
		<div class="clear"></div>
	</div>
</div>
</body>
</html>
</cfif>