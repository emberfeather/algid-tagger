<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var attr = '' />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Tag ID --->
		<cfset attr = {
				attribute = 'tagID',
				validation = {
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- createdOn --->
		<cfset attr = {
				attribute = 'createdOn',
				validation = {
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- isPluginOnly --->
		<cfset attr = {
				attribute = 'isPluginOnly',
				validation = {
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Tag --->
		<cfset attr = {
				attribute = 'tag',
				validation = {
					minLength = 1,
					maxLength = 50
				}
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/tagger/i18n/inc/model', 'modTag') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>