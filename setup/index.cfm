<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Contact Manager Setup</title>
	<link href="<cfoutput>#request.root#</cfoutput>includes/css/display.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div id="container">
		<div id="contact-manager" class="contact-manager">
			<!-- search form -->
			<h1>Awesome Contacts <small>CF+ JQUERY</small></h1>
			<header>
				<div class="search">
					<span>Setup Required</span>
				</div>
			</header>
			<section>
				<cfif structKeyExists(request,"Exception")>
					It appears you need to run the setup script first in order to generate 
					the Embedded Apache Derby Database used. Please click on the following link to set up.
					<p style="text-align:center;">
						<input type="button" value="Setup Apache Derby Database" onclick="location='./setup/';" />
					</p>
					<p style="background:#272727; color:#fff; padding:.5em; font-size:.8em; border:1px solid #222;">
						If you already ran thru this process, please make sure the database <strong>"contactManager_GiancarloGomez_Derby"</strong> has been created in your cf admin.
						<br /><br />
						<strong>The error reported from the server is:</strong><br />
						<cfoutput>#request.exception.message#</cfoutput>
					</p>
				<cfelseif structKeyExists(request,"badpass")>
					Sorry but it appears the ColdFusion Admin Password you supplied is invalid. 
					Please open up the admin.ini file within the /setup/ folder, enter the administrator password and hit refresh on your browser.
					<br /><br />
					If you prefer you can enter the administrator password below and hit continue.
					<div class="editor" style="display:block; margin:1em 0;">
						<form action="./" method="post">
							<label for="password">ColdFusion Administrator Password</label>
							<input type="password" name="password" id="password" value="" style="width:300px;" />
							<div>
								<input type="submit" value="Create DataSource" />
							</div>
						</form>
					</div>
				<cfelse>
					You have succesfully created the Apache Derby Database. You can now start using your application.
					<p style="text-align:center;">
						<input type="button" value="Start Using App" onclick="location='../?reload=1';" />
					</p>	
				</cfif>
			</section>
		</div>
	</div>
</body>
</html>