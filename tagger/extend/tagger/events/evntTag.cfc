<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	public void function afterCreate( required struct transport, required component currUser, required component tag ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the create event
		eventLog.logEvent('tagger', 'createTag', 'Created the ''' & arguments.tag.getTag() & ''' tag.', arguments.currUser.getUserID(), arguments.tag.getTagID());
	}
</cfscript>
</cfcomponent>
