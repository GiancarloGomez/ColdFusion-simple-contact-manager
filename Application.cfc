/**
*	@output "false"
*/
component 
{
	
	this.name 			= "contactManager_GiancarloGomez";
	this.ormEnabled 	= true;	
	this.ormsettings	= {
		cfclocation	= "model",
		datasource 	= "contactManager_GiancarloGomez_Derby",
		dbcreate	= "dropcreate",
		dialect		=  "Derby"
	};
	
	/**
	*	@output "false"
	*/
	public boolean function onApplicationStart(){
		application.startTime 	= now();
		application.root 		= GetDirectoryFromPath(GetCurrentTemplatePath());
		application.reload		= true;
		return true;
	}
	
	public boolean function onRequestStart(string targetPage){
		
		if (structKeyExists(url,"reload")){
			ApplicationStop();
			location("./", false);			
		}
		
		// Lets get our contacts
		request.contacts = getData();
		
		return true;
	}
	
	public void function onError(Exception,EventName){
		var a = Exception;
		while(structKeyExists(a,"cause")){
			a = a["cause"];	
		}
		if(a["message"] == "Datasource not found."){
			// set or get admin api password from ini file (set if passed in form)
			var password = GetProfileString(ExpandPath("admin.ini"),"admin","password");			
			var admin = createObject("component","cfide.adminapi.administrator").login(trim(password));
			if (admin){
			var db = createObject("component","cfide.adminapi.datasource");
			var e = db.verifyDSN("contactManager_GiancarloGomez_Derby",true);
			if (e != "true")
				a.message = e;
			}
		}
		Exception = a;
		structAppend(request,arguments);
		request.root = "./";
		include "setup/index.cfm";
	}
	
	private query function getData(){
		local.q = EntitytoQuery(EntityLoad("Contact",{},"name ASC"));
		
		if (!local.q.recordCount && application.reload == true){
			// new records
			local.c = [
				EntityNew("Contact",{name="Giancarlo Gomez",email="jc@fusedevelopments.com",phone="305-610-9428"}),
				EntityNew("Contact",{name="Maria Gomez",email="maria@gomez.com",phone="305-555-1220"}),
				EntityNew("Contact",{name="Mailang Gomez",email="mailang@gomez.com",phone="305-555-1218"}),
				EntityNew("Contact",{name="John Doe",email="john.doe@gmail.com",phone="954-555-5656"}),
				EntityNew("Contact",{name="Jane Doe",email="jane.doe@gmail.com",phone="954-555-5677"}),
				EntityNew("Contact",{name="Mike Russell",email="mike@gmail.com",phone="201-222-2033"}),
				EntityNew("Contact",{name="James Taylor",email="jtaylor@fusedev.com",phone="305-610-5555"}),
				EntityNew("Contact",{name="Jillian Simpson",email="jsimpson@gmail.com",phone="305-123-5555"}),
				EntityNew("Contact",{name="Howard Stern",email="howard@howardstern.com",phone="201-111-1233"}),
				EntityNew("Contact",{name="Jason Mehler",email="jason@myboxproductions.com",phone="305-555-0999"}),
				EntityNew("Contact",{name="Ben Nadel",email="ben@bennadel.com",phone="201-333-3000"}),
				EntityNew("Contact",{name="Ben Forta",email="ben@forta.com",phone="123-111-1111"})
			];
			// insert each record
			for(i in local.c)
				EntitySave(i);
			application.reload = false;
			// get new dataset
			local.q = EntitytoQuery(EntityLoad("Contact",{},"name ASC"));
		}
		
		return local.q;
	}
	
}