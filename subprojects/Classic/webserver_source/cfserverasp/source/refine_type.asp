<%@ LANGUAGE="VBSCRIPT" %>
<%' Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved
'DO NOT EDIT THIS FILE%>
<%dbkey = Request.querystring("dbname")
totalRecords = Request.QueryString("totalrecords")
allowRefine = True
'!DGB! changed the limit from 1000 to 2400 
'if CLng(totalRecords) > 2400 then
'allowRefine = False
'end if
%>
<html>

<head>
<script LANGUAGE="javascript" src="/cfserverasp/source/Choosecss.js"></script>

<script language="javascript">
theWindow = ""
MainWindow = opener

var more_available =MainWindow.more_available
function doOK(){
	var theWindow = MainWindow.document.forms["cows_input_form"]
	theValue = getSelectedButton()
		if (theValue == "edit_query"){
			theoldaction = theWindow.action
			thenewaction = theoldaction.replace( "=refine", "=edit_query")
			theWindow.action = thenewaction}
			else{
		theWindow.RefineType.value = theValue}
	theWindow.submit()
	window.close()
	}
function getSelectedButton(){
	theformgroup = self.document.refineform.refinetype
	//!DGB! catch the case of a single radio button
	if (typeof theformgroup.length == "undefined"){
		theValue= theformgroup.value
	}
	else
	{
		for (var i = 0;i< theformgroup.length; i++){
			if(theformgroup[i].checked){
				theValue= theformgroup[i].value
			}
		
		}
	}
	return theValue
}

</script>

<title></title>
</head>

<body>

<form name="refineform">
  <table border="0" width="276">
    <tr>
	  <!--- !DGB! Removed width and height from IMG tags--->
      <td><a href="javascript:doOK()"><img border="0"
      src="<%=Application("NavButtonGifPath") & "OK.gif"%>" alt="proceed with refine"></a>
      <a href="javascript:window.close()"><img border="0"
      src="<%=Application("NavButtonGifPath") & "Cancel.gif"%>" alt="close window without changes"></a> </td>
    </tr>
    <tr>
      <td width="220" nowrap ><strong><br>Please select a refine type:<br><br>
      </strong></td>
      <td width="44"></td>
    </tr>
    <tr>
      <td align="right" width="220">Edit current query</td>
      <td width="44"><input type="radio" name="refinetype" value="edit_query"></td>
    </tr>
    <%if allowRefine = True then%>
    <tr>
      <td align="right" width="220">Refine over current records found</td>
      <td width="44"><input type="radio" name="refinetype" value="partial_refine" checked></td>
    </tr>
    <%end if%>
    <script language="javascript">
  		//if (more_available == "True"){

		//document.write('<tr>')
		//document.write('<td align="right" width="220">Refine over entire database</td>')
		//document.write('<td width="44"><input type="radio" name="refinetype" value="full_refine"></td>')
	//document.write('</tr>')
   //}
  </script>

  </table>
  <div align="left"><p>&nbsp;</p>
  </div>
</form>
</body>
</html>