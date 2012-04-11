<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Contact Manager</title>
	<link href="./includes/css/display.css" rel="stylesheet" type="text/css" />
	<link href="./includes/css/custom-theme/jquery-ui-1.8.18.custom.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div id="container">
		<div id="contact-manager" class="contact-manager">
			<!-- search form -->
			<h1>Awesome Contacts <small>CF+ JQUERY</small></h1>
			<div class="loading">
				Loading ...
			</div>
			<header>
				<div class="back">
					<a href="" data-role="cancel">&laquo; back</a>
				</div>
				<div class="search">
				<label for="searchtext">search:</label>
				<input type="text" name="searchtext" id="searchtext" />
				<a href="" class="create" data-role="create">create<span>contact</span> &raquo;</a>
				</div>
			</header>
			<section>
				<!-- records -->
				<ul class="records">
				<!--- 
				*	This is what gets output by the js app
				*	I decided to make the app load the data on page load
				*	even though I can just render it on server side with a quick query call (how I originally had it) 
				*	I decided not to as to make the app enclosed inside the jquery widget I built
				*	
				<cfoutput query="request.contacts">
				<li class="person" id="contact_#contactID#" data-id="#contactID#" data-row="#currentRow#">
					<div class="links">
						<a href="" data-role="more">more</a> |
						<a href="" data-role="edit">edit</a> |
						<a href="" data-role="delete">delete</a>
					</div>
					<span>#name#</span>
					<div class="data">
						<dl>
							<dt>name:</dt>
							<dd>#name#</dd>	
							<dt>phone:</dt>
							<dd>#phone#</dd>	
							<dt>email:</dt>
							<dd>#email#</dd>	
						</dl>	
					</div>
				</li>
				</cfoutput>
				--->
				</ul>	
				<!-- form -->
				<div class="editor">
					<form name="contactFrm" id="contactFrm" method="post" action="./">
						<input type="hidden" name="contactid" id="contactid" value="" />
						<label for="name">Name:</label>
						<input type="text" name="name" id="name" value="" class="required" title="Please enter the contact's name" />
						<label for="phone">Phone:</label>
						<input type="text" name="phone" id="phone" value="" class="required" title="Please enter the contact's phone number" />
						<label for="email">Email:</label>
						<input type="text" name="email" id="email" value="" class="required email" title="Please enter a valid email for the contact" />
						<div>
							<input type="submit" value="Save &amp; Close" /> (<a href="" class="cancel" data-role="cancel">cancel</a>)
						</div>
					</form>
				</div>
			</section>
		</div>
	</div>
	<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	<script type="text/javascript">window.jQuery || document.write('<script src="./includes/js/jquery/1.7.1.js"><\/script>');</script>
	<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
	<script type="text/javascript">window.jQuery.ui || document.write('<script src="./includes/js/jquery.ui/1.8.18.js"><\/script>');</script>
	<script type="text/javascript" src="./includes/js/jquery.throttle.js"></script>
	<script type="text/javascript" src="./includes/js/contact.manager.js"></script>
	<script type="text/javascript">
		$(function(){
			$('#contact-manager').contact_manager();
		});
	</script>
</body>
</html>