<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Tag ID --->
		<cfset addAttribute(
				attribute = 'tagID',
				validation = {
				}
			) />
		
		<!--- createdOn --->
		<cfset addAttribute(
				attribute = 'createdOn',
				validation = {
				}
			) />
		
		<!--- isPluginOnly --->
		<cfset addAttribute(
				attribute = 'isPluginOnly',
				validation = {
				}
			) />
		
		<!--- Tag --->
		<cfset addAttribute(
				attribute = 'tag',
				validation = {
					minLength = 1,
					maxLength = 50
				}
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/tagger/i18n/inc/model', 'modTag') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>