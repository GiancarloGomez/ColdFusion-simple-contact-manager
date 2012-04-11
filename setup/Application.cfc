/**
*	@output "false"
*/
component
{
	
	public boolean function onRequestStart(string targetPage){
		var password = "";
		request.root = "../";
		try{
			// set or get admin api password from ini file (set if passed in form)
			if (structKeyExists(form,"password") && len(form.password)){
				password = form.password;
				SetProfileString(ExpandPath("admin.ini"),"admin","password",password);
			}else{
				password = GetProfileString(ExpandPath("admin.ini"),"admin","password");
			}
			
			// login to admin api
			var admin = createObject("component","cfide.adminapi.administrator").login(trim(password));
			
			if (!admin){
			// let the user know login was wrong
				request.badpass = true;
			}else{
			// go and create the db if it does not exists
				var db = createObject("component","cfide.adminapi.datasource");
				// create Derby DB and notify user
				if (!db.verifyDSN("contactManager_GiancarloGomez_Derby")){
					db.setDerbyEmbedded(
						name		: "contactManager_GiancarloGomez_Derby",
						database	: server.coldfusion.rootdir & "\db\contactManager_GiancarloGomez_Derby\",
						isnewdb		: true
					);
				}else{
				// already exists relocate to app home page
					location("../",false);
				}
			}
		}
		catch(Any e){
			request.error = "The following error occured when attempting to read the admin.ini file.<br />" & e.message;
		}
		
		return true;
	}
}