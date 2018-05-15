<%@ LANGUAGE="VBScript" %>
<%'Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved

'DO NOT EDIT THIS FILE%>
<%
Response.Expires = 0
Response.Buffer=True
Dim AD_debug
AD_debug=False
dbkey="reg"
'if Not Session("UserValidated" & dbkey) = 1 then  response.Redirect "/" & Application("appkey") & "/logged_out.asp"
%>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<head>
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/cows_func_js.asp"-->
<!--#INCLUDE FILE = "../source/secure_nav.asp"-->
<title>Analytics Add Data Form</title>
</head>
<body <%=Application("BODY_BACKGROUND") & """ bgProperties=fixed"%>>
<!--#INCLUDE FILE = "../source/app_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/header_vbs.asp"-->
<%
	' Variables declared here for the whole of the form
	Dim sThisStep
	Dim oCmd, oRS
	Dim sSQL, sCmd
	Dim i

	' Get a copy of the Session variable which will be updated by the various steps...
	sThisStep = Session("DE_StepNumber")
	
	Set RegConn=getRegConn(dbkey, formgroup)
	if RegConn.State=0 then ' assume user has been logged out
		DoLoggedOutMsg()
	end if
	
	Set oCmd = Server.CreateObject("ADODB.Command")
	oCmd.ActiveConnection = checkConn(RegConn)
	oCmd.CommandType = adCmdText
	
	Set BaseRS = Server.CreateObject("ADODB.Recordset")
	Set RegRS = Server.CreateObject("ADODB.Recordset")
	Set MoleculesRS = Server.CreateObject("ADODB.Recordset")
	
	lsBatchID = request.querystring("alt_unique_id")
	lsFullID = request.querystring("unique_id")
	BaseActualIndex =request.querystring("indexValue")
	BaseRunningIndex = BaseActualIndex

	
	' sql = GetDisplaySQL(dbkey, formgroup,"Batches.*","Batches", "", lsBatchID, "")
	sql = "SELECT reg_internal_id,Batch_Number,batch_internal_id FROM batches WHERE batch_internal_id=?"
	oCmd.CommandText = sql

	oCmd.Parameters.Append oCmd.CreateParameter("pBatchID", 5, 1, 0, lsBatchID) 
	BaseRS.Open oCmd
	oCmd.Parameters.Delete "pBatchID"
	
	
	if err.number <> 0 and RegConn.Errors.count <> 0  and Not (err.number = -2147217845) then
		Response.Write "Connection Errors for BaseRS<br>"
		for each oErr in RegConn.Errors
			
				if oErr.number <> 0  then
					Response.Write "ERROR: " & oErr.number & " SOURCE: " & oErr.source & " DESC: " & oErr.description & "<BR>"
				else
					Response.Write "WARNING: " & oErr.number & " SOURCE: " & oErr.source & " DESC: " & oErr.description & "<BR>"
				end if
			
		next 
	end if
	if BaseRS.EOF=True and BaseRS.BOF=True then
		Response.Write "ERROR: No records found in Batches table with SQL:<br>" & sql & "<BR>"
	else
		lsRegID = BaseRS("reg_internal_id").Value
	end if
	
	sql = "Select reg_number,cpd_internal_id from Reg_Numbers where reg_id=?"
	oCmd.CommandText = sql
	oCmd.Parameters.Append oCmd.CreateParameter("pRegID", 5, 1, 0, lsRegID) 
	RegRS.Open oCmd
	oCmd.Parameters.Delete "pRegID"
	
	if err.number <> 0 and RegConn.Errors.count <> 0  and Not (err.number = -2147217845) then
		Response.Write "Connection Errors for RegRS<br>"
		for each oErr in RegConn.Errors
			if oErr.number <> 0 then
				Response.Write "ERROR: " & oErr.number & " SOURCE: " & oErr.source & " DESC: " & oErr.description & "<BR>"
			else
				Response.Write "WARNING: " & oErr.number & " SOURCE: " & oErr.source & " DESC: " & oErr.description & "<BR>"
			end if
		next 
	end if
	if RegRS.EOF=True and RegRS.BOF=True then
		Response.Write "ERROR: No records found in Reg_Numbers table with SQL:<br>" & sql & "<BR>"
	else
		lsRegNum = RegRS("reg_number").Value
		lsIntID = RegRS("cpd_internal_id")
	end if
	Set oCmd = Server.CreateObject("ADODB.Command")
	oCmd.ActiveConnection = checkConn(RegConn)
	oCmd.CommandType = adCmdText
	
	fullregNumber = lsRegNum & "/" & padNumber(Application("BATCH_NUMBER_LENGTH_GUI"),BaseRS("Batch_Number"))
	sql = "Select base64_cdx from Structures where cpd_internal_id =?"
	oCmd.CommandText = sql
	oCmd.Parameters.Append oCmd.CreateParameter("pCPD", 5, 1, 0, lsIntID) 
	MoleculesRS.Open oCmd
	oCmd.Parameters.Delete "pCPD"
	if err.number <> 0 and RegConn.Errors.count <> 0   and Not (err.number = -2147217845) then
		Response.Write "Connection Errors for MoleculesRS<br>"
		for each oErr in RegConn.Errors
			if oErr.number <> 0 then
				Response.Write "ERROR: " & oErr.number & " SOURCE: " & oErr.source & " DESC: " & oErr.description & "<BR>"
			else
				Response.Write "WARNING: " & oErr.number & " SOURCE: " & oErr.source & " DESC: " & oErr.description & "<BR>"
			end if
		next 
	end if
	if MoleculesRS.EOF=True and MoleculesRS.BOF=True then
		Response.Write "ERROR: No records found in Structures table with SQL:<br>" & sql & "<BR>"
	end if

	' Use the COWS connection for our command object
	
%>
<P>
<!--
<FONT face="Arial" SIZE="2">Request.QueryString : "<%=Request.QueryString%>"</FONT><BR>
<FONT face="Arial" SIZE="2">Request.Form        : "<%=Request.Form%>"</FONT>
-->
</P>
<%
	' Spot the PagingMove action of going to the next record in the RecordSet...
	If Request.QueryString("PagingMove") <> "" then
		' Check if we are coming into here from a step in the Wizard - if so
		' the PagingMove variable may still be set, but we don't want to reset...
		if Request.Form("ExperimentType") = "" and Request.QueryString("StayInWizard") <> "True" Then
			' Response.Write "<P><H3>Paging Move Requested<BR>Request.QueryString(""PagingMove""): " & Request.QueryString("PagingMove") & "</H3></P>"
			' Response.End
		
			Session("DE_StepNumber") = "One"
			'Session("Back_To_Step_OneLocation" & dbkey)=Session("CurrentLocation" & dbkey)
		
			' Update the selector...
			sThisStep = Session("DE_StepNumber")
			' Response.Redirect Session("CurrentLocation" & dbkey)
		end if
	end if
%>

<table border="1" width="550" bgcolor="Silver">
  <tr>
    <td valign="top" width="300"><font face="Arial" size="1" color="#000000"></font><br>

		<strong><font face="Arial" color="#000000" size="2">Batch Number: </font></strong><br>
		<font face="Arial" color="#000000" size="2"><%=padNumber(Application("BATCH_NUMBER_LENGTH_GUI"),BaseRS("Batch_Number"))%></font>
		<br>
		<strong><font face="Arial" color="#000000" size="2">Registration #: </font></strong><br>
		<font face="Arial" color="#000000" size="2"><%=RegRS("Reg_Number") %></font>
	</td>
    <td valign="center" align="center" width="180" bgcolor="White"><%ShowResult dbkey, formgroup, MoleculesRS,"Structures.BASE64_CDX", "Base64CDX", 400, 200%></td>
  </tr>
</table>
<% if Request.QueryString("Debug") = "True" Then %>
<P>
Request.QueryString                 : "<%=Request.QueryString%>"<BR>
Request.Form                        : "<%=Request.Form %>"<BR>
Session("DE_StepNumber")            : "<%=Session("DE_StepNumber") %>"<BR>
Session("DE_LastStepNumber")        : "<%=Session("DE_LastStepNumber") %>"<BR>
Session("DE_BatchID")               : "<%=Session("DE_BatchID") %>"<BR>
Session("DE_ExperimentType")        : "<%=Session("DE_ExperimentType") %>"<BR>
Session("DE_ExperimentTypeName")    : "<%=Session("DE_ExperimentTypeName") %>"<BR>
Session("CurrentLocation" & dbkey & formgroup)  : "<%=Session("CurrentLocation" & dbkey & formgroup) %>"<BR>
BaseID                              : "<%=BaseID %>"<BR>
BaseActualIndex                     : "<%=BaseActualIndex %>"<BR>
</P>
<% end if %>
<%
	If sThisStep = "One" Then
		' Update the LAST STEP variable at this point.
		Session("DE_LastStepNumber") = "One"
		
		' The most robust way to get the BatchID is probably to look it up from the BaseID passed into here
		theBatchID = BaseRS("Batch_Internal_ID")
		Session("DE_BatchID") = theBatchID
		' Response.Write "<P>Got BatchID from BaseRS: " & Session("DE_BatchID")  & "</P>"
%>
<P><FONT face="Arial" size="2" color="Navy"><STRONG>Step 1 of 4</STRONG> - Adding data for Batch Number: <%=BaseRS("Batch_Number")%> - Please choose an Experiment Type</FONT></P>
<FORM METHOD="Post" ACTION="<%=Session("CurrentLocation" & dbkey & formgroup)%>" ID="FormStep1" NAME="FormStep1">
<FONT face="Arial" size="2" color="Navy">Select Experiment Type : </FONT><SELECT NAME="ExperimentType" SIZE="1">
<%
		'oCmd.CommandText = "SELECT experiment_type_id, experiment_type_name from ExperimentType ; "
		'changed for oracle compat
		Set oCmd = Server.CreateObject("ADODB.Command")
		oCmd.ActiveConnection = checkConn(RegConn)
		oCmd.CommandType = adCmdText
		oCmd.CommandText = "SELECT experiment_type_id, experiment_type_name from ExperimentType "
		Set oRS = oCmd.Execute
		if oRS.EOF=True and oRS.BOF=True then
			Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">No experiment types found</FONT><BR>"
		else
			' Set up the SELECT choices...
			i=0
			do while not oRS.EOF
				if i=0 then
					Response.Write "<OPTION SELECTED VALUE=" & oRS("experiment_type_id").Value & ">" & oRS("experiment_type_name").Value & "</OPTION>"
				else
					Response.Write "<OPTION VALUE=" & oRS("experiment_type_id").Value & ">" & oRS("experiment_type_name").Value & "</OPTION>"
				end if
				i=i+1
				oRS.MoveNext
			loop
		end if
		oRS.Close
		Set oRS = Nothing
		Set oCmd = Nothing
%>
</SELECT>
<INPUT TYPE="Submit" ID="Submit" NAME="Submit" VALUE="Add Data">
</FORM>
<%
		' Update the StepNumber variable here
		Session("DE_StepNumber") = "Two"
	elseif sThisStep = "Two" then
		' Update the LAST STEP variable at this point.
		Session("DE_LastStepNumber") = "One"
		
		' Now we check the Compound/Batch ID that has been submitted and
		' ensure that this is a valid entry in the database - otherwise we do not accept
		' the data and return the user to to the first screen
		Dim iCompoundID, iExperimentID
		
		' Pick up the BatchID from the form - or if we did a "Previous" get it from Storage
		if Request.Form("CompoundID") = "" then
			if Session("DE_BatchID") = "" then
				Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Error: No BatchID specified.</FONT>"
				
				if oRS.State = adStateOpen then oRS.Close
				Set oRS = Nothing
				Set oCmd = Nothing%>
							<script language = "javascript">
						loadUserInfoFrame()
						top.frames["navbar"].location.replace("/<%=Application("appkey")%>/navbar.asp?formgroup=analytics_form_group&dbname=reg&formmode=edit&nav_override=true&commit_type=" + "<%=commit_type%>")
			</script>
				<%Response.End
			else
				iCompoundID = CLng(Session("DE_BatchID"))
			end if
		else
			iCompoundID = CLng(Request.Form("CompoundID"))
			Session("DE_BatchID") = Request.Form("CompoundID")
		end if
		
		'sCmd = "SELECT MOL_ID, BATCH_ID, SUBSTANCE_ID, RO_NO FROM MolTable WHERE BATCH_ID = " & iCompoundID
		Set oCmd = Server.CreateObject("ADODB.Command")
		oCmd.ActiveConnection = checkConn(RegConn)
		oCmd.CommandType = adCmdText
		sCmd = "SELECT Batch_internal_id FROM Batches WHERE Batch_internal_ID = " & iCompoundID

		oCmd.CommandText = sCmd
		Set oRS = oCmd.Execute
		
		if oRS.EOF = True and oRS.BOF=True Then
			' No records found - not a valid Batch ID
			Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Error: Batch ID " & Request.Form("CompoundID") & " is not valid for this database.</FONT>"

			if oRS.State = adStateOpen then oRS.Close
			Set oRS = Nothing
			Set oCmd = Nothing%>
						<script language = "javascript">
						loadUserInfoFrame()
						top.frames["navbar"].location.replace("/<%=Application("appkey")%>/navbar.asp?formgroup=analytics_form_group&dbname=reg&formmode=edit&nav_override=true&commit_type=" + "<%=commit_type%>")
			</script>
				<%Response.End
		else
			' Pick up the ExperimentTypeID from the form - or if we did a "Previous" get it from Storage
			if Request.Form("ExperimentType") = "" then
				if Session("DE_ExperimentType") = "" then
					Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Error: No ExperimentType specified.</FONT>"
					
					if oRS.State = adStateOpen then oRS.Close
					Set oRS = Nothing
					Set oCmd = Nothing%>
									<script language = "javascript">
						loadUserInfoFrame()
						top.frames["navbar"].location.replace("/<%=Application("appkey")%>/navbar.asp?formgroup=analytics_form_group&dbname=reg&formmode=edit&nav_override=true&commit_type=" + "<%=commit_type%>")
			</script>
				<%Response.End
				else
					iExperimentID = CLng(Session("DE_ExperimentType"))
				end if
			else
				iExperimentID = CLng(Request.Form("ExperimentType"))
				Session("DE_ExperimentType") = Request.Form("ExperimentType")
			end if

			oRS.Close
			sCmd = "SELECT experiment_type_name FROM ExperimentType WHERE experiment_type_id = " & iExperimentID
			Set oCmd = Server.CreateObject("ADODB.Command")
			oCmd.ActiveConnection = checkConn(RegConn)
			oCmd.CommandType = adCmdText
			oCmd.CommandText = sCmd
			Set oRS = oCmd.Execute
			if oRS.EOF = True and oRS.BOF=True Then
				Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Error Finding Experiment Type Name from ID</FONT><BR>"

				if oRS.State = adStateOpen then oRS.Close
				Set oRS = Nothing
				Set oCmd = Nothing%>
								<script language = "javascript">
						loadUserInfoFrame()
						top.frames["navbar"].location.replace("/<%=Application("appkey")%>/navbar.asp?formgroup=analytics_form_group&dbname=reg&formmode=manage_analytics&nav_override=true&commit_type=" + "<%=commit_type%>")
			</script>
				<%Response.End
			else
				Session("DE_ExperimentTypeName") = oRS("experiment_type_name").Value
				oRS.Close
			end if
		end if		
		theFullGifPath = "/cfserverasp/source/graphics/navbuttons/icon_mview.gif"
		theFullSourcePath = "/cfserverasp/source/month_view1.asp"
	datepicker= "<a href=""#"" onclick=""return PopUpDate(&quot;ExperimentDate&quot;,&quot;" & theFullSourcePath & "&quot;,&quot;FormStep2&quot;)"">"
	datepicker = datepicker & "<img src=""" & theFullGifPath & """ height=""16"" width=""16"" border=""0""></a>"

%>
<P><FONT face="Arial" size="2" color="Navy"><STRONG>Step 2 of 4</STRONG> - Adding <%=Session("DE_ExperimentTypeName") %> data for Batch Number: <%=BaseRS("Batch_Number")%> - Please fill in experimental data</FONT></P>
<FORM ACTION="<%=Session("CurrentLocation" & dbkey & formgroup)%>" ID="FormStep2" NAME="FormStep2" METHOD="POST">
<INPUT type="Hidden" NAME="ExperimentType" VALUE="<%=Session("DE_ExperimentType")%>">
<TABLE WIDTH="600" BORDER="1" BGCOLOR="Silver" BORDERCOLOR="Navy" CELLSPACING="1" CELLPADDING="2">
<TR>
	<TD WIDTH="50%"><FONT FACE="Arial" SIZE="2" COLOR="Black">Date</FONT></TD><TD><INPUT TYPE="Text" NAME="ExperimentDate" VALUE="<% Response.Write Date() %>" SIZE="30"><%=datepicker%></TD>
	<TD WIDTH="50%"><FONT FACE="Arial" SIZE="2" COLOR="Black">Location</FONT></TD><TD><INPUT TYPE="Text" NAME="ExperimentLocation" VALUE="[Location]" SIZE="30"></TD>
</TR><TR>
	<TD WIDTH="50%"><FONT FACE="Arial" SIZE="2" COLOR="Black">Reference</FONT></TD><TD><INPUT TYPE="Text" NAME="ExperimentReference" VALUE="[Reference]" SIZE="30"></TD>
	<TD WIDTH="50%"><FONT FACE="Arial" SIZE="2" COLOR="Black">Comment</FONT></TD><TD><INPUT TYPE="Text" NAME="ExperimentComment" VALUE="[Comment]" SIZE="30"></TD>
</TR>
</TABLE>
<%	
		' Enclose the whole of the Parameters and Results table with an enclosing TABLE
		Response.Write "<TABLE WIDTH=""600"" BORDER=""1"" BGCOLOR=""Silver"" BORDERCOLOR=""Navy"" CELLSPACING=""1"" CELLPADDING=""2"">"
		Response.Write "<TR><TD WIDTH=""50%"" VALIGN=""top"">"
		
		' Now look up what the parameters should be...
		'sCmd = "SELECT ExperimentType.experiment_type_id, ParameterType.parameter_type_id, ExperimentType.experiment_type_name, ParameterType.parameter_type_name, ParameterType.parameter_type_units"
		'sCmd = sCmd & " FROM ParameterType INNER JOIN (ExperimentType INNER JOIN ExperimentTypeParameters ON ExperimentType.experiment_type_id = ExperimentTypeParameters.experiment_type_id) ON ParameterType.parameter_type_id = ExperimentTypeParameters.parameter_type_id"
		'sCmd = sCmd & " WHERE ExperimentType.experiment_type_id = " & CLng(Session("DE_ExperimentType"))
		'sCmd = sCmd & " ORDER BY ExperimentType.experiment_type_id, ParameterType.parameter_type_id ;"
		
		'changed for oracle compatability
		sCmd = "SELECT ExperimentType.experiment_type_id, ParameterType.parameter_type_id, ExperimentType.experiment_type_name, ParameterType.parameter_type_name, ParameterType.parameter_type_units"
		sCmd = sCmd & " FROM ParameterType,ExperimentType,ExperimentTypeParameters"
		sCmd = sCmd & " WHERE ExperimentType.experiment_type_id = ExperimentTypeParameters.experiment_type_id AND ParameterType.parameter_type_id = ExperimentTypeParameters.parameter_type_id"
		sCmd = sCmd & " AND ExperimentType.experiment_type_id = " & CLng(Session("DE_ExperimentType"))
		sCmd = sCmd & " ORDER BY ExperimentType.experiment_type_id, ParameterType.parameter_type_id"
		
		oCmd.CommandText = sCmd
		Set oRS = oCmd.Execute

		' Now look at the parameters defined for this experiment and set up the input table
		if oRS.EOF=True and oRS.BOF=True then
			' This is normal behaviour if there are no Parameters defined for this Experiment...

			Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">No Parameters defined for experiment</FONT><BR>"
			if AD_debug=True then Response.Write "sCmd was: """ & sCmd & """<BR>"
		else
			' Set the offset into the column array
			i=1

			' Get the parameter values
			Response.Write "<TABLE BORDER=""0"">"
			Response.Write "<TR><TH COLSPAN=""3""><FONT FACE=""Arial"" SIZE=""2"" COLOR=""Navy"">Parameters</FONT></TH></TR>"
			do while not oRS.EOF = True
				Response.Write "<TR><TD WIDTH=""25%""><FONT FACE=""Arial"" SIZE=""2"" COLOR=""Black"">" & oRS("parameter_type_name").value & "&nbsp;</FONT></TD>"
				Response.Write "<TD WIDTH=""65%""><INPUT TYPE=""Text"" NAME=""Param_" & oRS("parameter_type_id").Value & """ SIZE=""20""></TD>"
				Response.Write "<TD WIDTH=""10%""><FONT FACE=""Arial"" SIZE=""2"" COLOR=""Black"">" & oRS("parameter_type_units").Value & "&nbsp;</FONT></TD></TR>"
				i=i+1
				oRS.MoveNext
			loop
			
			Response.Write "</TABLE>"
		end if

		Response.Write "</TD><TD WIDTH=""50%"" VALIGN=""top"">" ' This is the enclosing table for results and Parameters
		
		' Now look up what the RESULTS should be...
		' sCmd = "SELECT ExperimentType.experiment_type_id, ResultType.result_type_id, ExperimentType.experiment_type_name, ResultType.result_type_name, ResultType.result_type_units"
		' sCmd = sCmd & " FROM ResultType INNER JOIN (ExperimentType INNER JOIN ExperimentTypeResults ON ExperimentType.experiment_type_id = ExperimentTypeResults.experiment_type_id) ON ResultType.result_type_id = ExperimentTypeResults.result_type_id"
		' sCmd = sCmd & " WHERE ExperimentType.experiment_type_id = " & CLng(Session("DE_ExperimentType"))
		' sCmd = sCmd & " ORDER BY ExperimentType.experiment_type_id, ResultType.result_type_id ;"

		'changed for oracle compatiblity
		sCmd = "SELECT ExperimentType.experiment_type_id, ResultType.result_type_id, ExperimentType.experiment_type_name, ResultType.result_type_name, ResultType.result_type_units"
		sCmd = sCmd & " FROM ResultType, ExperimentType, ExperimentTypeResults  WHERE  ExperimentType.experiment_type_id = ExperimentTypeResults.experiment_type_id AND ResultType.result_type_id = ExperimentTypeResults.result_type_id"
		sCmd = sCmd & " AND ExperimentType.experiment_type_id = " & CLng(Session("DE_ExperimentType"))
		sCmd = sCmd & " ORDER BY ExperimentType.experiment_type_id, ResultType.result_type_id"
		Set oCmd = Server.CreateObject("ADODB.Command")
		oCmd.ActiveConnection = checkConn(RegConn)
		oCmd.CommandType = adCmdText
		oCmd.CommandText = sCmd
	
		Set oRS = oCmd.Execute

		' Now look at the Results defined for this experiment and set up the rest of the input table
		if oRS.EOF=True and oRS.BOF=True then
			Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">No Results defined for experiment</FONT><BR>"
			if AD_debug=True then Response.Write "sCmd was: """ & sCmd & """<BR>"
		else
			' Get the result values
			i=1
			Response.Write "<TABLE BORDER=""0"">"
			Response.Write "<TR><TH COLSPAN=""3""><FONT FACE=""Arial"" SIZE=""2"" COLOR=""Navy"">Results</FONT></TH></TR>"
			do while not oRS.EOF = True
				Response.Write "<TR><TD WIDTH=""25%""><FONT FACE=""Arial"" SIZE=""2"" COLOR=""Black"">" & oRS("result_type_name").value & "&nbsp;</FONT></TD>"
				Response.Write "<TD WIDTH=""65%""><INPUT TYPE=""Text"" NAME=""Result_" & oRS("result_type_id").Value & """ SIZE=""20""></TD>"
				Response.Write "<TD WIDTH=""10%""><FONT FACE=""Arial"" SIZE=""2"" COLOR=""Black"">" & oRS("result_type_units").Value & "&nbsp;</FONT></TD></TR>"
				i=i+1
				oRS.MoveNext
			loop
			Response.Write "</TABLE>"
		end if

		Response.Write "</TD></TR></TABLE>" ' This is the enclosing table for Results and Parameters

		Response.Write "<BR><INPUT TYPE=""Submit"" ID=""Submit"" NAME=""Submit"" VALUE=""Commit Data"">"
		Response.Write "</FORM>"

		oRS.Close
		Set oRS = Nothing
		Set oCmd = Nothing

		' Update the Step Number variable
		Session("DE_StepNumber") = "Three"
		
	elseif sThisStep = "Three" then
		' Update the LAST STEP variable at this point.
		Session("DE_LastStepNumber") = "Two"

     	Response.Write "<P><FONT face=""Arial"" size=""2"" color=""Navy""><STRONG>Step 3 of 4</STRONG> - Adding data for Batch Number: " & BaseRS("Batch_Number")& " - Processing Data (hidden step!!)</FONT></P>"

		' At this stage we have got Parameters and Results being passed in as part
		' of the Request.Form object - they are identified as "Param_<ID>" - need to
		' parse these off the Request.Form...
		Dim x, spID, seID
		Dim sLocation, sDate, sComment, sReference

		' Make sure we don't have any problem with NULL strings
		sLocation = Request.Form("ExperimentLocation") & ""
		
		
		
		sComment = Request.Form("ExperimentComment")
		sReference = Request.Form("ExperimentReference") & ""
	

		' First we need to insert a new experiment into the Experiments table and
		' retrieve the resulting experiment_id
		'sCmd = "INSERT INTO [Experiments](experiment_type_id, experiment_batch_id, experiment_location, experiment_date, experiment_comment, experiment_reference) VALUES ( "
		'sCmd = sCmd & ", '" & sLocation & "', #" & sDate & "#, '" & sComment & "', '" & sReference & "' ) ;"
		'changed for oracle compatibility TO
		
		' RAS 14-Sep-00 NB: The ORACLE date format is 'dd-mmm-yy' so we need to reformat the date or just use sysdate!!
		
		' Change the date format first
		' sCmd = "alter session set NLS_DATE_FORMAT = 'MM/DD/RRRR'"
		' oCmd.CommandText = sCmd
		' oCmd.Execute
		Set RS = server.CreateObject("ADODB.RECORDSET")
		
		RS.Open "Experiments", RegConn,adOpenStatic,adLockOptimistic, adCmdTable
		RS.AddNew
		
		RS("experiment_type_id") = CLng(Session("DE_ExperimentType"))
		RS("experiment_batch_id") =  CLng(Session("DE_BatchID"))
		RS("experiment_location") = sLocation
		RS("experiment_date") = Request.Form("ExperimentDate")
		RS("experiment_comment") = sComment
		RS("experiment_reference") = sReference
		RS.Update
		RS.Close
		
		
		
		
		
		' Perhaps we should use the ADO updateabe recordset object to do this as we can then retrieve
		' the ID more easily...
		'sCmd = "SELECT MAX(experiment_id) AS theID FROM Experiments ; "
		sCmd = "SELECT MAX(experiment_id) AS theID FROM Experiments "
		Set oCmd = Server.CreateObject("ADODB.Command")
		oCmd.ActiveConnection = checkConn(RegConn)
		oCmd.CommandType = adCmdText
		oCmd.CommandText = sCmd
		Set oRS = oCmd.Execute
		' seID = CLng(oRS("theID").Value)
		seID = oRS("theID").Value
		' Response.Write "New Experiment ID: " & seID & "<BR>"
		Session("DE_ExperimentID") = seID
		
		For Each x In Request.Form
			' Response.Write "Form element " & x & ": " & Request.Form(x) & "<BR>"
			
			if Left(x, 6) = "Param_" then
				' Get the Parameter ID from the string
				spID = Mid(x, 7)
			
				' Response.Write "Parameter ID: " & spID & "<BR>"
				' Response.Write "Experiment ID: " & seID & "<BR>"
				' Response.Write "Parameter Value: " & Request.Form(x) & "<BR>"
				
				' Add a record to the Parameters Table with all of the data as specified...
				
				if Request.Form(x) = "" then
					Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Warning: No value provided for " & x & " You must provide a value for all Parameters</FONT><BR>"
				else
					'sCmd = "INSERT INTO [Parameters](parameter_type_id, parameter_value, parameter_experiment_id ) VALUES ( "
					'chagned for oracle compat
					sCmd = "INSERT INTO Parameters(parameter_type_id, parameter_value, parameter_experiment_id ) VALUES ( "
					paramvalue = replace(Request.Form(x), "'", "''")
					'sCmd = sCmd & CLng(spID) & ", '" & Request.Form(x) & "', " & seID & " ) ;"
					sCmd = sCmd & CLng(spID) & ", '" & paramvalue & "', " & seID & " )"

					oCmd.CommandText = sCmd
					oCmd.Execute
				
					Response.Write "<FONT FACE=""Arial"" COLOR=""Green"" SIZE=""2"">Added data for " & x & " to Parameters table</FONT><BR>"
				end if
			elseif Left(x, 7) = "Result_" then
				' Get the Result ID from the string
				spID = Mid(x, 8)
			
				' Response.Write "Result ID: " & spID & "<BR>"
				' Response.Write "Experiment ID: " & seID & "<BR>"
				' Response.Write "Result Value: " & Request.Form(x) & "<BR>"
				
				' Add a record to the Results Table with all of the data as specified...
				if Request.Form(x) = "" then
					Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Error: No value provided for " & x & " You must provide a value for all Results</FONT><BR>"
				else
					'sCmd = "INSERT INTO [Results](result_type_id, result_value, result_experiment_id ) VALUES ( "
					'changed for oracle compat
					sCmd = "INSERT INTO Results(result_type_id, result_value, result_experiment_id ) VALUES ( "
					resultValue = replace(Request.Form(x), "'", "''")
					'sCmd = sCmd & CLng(spID) & ", '" & Request.Form(x) & "', " & seID & " ) ;"
					sCmd = sCmd & CLng(spID) & ", '" & resultValue & "', " & seID & " )"

					oCmd.CommandText = sCmd
					oCmd.Execute
				
					Response.Write "<FONT FACE=""Arial"" COLOR=""Green"" SIZE=""2"">Added data for " & x & " to Results table</FONT><BR>"
				end if
			end if
		next

		if oRS.State = adStateOpen Then oRS.Close
		Set oRS = Nothing
		Set oCmd = Nothing
		
		' Update the step number variable
		Session("DE_StepNumber") = "Four"
		
		' Automatically step to the results display
		' Response.Redirect("/analytics/Analytics_AddData_form.asp")
		
		' Really need to add something to the query string here so that we stay in the Wizard...
		' Response.Redirect(Session("CurrentLocation" & dbkey & formgroup))
		
		sCmd =Session("CurrentLocation" & dbkey & formgroup)
		
		if InStr(1, sCmd, "?") > 0 then
			' Just add the "&StayInWizard" flag
			sCmd = sCmd & "&StayInWizard=True"
		else
			' Add the "?StayInWizard" query
			sCmd = sCmd & "?StayInWizard=True"		
		end if
		
		'sThisStep=""
		Session("DE_StepNumber") = "One"
		Response.Redirect(sCmd)
	elseif sThisStep = "Four" then
		' Update the LAST STEP variable at this point. Need to step back to Step 2 at this point.
		Session("DE_LastStepNumber") = "Two"

     	Response.Write "<P><FONT face=""Arial"" size=""2"" color=""Navy""><STRONG>Step 4 of 4</STRONG> - Completed addition of data for Batch Number: " & BaseRS("Batch_Number") & "</FONT></P>"
		Response.Write "<P align=""center""><FONT face=""Arial"" size=""2"" color=""Navy"">Please click the 'Return to Details' button, if available, or the 'Main Menu' button.</FONT></P>"

		' This is the end of the line - now we should display the results of having added this data to 
		' the various tables..
		
		' sCmd = "SELECT Experiments.experiment_id, Experiments.experiment_batch_id, ExperimentType.experiment_type_name, ResultType.result_type_name, Results.result_value, ResultType.result_type_units, ParameterType.parameter_type_name, Parameters.parameter_value, ParameterType.parameter_type_units"
		' sCmd= sCmd & " FROM ResultType INNER JOIN ((ParameterType INNER JOIN ((ExperimentType INNER JOIN Experiments ON ExperimentType.experiment_type_id = Experiments.experiment_type_id) INNER JOIN [Parameters] ON Experiments.experiment_id = Parameters.parameter_experiment_id) ON ParameterType.parameter_type_id = Parameters.parameter_type_id) INNER JOIN Results ON Experiments.experiment_id = Results.result_experiment_id) ON ResultType.result_type_id = Results.result_type_id"
		' sCmd= sCmd & " WHERE Experiments.experiment_id = " & Session("DE_ExperimentID") & " ;"
		
		'changed for oracle compat
		sCmd = "SELECT Experiments.experiment_batch_id, Experiments.experiment_id, ExperimentType.experiment_type_name, Experiments.experiment_date, Experiments.experiment_location, Experiments.experiment_comment, Experiments.experiment_reference"
		sCmd = sCmd & " FROM ExperimentType, Experiments Where ExperimentType.experiment_type_id = Experiments.experiment_type_id"
		sCmd = sCmd & " AND Experiments.experiment_id = " & Session("DE_ExperimentID") & " "
		Set oCmd = Server.CreateObject("ADODB.Command")
		oCmd.ActiveConnection = checkConn(RegConn)
		oCmd.CommandType = adCmdText
		oCmd.CommandText = sCmd
		Set oRS = oCmd.Execute
		
		if oRS.BOF = True and oRS.EOF = True Then
			Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Error - no details found for Experiment ID: " & Session("DE_ExperimentID") & "</FONT><BR>"
		else
			' Display the header information...
			Response.Write "<P><TABLE BORDER=""1"" CELLPADDING=""2"" CELLSPACING=""1"" BGCOLOR=""Navy""><TR>"
			Response.Write "<TD BGCOLOR=""Silver"">Batch ID</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">" & oRS("experiment_batch_id").Value & "</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">Experiment ID</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">" & oRS("experiment_id").Value & "</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">Experiment Type</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">" & oRS("experiment_type_name").Value & "</TD></TR>"
			Response.Write "<TR><TD BGCOLOR=""Silver"">Date</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">" & oRS("experiment_date").Value & "</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">Location</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">" & oRS("experiment_location").Value & "</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">Reference</TD>"
			Response.Write "<TD BGCOLOR=""Silver"">" & oRS("experiment_reference").Value & "</TD></TR>"
			Response.Write "<TR><TD BGCOLOR=""Silver"">Comment</TD>"
			Response.Write "<TD BGCOLOR=""Silver"" COLSPAN=""5"">" & oRS("experiment_comment").Value & "</TD></TR>"
			Response.Write "</TABLE></P>"
		end if
		
		oRS.Close
		Set oRS = Nothing

		Response.Write "<P><TABLE BORDER=""1"" CELLPADDING=""2"" CELLSPACING=""1"" BGCOLOR=""Navy""><TR><TH BGCOLOR=""Silver"">Parameters</TH><TH BGCOLOR=""Silver"">Results</TH></TR><TR><TD BGCOLOR=""Silver"" VALIGN=""top"">"
		
		' Get the Parameter information using the correct Experiment ID
		'sCmd = "SELECT Experiments.experiment_id, ParameterType.parameter_type_name, Parameters.parameter_value, ParameterType.parameter_type_units"
		'sCmd = sCmd & " FROM ParameterType INNER JOIN (Experiments INNER JOIN [Parameters] ON Experiments.experiment_id = Parameters.parameter_experiment_id) ON ParameterType.parameter_type_id = Parameters.parameter_type_id"
		'sCmd = sCmd & " WHERE Experiments.experiment_id = " & Session("DE_ExperimentID") & " ;"

		'changed for oracle compatability
		sCmd = "SELECT Experiments.experiment_id, ParameterType.parameter_type_name, Parameters.parameter_value, ParameterType.parameter_type_units"
		sCmd = sCmd & " FROM ParameterType,Experiments,Parameters WHERE Experiments.experiment_id = Parameters.parameter_experiment_id AND ParameterType.parameter_type_id = Parameters.parameter_type_id"
		sCmd = sCmd & " AND Experiments.experiment_id = " & Session("DE_ExperimentID") & " "
		Set oCmd = Server.CreateObject("ADODB.Command")
		oCmd.ActiveConnection = checkConn(RegConn)
		oCmd.CommandType = adCmdText
		oCmd.CommandText = sCmd
		Set oRS = oCmd.Execute
		
		if oRS.BOF = True and oRS.EOF = True Then
			' Normal behaviour if there are no parameters defined for this experiment type
			Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">No Parameters defined for experiment</FONT><BR>"
		else
			' get the results and display in a Tabular form...
			Response.Write "<TABLE BORDER=""1"" CELLPADDING=""2"" CELLSPACING=""1"" BGCOLOR=""Navy""><TR>"
			Response.Write "<TH BGCOLOR=""Silver"">Parameter</TH>"
			Response.Write "<TH BGCOLOR=""Silver"">Value</TH>"
			Response.Write "</TR>"
			do while not oRS.EOF = True
				'Get the data for this row
				Response.Write "<TR>"
				Response.Write "<TD BGCOLOR=""Silver"">" & oRS("parameter_type_name").Value & "</TD>"
				Response.Write "<TD BGCOLOR=""Silver"">" & oRS("parameter_value").Value & "</TD>"
				Response.Write "</TR>"
				oRS.MoveNext
			loop
			
			Response.Write "</TABLE>"
		end if

		Response.Write "</TD><TD VALIGN=""top"" BGCOLOR=""Silver"">"
		
		if oRS.State = adStateOpen Then oRS.Close
		Set oRS = Nothing

		' Get the Result information using the correct Experiment ID
		sCmd = "SELECT Experiments.experiment_id, ResultType.result_type_name, Results.result_value, ResultType.result_type_units"
		'sCmd = sCmd & " FROM ResultType INNER JOIN (Experiments INNER JOIN [Results] ON Experiments.experiment_id = Results.result_experiment_id) ON ResultType.result_type_id = Results.result_type_id"
		'sCmd = sCmd & " WHERE Experiments.experiment_id = " & Session("DE_ExperimentID") & " ;"
		'changed for oracle compatablity
		sCmd = sCmd & " FROM ResultType,Experiments,Results WHERE Experiments.experiment_id = Results.result_experiment_id AND ResultType.result_type_id = Results.result_type_id"
		'sCmd = sCmd & " AND Experiments.experiment_id = " & Session("DE_ExperimentID") & " ;"
		sCmd = sCmd & " AND Experiments.experiment_id = " & Session("DE_ExperimentID") & " "

		oCmd.CommandText = sCmd
		Set oRS = oCmd.Execute
		
		if oRS.BOF = True and oRS.EOF = True Then
			' Normal behaviour if no Results defined for experiment type
			Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">No Results defined for experiment</FONT><BR>"
		else
			' get the results and display in a Tabular form...
			Response.Write "<TABLE BORDER=""1"" CELLPADDING=""2"" CELLSPACING=""1"" BGCOLOR=""Navy""><TR>"
			Response.Write "<TH BGCOLOR=""Silver"">Result</TH>"
			Response.Write "<TH BGCOLOR=""Silver"">Value</TH>"
			Response.Write "</TR>"
			do while not oRS.EOF = True
				'Get the data for this row
				Response.Write "<TR>"
				Response.Write "<TD BGCOLOR=""Silver"">" & oRS("result_type_name").Value & "</TD>"
				Response.Write "<TD BGCOLOR=""Silver"">" & oRS("result_value").Value & "</TD>"
				Response.Write "</TR>"
				oRS.MoveNext
			loop
			
			Response.Write "</TABLE>"
		end if

		Response.Write "</TD></TR></TABLE></P>"

		if oRS.State = adStateOpen Then oRS.Close
		Set oRS = Nothing
		Set oCmd = Nothing

		' Update the Step Number variable
		Session("DE_StepNumber") = "Done"

	elseif sThisStep = "Done" then
		' Return to the ResultList page...
		Response.Write "<P><H2>Data Entry Complete</H2></p>"
		Response.Write "<p><FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Please click on 'Return to Details' button, if available, or the 'Main Menu' button.</font></P>"
	else
		Response.Write "<FONT FACE=""Arial"" COLOR=""Red"" SIZE=""3"">Error: Undefined step number!</FONT>"
	end if

	Response.Write "</body>"
	CloseRS(BaseRS)
	CloseRS(RegRS)
	CloseRS(MoleculeRS)
	CloseConn(RegConn)
	
	
	function checkConn(byRef conn)
		if not isObject(conn) then
			conn = getRegConn(dbkey, formgroup)
		end if
		Set checkConn = conn
	end function
	
	Function getOracleDate(byval pDate)
		dash = "-"
		cln = ":"
		strDate = Year(pDate) & dash & Month(pDate) & dash & Day(pDate) & " " & Hour(pDate) & cln & Minute(pDate) & cln & Second(pDate) 
		getOracleDate =  "to_date('" & strDate & "','YYYY-MM-DD HH24:MI:SS')"
	End Function
%>
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/input_form_footer_vbs.asp"-->
</html>