<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	/* required content */
	public void function afterCreate( struct transport, component currUser, component tag ) {
		var eventLog = '';
		
		// Get the event log from the transport
		eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		// Log the create event
		eventLog.logEvent('tagger', 'createTag', 'Created the ''' & arguments.tag.getTag() & ''' tag.', arguments.currUser.getUserID(), arguments.tag.getTagID());
	}
</cfscript>
</cfcomponent>
