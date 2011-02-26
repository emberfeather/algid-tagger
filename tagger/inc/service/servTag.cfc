<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getTag" access="public" returntype="component" output="false">
		<cfargument name="tagID" type="string" required="true" />
		
		<cfset var modelSerial = '' />
		<cfset var results = '' />
		<cfset var tag = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "tagID", tag, "createdOn", "isPluginOnly"
			FROM "#variables.datasource.prefix#tagger"."tag"
			WHERE "tagID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tagID#" null="#arguments.tagID eq ''#" />::uuid
		</cfquery>
		
		<cfset tag = getModel('tagger', 'tag') />
		
		<cfif results.recordCount>
			<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
			
			<cfset modelSerial.deserialize(results, tag) />
		</cfif>
		
		<cfreturn tag />
	</cffunction>
	
	<cffunction name="getTags" access="public" returntype="query" output="false">
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
			
			ORDER BY tag ASC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="setTag" access="public" returntype="void" output="false">
		<cfargument name="tag" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var filter = '' />
		<cfset var modelSerial = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('tagger', 'tag') />
		
		<!--- TODO Check Permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.tag) />
		
		<cfif arguments.tag.getTagID() eq ''>
			<!--- Check if it already exists --->
			<cfset filter = {
					tag = arguments.tag.getTag(),
					isPluginOnly = arguments.tag.getIsPluginOnly()
				} />
			
			<cfset results = getTags() />
			
			<cfif results.recordCount>
				<!--- If it already exists update the object --->
				<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
				
				<cfset modelSerial.deserialize(results, arguments.tag) />
				
				<!--- Skip the after save event --->
				<cfreturn />
			<cfelse>
				<!--- Does not exist, create it --->
				
				<!--- Create the new ID --->
				<cfset arguments.tag.setTagID( createUUID() ) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						INSERT INTO "#variables.datasource.prefix#tagger"."tag"
						(
							"tagID",
							"tag", 
							"isPluginOnly"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag.getTagID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag.getTag()#" />,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.tag.getIsPluginOnly()#" />
						)
					</cfquery>
				</cftransaction>
				
				<!--- After Create Event --->
				<cfset observer.afterCreate(variables.transport, arguments.tag) />
			</cfif>
		<cfelse>
			<!--- After Update Event --->
			<cfset observer.afterCreate(variables.transport, arguments.tag) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.tag) />
	</cffunction>
</cfcomponent>