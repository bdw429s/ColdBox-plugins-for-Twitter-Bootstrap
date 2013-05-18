<cfcomponent hint="Twitter Bootstrap MessageBox" output="false" extends="coldbox.system.plugins.MessageBox" cache="true">

  <!------------------------------------------- CONSTRUCTOR ------------------------------------------->
	<cffunction name="init" access="public" returntype="MessageBox" output="false" hint="constructor">
		<cfargument name="controller" type="any" required="true" />
		<cfscript>
			super.init(arguments.controller);
			// Plugin Properties
			setPluginName("MessageBox");
			setPluginVersion("2.1.1"); 
			setPluginDescription("Twitter Bootstrapped MessageBox");
			setPluginAuthor("Adrian J. Moreno");
			setPluginAuthorURL("http://iknowkungfoo.com");

			return this;
		</cfscript>
	</cffunction>
	
	<!--- PUBLIC --->
	
	<!--- Set a message --->
	<cffunction name="setMessage" access="public" hint="Create a new MessageBox. Look at types." output="false" returntype="void">
		<!--- ************************************************************* --->
		<cfargument name="type"     	required="true"   type="string" hint="The message type.Available types [error][warning][info]">
		<cfargument name="message"  	required="false"  type="string" default="" hint="The message to show.">
		<cfargument name="messageArray" required="false"  type="Array"  hint="You can also send in an array of messages to render separated by a <br />">
		<!--- ************************************************************* --->
		<cfscript>
			var msg = structnew();
			
			// check message type
			if( isValidMessageType(arguments.type) ){
				// Populate message
				msg.type 	= arguments.type;
				msg.message = arguments.message;
				
				// Do we have a message array to flatten?
				if( structKeyExists(arguments,"messageArray") AND arrayLen(arguments.messageArray) ){
					msg.message = flattenMessageArray(arguments.messageArray);
				}
				
				// Flash it
				flash.put(name=instance.flashKey,value=msg,inflateToRC=false,saveNow=true,autoPurge=false);
				
			}
			else{
				$throw("The message type is invalid: #arguments.type#","Valid types are info,error or warning","MessageBox.InvalidMessageType");
			}
		</cfscript>
	</cffunction>
	
	<!--- Render It : Twitter Bootstrap Alert Styling --->
	<cffunction name="renderit" access="public" hint="Renders the message box and clears the message structure by default." output="false" returntype="any">
		<!--- ************************************************************* --->
		<cfargument name="clearMessage" type="boolean" required="false" default="true" hint="Flag to clear the message structure or not after rendering. Default is true.">
		<!--- ************************************************************* --->
		<cfset var msgStruct = getMessage()>
		<cfset var results = "">
		<cfset var msgClass = "alert" />
		
		<cfif msgStruct.type.length() neq 0>
			<cfif msgStruct.type NEQ "warning">
				<cfset msgClass &= " alert-" & msgStruct.type />
			</cfif>
			<cfsavecontent variable="results">
				<cfoutput><div class="#msgClass#"><button class="close" data-dismiss="alert">×</button>#msgStruct.message#</div></cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfset results = "">
		</cfif>
		
		<!--- Test to clear message structure from flash? --->
		<cfif arguments.clearMessage>
			<cfset flash.remove(name=instance.flashKey,saveNow=true)>
		</cfif>
		
		<!--- Return Message --->
		<cfreturn results>
	</cffunction>
	
	<!--- renderMessage --->
	<cffunction name="renderMessage" access="public" hint="Renders a messagebox immediately for you with the passed in arguments" output="false" returntype="any">
		<!--- ************************************************************* --->
		<cfargument name="type"     	required="true"   type="string" hint="The message type.Available types [error][warning][info]">
		<cfargument name="message"  	required="false"  type="string" default="" hint="The message to show.">
		<cfargument name="messageArray" required="false"  type="Array"  hint="You can also send in an array of messages to render separated by a <br />">
		<!--- ************************************************************* --->
		<cfset var msgStruct = structnew()>
		<cfset var i = 0>
		<cfset var results = "">
		
		<!--- Verify Message Type --->
		<cfif isValidMessageType(arguments.type)>
			<!--- Populate message struct --->
			<cfset msgStruct.type = arguments.type>
			<cfset msgStruct.message = arguments.message>			
		<cfelse>
			<cfthrow message="Invalid message type: #arguments.type#" detail="Valid types are info,warning,error" type="Messagebox.InvalidMessageType">
		</cfif>
		
		<!--- Array Check --->
		<cfif structKeyExists(arguments, "messageArray")>
			<cfset msgStruct.message = flattenMessageArray(arguments.messageArray)>
		</cfif>
			
		<cfsavecontent variable="results"><cfinclude template="/coldbox/system/includes/messagebox/MessageBox.cfm"></cfsavecontent>
		
		<cfreturn results>		
	</cffunction>
	
	<!--- PRIVATE --->
	<cffunction name="isValidMessageType" access="private" output="false" returntype="string" hint="Addresses the four alert states defined by Twitter Bootstrap">
		<cfargument name="type" type="string" required="true" />
		<cfreturn refindnocase("(warning|error|success|info)", trim(arguments.type)) /> 
	</cffunction>

</cfcomponent>
