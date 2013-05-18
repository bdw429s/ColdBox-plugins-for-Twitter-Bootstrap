<cfcomponent hint="Twitter Bootstrap MessageBox" output="false" extends="coldbox.system.plugins.MessageBox" cache="true">

  <!------------------------------------------- CONSTRUCTOR ------------------------------------------->
	<cffunction name="init" access="public" returntype="Breadcrumbs" output="false" hint="constructor">
		<cfargument name="controller" type="any" required="true" />
		<cfscript>
			super.init(arguments.controller);
			// Plugin Properties
			setPluginName("Breadcrumbs");
			setPluginVersion("1.0");
			setPluginDescription("Twitter Bootstrapped Breadcrumbs");
			setPluginAuthor("Adrian J. Moreno");
			setPluginAuthorURL("http://iknowkungfoo.com");

			return this;
		</cfscript>
	</cffunction>

	<cffunction name="render" access="public" output="false" returntype="string" hint="I create a breadcrumb menu.">
		<cfargument name="crumbs" type="array" required="true" hint="Array of structs: [{url,label}]" />
		<cfargument name="active" type="string" required="true" hint="Text for active label (no link))." />
		<cfset var event = getRequestContext()>
		<cfset var results = "" />
		<cfset var crumb = {} />
		<cfsavecontent variable="results">
			<cfoutput>
				<ul class="breadcrumb">
					<cfloop array="#arguments.crumbs#" index="crumb">
						<cfif isStruct(crumb) AND !structIsEmpty(crumb)>
							<li><a href="#application.esapiEncoder.encodeForHTMLAttribute(event.buildLink(crumb.url))#">#application.esapiEncoder.encodeForHTML(crumb.label)#</a> <span class="divider">/</span></li>
						</cfif>
					</cfloop>
					<li class="active">#application.esapiEncoder.encodeForHTML(arguments.active)#</li>
				</ul>
			</cfoutput>
		</cfsavecontent>
		<cfreturn results />
	</cffunction>

</cfcomponent>
