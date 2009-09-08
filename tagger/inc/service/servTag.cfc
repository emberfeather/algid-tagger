<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createTag" access="public" returntype="void" output="false">
		<cfargument name="tag" type="component" required="true" />
		
		<cfset var filter = '' />
		<cfset var results = '' />
		
		<!--- Check if it already exists --->
		<cfset filter = {
				tag = arguments.tag.getTag(),
				isPluginOnly = arguments.tag.getIsPluginOnly()
			} />
		
		<cfset results = readTags() />
		
		<cfif results.recordCount>
			<!--- If it already exists update the object --->
			<cfset arguments.tag.deserialize(results) />
		<cfelse>
			<!--- Does not exist, create it --->
			<cfquery datasource="#variables.datasource.name#" result="results">
				INSERT INTO "#variables.datasource.prefix#tagger"."tag"
				(
					tag, 
					"isPluginOnly"
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag.getTag()#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.tag.getIsPluginOnly()#" />
				)
			</cfquery>
			
			<!--- Query the tagID --->
			<!--- TODO replace this with the new id from the insert results --->
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "tagID"
				FROM "#variables.datasource.prefix#tagger"."tag"
				WHERE tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag.getTag()#" />,
					AND "isPluginOnly" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.tag.getIsPluginOnly()#" />
			</cfquery>
			
			<cfset arguments.tag.setTagID( results.tagID ) />
		</cfif>
	</cffunction>
	
	<cffunction name="readTag" access="public" returntype="component" output="false">
		<cfargument name="tagID" type="numeric" required="true" />
		
		<cfset var results = '' />
		<cfset var tag = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "tagID", tag, "createdOn", "isPluginOnly"
			FROM "#variables.datasource.prefix#tagger"."tag"
			WHERE "tagID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tagID#" />
		</cfquery>
		
		<cfset tag = application.factories.transient.getModTagForTagger(variables.i18n, variables.locale) />
		
		<cfset tag.deserialize(results) />
		
		<cfreturn tag />
	</cffunction>
	
	<cffunction name="readTags" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "tagID", tag, "createdOn", "isPluginOnly"
			FROM "#variables.datasource.prefix#tagger"."tag"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'tag')>
				AND "tag" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.tag#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'filter')>
				AND "tag" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.filter#%" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isPluginOnly')>
				AND "isPluginOnly" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.filter.isPluginOnly#" />
			</cfif>
			
			ORDER BY tag ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>