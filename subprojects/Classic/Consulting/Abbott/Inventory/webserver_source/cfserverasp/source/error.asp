<%' Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved
'DO NOT EDIT THIS FILE%>

<%
strFormMode = Request("error_number")
if strFormMode = "paths" then
appname = request("Appname")
end if
%>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
<title>Error</title>
</head>

<BODY>
<%Select Case strFormMode%>

<%Case "NoSession"%>

<H2>Error: Session Timeout Error <BR>
<BR>
</H2>

<P>&nbsp;</P>

<P>Your Session has timed out. Please reenter the site to 
create a new session. <BR>
<%Case "AdminPriv"%>
</P>

<H2>Error: Admininstrative Privileges Not Valid</H2>

<P><BR>
<BR>
</P>

<P>You do not have the correct privileges to access the 
ChemFinder Administrative Utilities.</P>

<P><BR>
<BR>
<BR>
<BR>
<%Case "cfw_output"%>
</P>

<H2>Error: ChemFinder Form Output</H2>

<P><BR>
<BR>
</P>

<P>The form you are converting has caused an error. <BR>
<BR>
This error should be reported to 
the Administrator and to CambridgeSoft. </P>

<P><BR>
<BR>
<%Case "paths"%>

<%select case appname%>

<%case "acxindex"%>
</P>

<H2>Error: Incorrect Chemacx Path Information</H2>

<P><BR>
<BR>
</P>

<P>The ChemFinder form and database path information for 
the Chemacx database have not been set. <BR>
<BR>
Please contact your ChemFinder Server adminstrator and 
report this error. Administrators: If this is a new installation, you will need 
to decide where you want the chemacx data to reside and copy it from the CDROM 
to the desired destination. Once installed on a local drive (or remaining on the 
CDROM), you can set the database paths using the web editor (you must have admin 
priveleges and have a valid ChemFinder Admin user name and password).
<BR>
Click <A href="/cfserveradmin/adminsource/EditWeb/editor.asp?FormMode=EditWeb">here </A>to go directly to the Web Editor to correct the 
problem. </P>
<%case Else%>

<H2>Error: Incorrect Database/ChemFinder form Paths</H2>

<P>The path information to the Database that this 
ChemFinder web application is trying to search is incorrect. <BR>
<BR>
Please contact your ChemFinder Server 
adminstrator and report this error. <BR>
If you are the 
administrator for this web, click <A
 
href="/CFServerAdmin/AdminSource/EditWeb/editor.asp?FormMode=EditWeb">here </A>to go directly to the Web Editor to correct the 
problem. </P>

<P>&nbsp;</P>
<%end select%>

<%Case "no_vir_dir"%>

<H2>Error: No Virtual Directory</H2>

<P><BR>
<BR>
</P>

<P>A virtual directory for the ChemFinder Web application 
you selected has not created. <BR>
<BR>
Please contact your ChemFinder Server adminstrator and report this error. 
 </P>

<P>&nbsp;</P>
<%Case "plugin_version"%>

<H2>Error: Plugin Version Too Old</H2>

<P><BR>
<BR>
</P>

<P>Sorry, but the plugin version you are using is older 
then 4.5.1 and is not compatible with this webserver. Please click the link 
below to download the newest version. Sorry for the inconvenience.</P>

<BLOCKQUOTE>
  <BLOCKQUOTE>
    <FONT SIZE=2 COLOR=#0000ff><U><P><A href= "http://www.camsoft.com/support/updates.html">Update Plugin</A></P><P></U></FONT>&nbsp;</P><P></P>
      </BLOCKQUOTE>
</BLOCKQUOTE>
<%Case "net_version"%>
 
<H2>Error: Net Version Limitation</H2>

<P>Sorry, you seem to be using the Net version of the 
ChemDraw Plugin. In order to do structure searching you must use the ChemDraw 
Std or ChemDraw Pro plugin. <BR>Click <A href= "http://products.camsoft.com/family.cfm?FID=2">here</A> to purchase an upgrade.</P>
<%Case "include_file"%>

<H2>Error: Include File Not Found</H2>

<P><BR>
</P>

<P>Sorry, but there was an error in loading one of the 
webserver files.</P>

<P>Please tell your webserver adinisstrator that there was 
this error. Indicate the ChemFinder web application in which the error occured.
<%Case "browser"%>
 </P>

<H2>Error: Unsupported Browser Version</H2>

<P><BR>
</P>

<P>Sorry, the ChemFinder Webserver will work properly only 
with the following browsers AND versions:</P>

<P><BR>
Macintosh - Netscape 3 and 
later. <BR>
Windows - Netscape 3 and later, or Microsoft 
Internet Explorer 4 or later.
<%Case "browser_win_ie3"%>
 </P>

<H2>Error: Windows Internet Explorer 3 Unsupported</H2>

<P><BR>
<BR>
</P>

<P>Sorry, the ChemFinder Webserver will work properly only 
with the following browsers and versions:</P>

<P><BR>
Macintosh - NetScape 3 and 
later. <BR>
Windows - NetScape 3 and later, or Microsoft 
Internet Explorer 4 or later.
<%Case "browser_mac_ie"%>
 </P>

<H2>Error: Macintosh Internet Explorer Unsupported</H2>

<P><BR>
<BR>
</P>

<P>Sorry, the ChemFinder Webserver will work properly only 
with the following browsers and versions:</P>

<P><BR>
Macintosh - NetScape 3 and 
later. <BR>
Windows - NetScape 3 and later, or Microsoft 
Internet Explorer 4 or later.
<%Case "java_off"%>
 </P>

<H2>Error: Java Inactive</H2>

<P><BR>
<BR>
</P>

<P>The ChemDraw Plug-In is unable to function because your 
browser does not support Java or has Java turned off. The ChemDraw Plug-In must 
be able to access Java in order to function. Please re-activate Java for your 
browser, and try accessing the page again. (Unfortunately, the name and location 
of the menu item for re-activating Java varies from browser to browser and even 
from version to version of the same browser. Your best bet is to consult the 
documentation for your own browser if you cannot locate this option.) If you 
continue to have problems with the CS ChemDraw Plug-In, please submit a <A
 
href="http://www.camsoft.com/support/suppProbRep.html">problem report form</A> and someone from the CambridgeSoft Technical 
Support Department will get right back to you.</P>

<%Case "cookies_off"%>
 </P>

<H2>Error: Cookies Disabled</H2>

<P><BR>
<BR>
</P>

<P>The ChemOffice Webserver depends heavily on useing client side cookies and it appears that your browswer has this ability disabled.  You will not be able to perform searches or retrieve results without this functionality. Please enable cookies in your browser setting the Preferences dialog box (Netscape) or Internet Options dialog box (Internet Explorer). 
</P>

<%Case "java_security"%>

<H2>Error: Java Security Error Detected</H2>

<P><BR>
<BR>
</P>

<P>The ChemDraw Plug-In is unable to function because the 
security level in your browser is set too high. When you loaded the Advanced 
Query with Plug-in page, you should have been prompted with an alert asking if 
you wanted to grant permissions to the Plug-In. It is vital that you grant those 
permissions, or the Plug-in will not work. You should return to the search page 
and press the Reload button on your browser; in most cases that should present 
you with the alert again, and allow you to grant the required permissions. If 
you want, many browsers will allow you to specify security settings manually 
through an appropriate menu item. Unfortunately, the name and location of that 
menu item vary from browser to browser and even from version to version of the 
same browser. Your best bet is to consult the documentation for your own 
browser. If you continue to have problems with the CS ChemDraw Plug-In, please 
submit a <A
 href="http://www.camsoft.com/support/suppProbRep.html">problem report form</A> and someone from the CambridgeSoft Technical 
Support Department will get right back to you.</P>
<%End Select%>
</BODY>
</html>