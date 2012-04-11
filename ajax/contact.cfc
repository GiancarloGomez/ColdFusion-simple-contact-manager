component  output="false"
{
	/**
	* @returnformat json
	*/
	remote query function getContacts(){
		setResponse();
		return EntitytoQuery(EntityLoad("Contact",{},"name ASC"));
	}
	
	/**
	* @returnformat json
	*/
	remote struct function create(
		string name,
		string email,
		string phone
	){
		var person = EntityNew("Contact");
		person.setName(arguments.name);	
		person.setEmail(arguments.email);
		person.setPhone(arguments.phone);
		EntitySave(person);
		setResponse();
		return person;
	}
	
	/**
	* @returnformat json
	*/
	remote struct function post(
		required numeric contactID,
		string name,
		string email,
		string phone
	){
		var person = "";
		if (arguments.contactID)
			person = EntityLoad("Contact",arguments.contactID,true);
		else
			person = EntityNew("Contact");
			
		// only update if valid person object
		if (isDefined("person")){
			person.setName(arguments.name);	
			person.setEmail(arguments.email);
			person.setPhone(arguments.phone);
			EntitySave(person);
		}
		setResponse();
		return person;
	}
	
	/**
	* @returnformat json
	*/
	remote boolean function delete(required numeric contactID){
		var person = EntityLoad("Contact",arguments.contactID,true);
		// only delete if valid person object
		if (isDefined("person"))
			EntityDelete(EntityLoad("Contact",arguments.contactID,true));
		setResponse();
		return true;
	}
	
	private void function setResponse(){
		var response = getPageContext().getResponse();
		sleep(250);
		response.setContentType("application/json");
	}
}