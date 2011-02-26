<cfcomponent extends="algid.inc.resource.base.event" output="false">
<cfscript>
	public void function afterCreate( required struct transport, required component tag ) {
		local.eventLog = arguments.transport.theApplication.managers.singleton.getEventLog();
		
		local.eventLog.logEvent('tagger', 'createTag', 'Created the ''' & arguments.tag.getTag() & ''' tag.', arguments.transport.theSession.managers.singleton.getUser().getUserID(), arguments.tag.getTagID());
	}
</cfscript>
</cfcomponent>
