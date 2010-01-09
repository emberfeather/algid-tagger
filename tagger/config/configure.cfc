<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<cfset var versions = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- fresh => 0.1.0 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.0') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_0() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.0
	--->
	<cffunction name="postgreSQL0_1_0" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- Tagger schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#tagger"
				AUTHorIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#tagger" IS 'Tagger Plugin Schema';
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Tag Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#tagger".tag
			(
				"tagID" uuid NOT NULL,
				tag character varying(50) not NULL,
				"isPluginOnly" boolean not NULL DEFAUlt false,
				"createdOn" timestamp without time zone not NULL DEFAUlt now(),
				CONSTRAINT "tag_PK" PRIMARY KEY ("tagID"),
				CONSTRAINT "tag_tag_U" UNIQUE (tag),
				CONSTRAINT "tag_tag_plugin_U" UNIQUE (tag, "isPluginOnly")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tagger".tag OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#tagger".tag IS 'Tag information.';
		</cfquery>
	</cffunction>
</cfcomponent>
