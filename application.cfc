<cfcomponent output="false">
	<cfset this.name = 'plugin-tagger' />
	<cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0) />
	<cfset this.clientManagement = false />
	<cfset this.sessionManagement = false />
	
	<!--- Set the mappings --->
	<cfset variables.mappingBase = getDirectoryFromPath( getCurrentTemplatePath() ) />
	
	<cfset this.mappings = {} />
	<cfset this.mappings['/cf-compendium'] = variables.mappingBase & 'cf-compendium' />
	<cfset this.mappings['/plugins'] = variables.mappingBase />
	<cfset this.mappings['/test'] = variables.mappingBase & 'test' />
	<cfset this.mappings['/varscoper'] = variables.mappingBase & 'varscoper' />
</cfcomponent>