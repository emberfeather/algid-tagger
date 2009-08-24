<cfcomponent extends="algid.inc.resource.application.configure" output="false">
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<!--- fresh => 0.1.000 --->
		<cfif arguments.installedVersion EQ ''>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_000() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.000
	--->
	<cffunction name="postgreSQL0_1_000" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- Tagger schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#tagger"
				AUTHORIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#tagger" IS 'Tagger Plugin Schema';
		</cfquery>
		
		<!---
			SEQUENCES
		--->
		
		<!--- Tag Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#tagger"."tag_tagID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tagger"."tag_tagID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Tag Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#tagger".tag
			(
				"tagID" integer NOT NULL DEFAULT nextval('"#variables.datasource.prefix#tagger"."tag_tagID_seq"'::regclass),
				tag character varying(50) NOT NULL,
				"isPluginOnly" boolean NOT NULL DEFAULT false,
				"createdOn" timestamp without time zone NOT NULL DEFAULT now(),
				CONSTRAINT "tag_PK" PRIMARY KEY ("tagID"),
				CONSTRAINT "tag_tag_u" UNIQUE (tag)
				CONSTRAINT "tag_tag_plugin_u" UNIQUE (tag, "isPluginOnly")
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
