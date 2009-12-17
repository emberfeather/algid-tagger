<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="createTag" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="tag" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var filter = '' />
		<cfset var results = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check Permissions --->
		
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
					and "isPluginOnly" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.tag.getIsPluginOnly()#" />
			</cfquery>
			
			<cfset arguments.tag.setTagID( results.tagID ) />
			
			<!--- Log the create event --->
			<cfset eventLog.logEvent('tagger', 'createTag', 'Created the ''' & arguments.tag.getTag() & ''' tag.', arguments.currUser.getUserID(), arguments.tag.getTagID()) />
		</cfif>
	</cffunction>
	
	<cffunction name="readTag" access="public" returntype="component" output="false">
		<cfargument name="tagID" type="numeric" required="true" />
		
		<cfset var i18n = '' />
		<cfset var results = '' />
		<cfset var tag = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "tagID", tag, "createdOn", "isPluginOnly"
			FROM "#variables.datasource.prefix#tagger"."tag"
			WHERE "tagID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tagID#" />
		</cfquery>
		
		<cfset tag = variables.transport.theApplication.factories.transient.getModTagForTagger(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
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
				and "tag" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.tag#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'filter')>
				and "tag" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.filter#%" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isPluginOnly')>
				and "isPluginOnly" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.filter.isPluginOnly#" />
			</cfif>
			
			orDER BY tag ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>