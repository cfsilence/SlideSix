<cfcomponent displayName="utilities" output="false">
	<cffunction name="makeAlias" access="public" returnType="string" output="false"
				hint="Cleans up string for a safe alias.">
		<cfargument name="title" type="string" required="true">
		
		<!--- Remove non alphanumeric but keep spaces. --->
		<cfset arguments.title = reReplace(arguments.title,"[^0-9a-zA-Z ]","","all")>
		<!--- change spaces to - --->
		<cfset arguments.title = replace(arguments.title," ","-","all")>
		
		<cfreturn arguments.title>
	</cffunction>
	
	<cffunction name="isInCFThread" access="public" returntype="boolean" hint="returns true if the current thread is a cftread, false otherwise" output="false">
		<cfset var thread = createObject("java", "java.lang.Thread") />
		<cfif thread.currentThread().getThreadGroup().getName() eq "cfthread">
			<cfreturn true />
		</cfif>
		<cfreturn false />
	</cffunction>
	
	<cffunction name="addUnauthHeader" access="public" returnType="void" output="false">
		<cfheader statuscode="401" statustext="Unauthorized" />
	</cffunction>
	
	<cffunction name="cleanTag" access="public" returnType="string" output="false"
				hint="Cleans up string for a safe tag.">
		<cfargument name="str" type="string" required="true">
		
		<!--- Remove non alphanumeric but keep spaces. --->
		<cfset arguments.str = reReplace(arguments.str,"[^0-9a-zA-Z ]","","all")>
		
		<cfreturn arguments.str>
	</cffunction>
	<cfscript>
	public function getStrippedUUID(){
		return replaceNoCase(createUUID(), '-', '', 'all');
	}
	
	public function cleanVarForPaging(value,def=1){
		var v = htmlEditFormat(trim(arguments.value));
		v = reReplaceNoCase(v,"[^0-9]", "", "all"); 
		return !isNumeric(v) ? def : v;
	}
	
	function googleChartSimpleEncode(data) {
	    var maxdata = 0;
	    var i = 0;
	    var currentvalue = "";
	    var str = "s:";
	    var simpleEncoding = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	    var thepos = "";
	    var thechar = "";
	
	    for(i=1;i <= arrayLen(data); i++) {
	        if(data[i] gt maxdata) maxdata = data[i];
	    }
	
	    for(i=1; i <= arrayLen(data); i++) {
	        currentvalue = data[i];
	        if (isNumeric(currentValue) && currentValue >= 0) {
	            thepos = round((len(simpleEncoding)-1) * currentvalue/maxdata);
	            thechar = mid(simpleEncoding,thepos+1,1);
	            str &= thechar;
	        } else {
	            str &= "_";
	        }
	    }
	    
	    return str;
	}
	function prettyDate(d){
	var date = now();
	var diff = dateDiff("s", d, date);
	var day_diff = dateDiff("d", d, date);
	var month_diff = dateDiff("m", d, date);
	var rStr = "";
	
	if ( not isNumeric(day_diff) or day_diff < 0)
		return sStr;
			
	
	if (diff lt 60) rStr = "just now";
	if (diff gt 60 and diff lt 120 and month_diff lt 1) rStr = "1 minute ago";
	if (diff gt 120 and diff lt 3600 and month_diff lt 1) rStr = int(diff / 60) & " minutes ago";
	if (diff gt 3600 and diff lt 7200 and month_diff lt 1) rStr = "1 hour ago";
	if (diff gt 7200 and diff lt 86400 and month_diff lt 1) rStr = int(diff / 3600) & " hours ago";
	if (diff gt 86400 and day_diff eq 1 and month_diff lt 1) rStr = "Yesterday";
	if (diff gt 86400 and day_diff gt 1 and day_diff lt 7 and month_diff lt 1) rStr = day_diff & " days ago";
	if (diff gt 86400 and day_diff eq 7 and month_diff lt 1) rStr = "1 week ago";
	if (diff gt 86400 and day_diff gt 7 and day_diff lt 31 and month_diff lt 12) rStr = ceiling(day_diff / 7) & " weeks ago";
	if (diff gt 86400 and month_diff eq 1) rStr = "about a month ago";
	if (diff gt 86400 and month_diff gt 1 and month_diff lte 12) rStr = month_diff & " months ago";
	if (diff gt 86400 and month_diff gt 12) rStr = "a long time ago";
	
	return rStr;	
}
	/**
	* An enhanced version of left() that doesn't cut words off in the middle.
	* Minor edits by Rob Brooks-Bilson (rbils@amkor.com) and Raymond Camden (rbils@amkor.comray@camdenfamily.com)
	*
	* Updates for version 2 include fixes where count was very short, and when count+1 was a space. Done by RCamden.
	*
	* @param str      String to be checked.
	* @param count      Number of characters from the left to return.
	* @return Returns a string.
	* @author Marc Esher (rbils@amkor.comray@camdenfamily.comjonnycattt@aol.com)
	* @version 2, April 16, 2002
	*/
	function fullLeft(str, count) {
	    if (not refind("[[:space:]]", str) or (count gte len(str)))
	        return Left(str, count);
	    else if(reFind("[[:space:]]",mid(str,count+1,1))) {
	         return left(str,count);
	    } else {
	        if(count-refind("[[:space:]]", reverse(mid(str,1,count)))) return Left(str, (count-refind("[[:space:]]", reverse(mid(str,1,count)))));
	        else return(left(str,1));
	    }
	}
	/**
	* Converts any numeric string (even ones with currancy symbols to a number).
	*
	* @param strVal      Value to convert. (Required)
	* @return Returns a number.
	* @author Glenn Wilson (glenn.wilson@quotegen.com)
	* @version 1, November 15, 2002
	*/
	function Convert2Number(StrVal){
		var regStr = "[^/.0123456789-]";
		return Fix(Val(REReplace(StrVal,regStr,"","all")));
	}
	/**
	* Returns the content enclosed in a tag pair.
	*
	* @param tag      The tag to look for. Should be passed without < or > and without attributes. (Required)
	* @param string      The string to search. (Required)
	* @return Returns a string.
	* @author Johan Steenkamp (johan@orbital.co.nz)
	* @version 1, September 16, 2002
	*/
	function getTagContent(tag,str) {
	    var matchStruct = structNew();
	    var startTag = "<#tag#[^>]*>";
	    var endTag = "</#tag#>";
	    var endTagStart = 0;
	    matchStruct = REFindNoCase(startTag,str,1,"true");
	    if(matchStruct.len[1] eq 0 ) return "";
	    endTagStart = REFindNoCase(endTag,str,matchStruct.pos[1],"false");
	    return Mid(str,matchStruct.pos[1]+matchStruct.len[1],endTagStart-matchStruct.pos[1]-matchStruct.len[1]);
	}

	function HtmlCompressFormat(sInput)
	{
	var level = 2;
	if( arrayLen( arguments ) GTE 2 AND isNumeric(arguments[2]))
	{
	level = arguments[2];
	}
	// just take off the useless stuff
	sInput = trim(sInput);
	switch(level)
	{
	case "3":
	{
	// extra compression can screw up a few little pieces of HTML, doh
	sInput = reReplace( sInput, "[[:space:]]{2,}", " ", "all" );
	sInput = replace( sInput, "&gt; &lt;", "&gt;&lt;", "all" );
	sInput = reReplace( sInput, "&lt;!--[^&gt;]+&gt;", "", "all" );
	break;
	}
	case "2":
	{
	sInput = reReplace( sInput, "[[:space:]]{2,}", chr( 13 ), "all" );
	break;
	}
	case "1":
	{
	// only compresses after a line break
	sInput = reReplace( sInput, "(" & chr( 10 ) & "|" & chr( 13 ) & ")+[[:space:]]{2,}", chr( 13 ), "all" );
	break;
	}
	}
	return sInput;
	}
	
	/**
	 * Returns a random alphanumeric string of a user-specified length.
	 * 
	 * @param stringLenth 	 Length of random string to generate. (Required)
	 * @return Returns a string. 
	 * @author Kenneth Rainey (kip.rainey@incapital.com) 
	 * @version 1, February 3, 2004 
	 */
	 
	function getRandString(stringLength) {
		var tempAlphaList = "a|b|c|d|g|h|k|m|n|p|q|r|s|t|u|v|w|x|y|z|A|B|C|D|G|H|K|P|Q|R|T|U|V|W|X|Y|Z";
		var tempNumList = "2|3|4|8";
		var tempCompositeList = tempAlphaList&"|"&tempNumList;
		var tempCharsInList = listLen(tempCompositeList,"|");
		var tempCounter = 1;
		var tempWorkingString = "";
		
		//loop from 1 to stringLength to generate string
		while (tempCounter LTE stringLength) {
			tempWorkingString = tempWorkingString&listGetAt(tempCompositeList,randRange(1,tempCharsInList),"|");
			tempCounter = tempCounter + 1;
		}
		
		return tempWorkingString;
	}
	/**
	 * An &quot;enhanced&quot; version of ParagraphFormat.
	 * Added replacement of tab with nonbreaking space char, idea by Mark R Andrachek.
	 * Rewrite and multiOS support by Nathan Dintenfas.
	 * 
	 * @param string 	 The string to format. (Required)
	 * @return Returns a string. 
	 * @author Ben Forta (ben@forta.com) 
	 * @version 3, June 26, 2002 
	 */
	function ParagraphFormat2(str) {
		//first make Windows style into Unix style
		str = replace(str,chr(13)&chr(10),chr(10),"ALL");
		//now make Macintosh style into Unix style
		str = replace(str,chr(13),chr(10),"ALL");
		//now fix tabs
		str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
		//now return the text formatted in HTML
		return replace(str,chr(10),"<br />","ALL");
	}
	function stripHTML(str) {
	    var i = 1;
	    var action = 'strip';
	    var tagList = '';
	    var tag = '';
	    
	    if (ArrayLen(arguments) gt 1 and lcase(arguments[2]) eq 'preserve') {
	        action = 'preserve';
	    }
	    if (ArrayLen(arguments) gt 2) tagList = arguments[3];
	
	    if (trim(lcase(action)) eq "preserve") {
	        // strip only those tags in the tagList argument
	        for (i=1;i lte listlen(tagList); i = i + 1) {
	            tag = listGetAt(tagList,i);
	            str = REReplaceNoCase(str,"</?#tag#.*?>","","ALL");
	        }
	    } else {
	        // strip all, except those in the tagList argument
	        // if there are exclusions, mark them with NOSTRIP
	        if (tagList neq "") {
	            for (i=1;i lte listlen(tagList); i = i + 1) {
	                tag = listGetAt(tagList,i);
	                str = REReplaceNoCase(str,"<(/?#tag#.*?)>","___TEMP___NOSTRIP___\1___TEMP___ENDNOSTRIP___","ALL");
	                str = REReplaceNoCase(str,"<!(/?#tag#.*?)>","___TEMP___NOSTRIP___\1___TEMP___ENDNOSTRIP___","ALL");
	            }
	        }
	        // strip all remaining tsgs. This does NOT strip comments
	        str = reReplaceNoCase(str,"</{0,1}[A-Z].*?>","","ALL");
	        // strip doctype
	        str = reReplaceNoCase(str,"<!DOCTYPE[^>]*>","","ONE");
	        // convert unstripped back to normal
	        str = replace(str,"___TEMP___NOSTRIP___","<","ALL");
	        str = replace(str,"___TEMP___ENDNOSTRIP___",">","ALL");
	    }
	    
	    return str;    
	}

	/**
	* Removes All HTML from a string removing tags, script blocks, style blocks, and replacing special character code.
	*
	* @param source      String to format. (Required)
	* @return Returns a string.
	* @author Scott Bennett (scott@coldfusionguy.com)
	* @version 1, November 14, 2007
	*/
	function removeHTML(source){
    
	    // Remove all spaces becuase browsers ignore them
	    var result = ReReplace(trim(source), "[[:space:]]{2,}", " ","ALL");
	    
	    // Remove the header
	    result = ReReplace(result, "<[[:space:]]*head.*?>.*?</head>","", "ALL");
	    
	    // remove all scripts
	    result = ReReplace(result, "<[[:space:]]*script.*?>.*?</script>","", "ALL");
	    
	    // remove all styles
	    result = ReReplace(result, "<[[:space:]]*style.*?>.*?</style>","", "ALL");
	    
	    // insert tabs in spaces of <td> tags
	    result = ReReplace(result, "<[[:space:]]*td.*?>","    ", "ALL");
	    
	    // insert line breaks in places of <BR> and <LI> tags
	    result = ReReplace(result, "<[[:space:]]*br[[:space:]]*>",chr(13), "ALL");
	    result = ReReplace(result, "<[[:space:]]*li[[:space:]]*>",chr(13), "ALL");
	    
	    // insert line paragraphs (double line breaks) in place
	    // if <P>, <DIV> and <TR> tags
	    result = ReReplace(result, "<[[:space:]]*div.*?>",chr(13), "ALL");
	    result = ReReplace(result, "<[[:space:]]*tr.*?>",chr(13), "ALL");
	    result = ReReplace(result, "<[[:space:]]*p.*?>",chr(13), "ALL");
	    
	    // Remove remaining tags like <a>, links, images,
	    // comments etc - anything thats enclosed inside < >
	    result = ReReplace(result, "<.*?>","", "ALL");
	    
	    // replace special characters:
	    result = ReReplace(result, "&nbsp;"," ", "ALL");
	    result = ReReplace(result, "&bull;"," * ", "ALL");
	    result = ReReplace(result, "&lsaquo;","<", "ALL");
	    result = ReReplace(result, "&rsaquo;",">", "ALL");
	    result = ReReplace(result, "&trade;","(tm)", "ALL");
	    result = ReReplace(result, "&frasl;","/", "ALL");
	    result = ReReplace(result, "&lt;","<", "ALL");
	    result = ReReplace(result, "&gt;",">", "ALL");
	    result = ReReplace(result, "&copy;","(c)", "ALL");
	    result = ReReplace(result, "&reg;","(r)", "ALL");
	    
	    // Remove all others. More special character conversions
	    // can be added above if needed
	    result = ReReplace(result, "&(.{2,6});", "", "ALL");
	    
	    // Thats it.
	    return result;
	
	}
	
	/**
	* Pass in a value in bytes, and this function converts it to a human-readable format of bytes, KB, MB, or GB.
	* Updated from Nat Papovich's version.
	* 01/2002 - Optional Units added by Sierra Bufe (sierra@brighterfusion.com)
	*
	* @param size      Size to convert.
	* @param unit      Unit to return results in. Valid options are bytes,KB,MB,GB.
	* @return Returns a string.
	* @author Paul Mone (sierra@brighterfusion.compaul@ninthlink.com)
	* @version 2.1, January 7, 2002
	*/
	function byteConvert(num) {
	    var result = 0;
	    var unit = "";
	    
	    // Set unit variables for convenience
	    var bytes = 1;
	    var kb = 1024;
	    var mb = 1048576;
	    var gb = 1073741824;
	
	    // Check for non-numeric or negative num argument
	    if (not isNumeric(num) OR num LT 0)
	        return "Invalid size argument";
	    
	    // Check to see if unit was passed in, and if it is valid
	    if ((ArrayLen(Arguments) GT 1)
	        AND ("bytes,KB,MB,GB" contains Arguments[2]))
	    {
	        unit = Arguments[2];
	    // If not, set unit depending on the size of num
	    } else {
	         if (num lt kb) {    unit ="bytes";
	        } else if (num lt mb) {    unit ="KB";
	        } else if (num lt gb) {    unit ="MB";
	        } else {    unit ="GB";
	        }        
	    }
	    
	    // Find the result by dividing num by the number represented by the unit
	    result = num / Evaluate(unit);
	    
	    // Format the result
	    if (result lt 10)
	    {
	        result = NumberFormat(Round(result * 100) / 100,"0.00");
	    } else if (result lt 100) {
	        result = NumberFormat(Round(result * 10) / 10,"90.0");
	    } else {
	        result = Round(result);
	    }
	    // Concatenate result and unit together for the return value
	    return (result & " " & unit);
	}

	</cfscript>
	
	<cffunction name="queryRowToStruct" access="public" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		
		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 * 
			 * @param query 	 The query to work with. 
			 * @param row 	 Row number to check. Defaults to row 1. 
			 * @return Returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, December 11, 2001 
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			//return the struct
			return stReturn;
		</cfscript>
	</cffunction>
	
	<cffunction name="getTinyURL" access="public" output="false" returntype="string">
		<cfargument name="theurl" required="true" />	
		<cfset var apiURL = "http://tinyurl.com/api-create.php?url=" & URLEncodedFormat(arguments.theurl) />
		<cfhttp url="#apiURL#" />
		<cfreturn cfhttp.filecontent />
	</cffunction>
	
	
	<cffunction name="getHostFromURL" access="public" output="false" returntype="string">
		<cfargument name="url" required="false" default="" />
		<cfset var jURL = "" />
		<cfif len(arguments.url)>
			<cfset jURL = createObject("java", "java.net.URL").init(arguments.url) />
			<cfreturn jURL.getHost() />
		<cfelse>
			<cfreturn ""/>
		</cfif>
	</cffunction>
	<cffunction name="toSeconds" access="public" output="false" returntype="numeric">
		<cfargument name="time" required="true" />
		<cfreturn (hour(arguments.time)*3600) + (minute(arguments.time)*60) + (second(arguments.time)) />
	</cffunction>
	
	<cffunction name="arrFind" access="public" output="false" returntype="numeric">
		<cfargument name="arr" required="true" type="array" />
		<cfargument name="valueToFind" required="true" type="any" />
		<cfreturn (arguments.arr.indexOf(arguments.valueToFind)) + 1 />
	</cffunction>
	
	<cffunction name="removeNonPrintingCharacters" output="false" returntype="string" access="public">
		<cfargument name="str" required="true" hint="the string from which to remove non-printing characters" />
		<cfreturn REReplaceNoCase(arguments.str,"[\x00-\x1F]", "", "all") />
	</cffunction>
	
	<!---
	This library is part of the Common Function Library Project. An open source
		collection of UDF libraries designed for ColdFusion 5.0 and higher. For more information,
		please see the web site at:
			
			http://www.cflib.org
			
		Warning:
		You may not need all the functions in this library. If speed
		is _extremely_ important, you may want to consider deleting
		functions you do not plan on using. Normally you should not
		have to worry about the size of the library.
			
		License:
		This code may be used freely. 
		You may modify this code as you see fit, however, this header, and the header
		for the functions must remain intact.
		
		This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
	--->

	<!---
	 Converts valid xml and valid xhtml to json
	 
	 @param xml 	 XML to convert. (Optional)
	 @param includeFormatting 	 Boolean value that determines if tabs, line feeds, and carriage returns should be preserved. Defaults to false. (Optional)
	 @return Returns a string. 
	 @author Tony Felice (tfelice@reddoor.biz) 
	 @version 0, February 27, 2009 
	--->
	<cffunction name="xmlToJson" output="false" returntype="any" hint="convert xml to JSON">
		<cfargument name="xml" default="" required="false" hint="raw xml"/>
		<cfargument name="includeFormatting" type="boolean" default="false" required="false" hint="whether or not to maintain and encode tabs, linefeeds and carriage returns"/>
		<cfset var result ="">
		<cfset var xsl ="">
		<cfsavecontent variable="xsl">
			<cfoutput>
			<?xml version="1.0" encoding="UTF-8"?>
			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
				<xsl:output indent="no" omit-xml-declaration="yes" method="text" encoding="UTF-8" media-type="application/json"/>
				<xsl:strip-space elements="*"/>
			
				<!-- used to identify unique children in Muenchian grouping, credit Martynas Jusevicius http://www.xml.lt -->
				<xsl:key name="elements-by-name" match="@* | *" use="concat(generate-id(..), '@', name(.))"/>
			
				<!-- string -->
				<xsl:template match="text()">
					<xsl:call-template name="processValues">
						 <xsl:with-param name="s" select="."/>
					</xsl:call-template>
				</xsl:template>
			
				<!-- text values (from text nodes and attributes) -->
				<xsl:template name="processValues">
					<xsl:param name="s"/>
					<xsl:choose>
						<!-- number -->
						<xsl:when test="not(string(number($s))='NaN')">
							<xsl:value-of select="$s"/>
						</xsl:when>			
						<!-- boolean -->
						<xsl:when test="translate($s,'TRUE','true')='true'">true</xsl:when>
						<xsl:when test="translate($s,'FALSE','false')='false'">false</xsl:when>			
						<!-- string -->
						<xsl:otherwise>
							<xsl:call-template name="escapeArtist">
								<xsl:with-param name="s" select="$s"/>
							</xsl:call-template>
						</xsl:otherwise>			
					</xsl:choose>
				</xsl:template>
			
				<!-- begin filter chain -->
				<xsl:template name="escapeArtist">
					<xsl:param name="s"/>
					"
					<xsl:call-template name="escapeBackslash">
						<xsl:with-param name="s" select="$s"/>
					</xsl:call-template>
					"
				</xsl:template>
			
				<!-- escape the backslash (\) before everything else. -->
				<xsl:template name="escapeBackslash">
					<xsl:param name="s"/>
					<xsl:choose>
						<xsl:when test="contains($s,'\')">
							<xsl:call-template name="escapeQuotes">
								<xsl:with-param name="s" select="concat(substring-before($s,'\'),'\\')"/>
							</xsl:call-template>
							<xsl:call-template name="escapeBackslash">
								<xsl:with-param name="s" select="substring-after($s,'\')"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="escapeQuotes">
								<xsl:with-param name="s" select="$s"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:template>
			
				<!-- escape the double quote ("). -->
				<xsl:template name="escapeQuotes">
					<xsl:param name="s"/>
					<xsl:choose>
						<xsl:when test="contains($s,'&quot;')">
							<xsl:call-template name="encoder">
								<xsl:with-param name="s" select="concat(substring-before($s,'&quot;'),'\&quot;')"/>
							</xsl:call-template>
							<xsl:call-template name="escapeQuotes">
								<xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="encoder">
								<xsl:with-param name="s" select="$s"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:template>
			
				<!-- encode tab, line feed and/or carriage return-->
				<xsl:template name="encoder">
					<xsl:param name="s"/>
					<xsl:choose>
						<!-- tab -->
						<xsl:when test="contains($s,'&##x9;')">
							<xsl:call-template name="encoder">
								<xsl:with-param name="s" select="concat(substring-before($s,'&##x9;'),'<cfoutput>#iif(arguments.includeFormatting,DE("\t"),DE(" "))#</cfoutput>',substring-after($s,'&##x9;'))"/>
							</xsl:call-template>
						</xsl:when>			
						<!-- line feed -->
						<xsl:when test="contains($s,'&##xA;')">
							<xsl:call-template name="encoder">
								<xsl:with-param name="s" select="concat(substring-before($s,'&##xA;'),'<cfoutput>#iif(arguments.includeFormatting,DE("\n"),DE(" "))#</cfoutput>',substring-after($s,'&##xA;'))"/>
							</xsl:call-template>
						</xsl:when>			
						<!-- carriage return -->
						<xsl:when test="contains($s,'&##xD;')">
							<xsl:call-template name="encoder">
								<xsl:with-param name="s" select="concat(substring-before($s,'&##xD;'),'<cfoutput>#iif(arguments.includeFormatting,DE("\r"),DE(" "))#</cfoutput>',substring-after($s,'&##xD;'))"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
					</xsl:choose>
				</xsl:template>
				
				<!-- main handler template
					creates a struct containing: the node text(); struct of attributes; and set a struct key for any node children. 
					this template then drills into the children, repeating itself until complete
				-->
				<xsl:template name="processNode">
					{
						"text":	
						<xsl:call-template name="escapeArtist">
							<xsl:with-param name="s" select="key('elements-by-name', concat(generate-id(..), '@', name(.)))/text()"/>
						</xsl:call-template>
						,"attributes":{				
							<xsl:for-each select="@*">
								<xsl:call-template name="escapeArtist">
									<xsl:with-param name="s" select="name()"/>
								</xsl:call-template>
								:						
								<xsl:call-template name="processValues">
									<xsl:with-param name="s" select="."/>
								</xsl:call-template>
								<xsl:if test="position() &lt; count(parent::node()/attribute::*)">
									,
								</xsl:if>
							</xsl:for-each>
						}
						<!-- drill down the tree -->
						<xsl:for-each select="*[generate-id(.) = generate-id(key('elements-by-name', concat(generate-id(..), '@', name(.))))]">
							,
							<xsl:call-template name="escapeArtist">
								<xsl:with-param name="s" select="name()"/>
							</xsl:call-template>
							:						
							<xsl:apply-templates select="."/>				
						</xsl:for-each>
					}
				</xsl:template>
				
				<!-- main parser
					basically a node 'loop' - performed once for all matches of *, so once for each node including the root.
					note: this loop has no knowledge of other iterations it may have performed.
				-->
				<xsl:template match="*">
					<!-- determine whether any peers share the node name, so we can spool off into 'array mode' -->
					<xsl:variable name="isArray" select="count(key('elements-by-name', concat(generate-id(..), '@', name(.)))) &gt; 1"/>
					
					<xsl:if test="count(ancestor::node()) = 1"><!-- begin the root node-->
						{ 
						<xsl:call-template name="escapeArtist">
							<xsl:with-param name="s" select="name()"/>
						</xsl:call-template>
						:		
					</xsl:if>				
					
					<xsl:if test="not($isArray)">
						<xsl:call-template name="processNode">
							<xsl:with-param name="s" select="."/>
						</xsl:call-template>
					</xsl:if>				
					<xsl:if test="$isArray">
						[
							<xsl:apply-templates select="key('elements-by-name', concat(generate-id(..), '@', name(.)))" mode="array"/>
						]
					</xsl:if>		
					<xsl:if test="count(ancestor::node()) = 1">}</xsl:if><!-- close the root node -->		
				</xsl:template>
				
				<!-- array template called from main parser -->
				<xsl:template match="*" mode="array">	
					<xsl:call-template name="processNode">
						<xsl:with-param name="s" select="."/>
					</xsl:call-template>
					<xsl:if test="position() != last()">,</xsl:if>				
				</xsl:template>
				
			</xsl:stylesheet>
			</cfoutput>
		</cfsavecontent>
		<cfset xsl = xmlParse(reReplace(xsl,'([\s\S\w\W]*)(<\?xml)','\2','all'))>
		<cfscript>		
			result = arguments.xml;
			result = reReplace(result,'([\s\S\w\W]*)(<\?xml)','\2','all');
			result = xmlTransform(trim(result),xsl);
			return trim(result);
		</cfscript>
	</cffunction>

	<cffunction name="isiPhone" output="false" returntype="boolean" hint="">
		<cfif findNoCase("iphone", cgi.http_user_agent) or findNoCase("ipod",
cgi.http_user_agent)>
    		<cfreturn true />   	
		</cfif>
		<cfreturn false />
	</cffunction>
	
	<cffunction name="ormList" output="false">
		<cfargument name="list" />
		<cfargument name="type" default="int" />
		<cfset var result = [] />
		<cfset var i = "" />
		<cfloop list="#arguments.list#" index="i">
			<cfset arrayAppend(result, javaCast(type, i)) />
		</cfloop>
		<cfreturn result.toArray() />
	</cffunction>
	
</cfcomponent>