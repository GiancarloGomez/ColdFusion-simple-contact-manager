/**
*	@output		false
*	@entityname Contact
*	@table 		Contacts
*	@persistent true
*/
component 
{
	property name="contactID" fieldtype="id" generator="native";
	property name="name";
	property name="phone";
	property name="email";
}