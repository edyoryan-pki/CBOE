<%@ LANGUAGE=VBScript  %>
<%'Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved%>
<%'DO NOT EDIT THIS FILE%>
<html>
<head>

<!--#INCLUDE VIRTUAL = "/cfserverasp/source/cows_func_vbs.asp" -->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/manage_user_settings_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/utility_func_vbs.asp"-->


<script LANGUAGE="javascript" src="/cfserverasp/source/Choosecss.js"></script>
<%
dbkey=request("dbname")
formgroup=request("formgroup")
formmode = request("formmode")
formgroupflag= GetFormGroupVal(dbkey, formgroup, kFormGroupFlag)
manage_hitlist_mode =request("manage_hitlist_mode")
button_path = Application("NavButtonGifPath")
getUserSettingsID dbkey, formgroup
actionpath = Application("appkey") & "/" & dbkey & "/" & dbkey & "_action.asp?dbname=" & dbkey & "&formgroup=" & formgroup
windowTitle = replace(manage_hitlist_mode, "_", " ")
'LJB 9/16/200 adjust menu font size for mac IE browser
if detectIEMac() = true then
	IEMac = "true"
else
	IEMac = "false"
end if%>
<title><%=windowTitle%></title>

	
<script language="javascript">
OpenerWindow = opener
var IEMac = "<%=IEMAC%>"
function doReturnMain(){
	var formgroup = "<%=request("formgroup")%>"
	var dbkey = "<%=request("dbname")%>"
	var appkey = "<%=Application("appkey")%>"
	var new_location ='/' + appkey +  '/' + 'save_query.asp?manage_hitlist_mode=' + 'manage_hitlists' + '&dbname=' + dbkey + '&formgroup=' + formgroup + '&formmode=<%=formmode%>'
	document.location.replace(new_location)

}

function doReloadNav(){
	var formgroup = "<%=request("formgroup")%>"
	var dbkey = "<%=request("dbname")%>"
	var appkey = "<%=Application("appkey")%>"
	var new_location ='/' + appkey +  '/' + 'save_query.asp?manage_hitlist_mode=' + 'reload_Nav' + '&dbname=' + dbkey + '&formgroup=' + formgroup
	document.location.replace(new_location)
}

function doManageHitlistAction(action){
	var formgroup = "<%=request("formgroup")%>"
	var dbkey = "<%=request("dbname")%>"
	var appkey = "<%=Application("appkey")%>"
	var actiontemp ='/' + appkey + '/' + dbkey + '/' + dbkey + '_action.asp?dataaction=' + action + '&dbname=' + dbkey + '&formgroup=' + formgroup;
	
	if (document.cows_input_form.db_hitlist_item.options){
		var field = document.cows_input_form.db_hitlist_item.options[document.cows_input_form.db_hitlist_item.selectedIndex];
	
		if (field.value == ""){
			alert("You must first select a hit list from the drop down");
			return false;
		} 
	}
	
	document.cows_input_form.action = actiontemp
	if(action.toLowerCase() == "restore_hitlist"){
			document.cows_input_form.target = OpenerWindow.name;
			//LJB 5/2/2005 update formgroup to what is selected in the dropdown list, not what formgroup opened the dialog
			//var formgroup = document.cows_input_form.fg_selector.options[document.cows_input_form.fg_selector.selectedIndex].value;
			//SYAN modified on 6/3/2005 to fix CSBR-55495
			if (typeof(document.cows_input_form.fg_selector) != 'undefined') {
				var formgroup = document.cows_input_form.fg_selector.options[document.cows_input_form.fg_selector.selectedIndex].value;
			}
			//End of SYAN modification
			
			var actiontemp ='/' + appkey + '/' + dbkey + '/' + dbkey + '_action.asp?dataaction=' + action + '&dbname=' + dbkey + '&formgroup=' + formgroup;

			this.document.cows_input_form.submit();
			if (IEMac == "false"){
				window.close();
			}
	}
	else{
		if(action.toLowerCase() == "edit_hitlist"){
			var hitlistid = field.value
				var new_location ='/' + appkey +  '/' + 'save_query.asp?db_hitlist_item=' + hitlistid + '&manage_hitlist_mode=' + action + '&dbname=' + dbkey + '&formgroup=' + formgroup + '&formmode=<%=formmode%>'
				document.location.replace(new_location)
		}
		else{
			if((action.toLowerCase() == "update_hitlist")||(action.toLowerCase() == "save_hitlist")){
				document.cows_input_form.submit()
			}
			else{
				var bcontinue = confirm("Are you sure you want to delete the selected hit list?");
				if (bcontinue){
					document.cows_input_form.submit()
				}
			}
		}	
	}
}

function doSwitchDbkey(){
	var newDbkey = document.cows_input_form.db_selector.options[document.cows_input_form.db_selector.selectedIndex].value;
	var currDbkey = "<%=dbkey%>";
	var newURL = document.location.href.replace("&dbname=" + currDbkey + "&" ,"&dbname=" + newDbkey + "&")
	document.location.href = newURL;
}

function doSwitchFormGroup(){
	var newfgkey = document.cows_input_form.fg_selector.options[document.cows_input_form.fg_selector.selectedIndex].value;
	var currfgkey = "<%=formgroup%>";
	var newURL = document.location.href.replace("&formgroup=" + currfgkey + "&" ,"&formgroup=" + newfgkey + "&")
	document.location.href = newURL;
}
</script>


</head>

<body bgColor="#ffffff">
<form name="cows_input_form" action="" method ="post">

<%
listType = "USER"
Select Case LCase(manage_hitlist_mode)
Case "save_hitlist"%>
  <table border="0" width="540">
    <tr>
		<td width="300" colspan = "2">
			<a href="#" onclick="doManageHitlistAction('save_hitlist');return false;"><img border="0" src="<%=button_path & "OK.gif"%>" alt="save hit list"></a>
			<a href="#" onclick="window.close();return false;"><img border="0"	src="<%=button_path & "Cancel.gif"%>" alt="close window without saving"></a>
		</td>
    </tr>
    <tr>
		<td width="300" colspan = "2">
			Provide a name and description for the list: </strong>
		</td>
	</tr>
    <tr>
		<td width="210">List Name (255 Characters Max.)</td>
		<td width="310">
			<input type="text" name="hitlist_name" size="30" >
		</td>
	</tr>
	<tr>
		<td>Description (255 Characters Max.)</td>
		<td><input type="text" name="description" size="30" ></td>
	</tr>
    <input type="hidden" name="username" value="<%=Session("USER_SETTINGS_ID" & dbkey) %>"> 
    <input type="hidden" name="db_hitlist_item" value="<%=Session("hitlistID" & dbkey & formgroup)%>">
    <% if Application("ALLOW_PUBLIC_HITLISTS") = "1" then%>
	<tr>
		<td width="100">Make Public</td>
		<td>
			<input type = "checkbox" name = "IS_PUBLIC" value = "1">
		</td>
	</tr>
	<%end if%>
    </tr>
  </table>
<%	case "reload_nav"%>
	<script language="javascript">
		OpenerWindow.reloadNavBar()
		window.close()
	</script>
<%	case "restore_hitlist","restore_last_hitlist"%>
	<table border="0" width="398">
		<tr>
		  <td width="300">
			<a href="#" onclick="doManageHitlistAction('restore_hitlist');return false;"><img border="0" src="<%=button_path & "restore_btn.gif"%>" alt="restore selected hit list"></a>
			<a href="#" onclick="window.close();return false;"><img border="0" src="<%=button_path & "Cancel.gif"%>"  alt="close window without changes"></a> 
		  </td>
		</tr>
		<tr>
			<td>
				<input type = "hidden" name = "username" value = "<%=Session("USER_SETTINGS_ID" & dbkey) %>">		
			</td>
		</tr>
	</table>
	
	<table border="0" width="398">
		<%
		'DGB Removed the FormGroup Selector to fix secondary issue described in CSBR-91859
		WriteCurrentFormGroup()    
		'WriteFormGroupSelector()
		WriteDBSelector()
		%>
	<tr>
		<td>
			Select a list to restore:
		</td>
	</tr>
	<tr>
		<td>
		<%	
			Response.Write "<SELECT name=""db_hitlist_item""  >"
			Response.Write "<option value =>--Select One--</option>"
			if LCase(manage_hitlist_mode)= "restore_hitlist" then
				WriteSavedItems dbkey, formgroup, true
			else
				WriteLastHitListItem dbkey, formgroup
			end if
			Response.Write "</SELECT>"
		%>
		</td>
	</tr>
	</table>
	
	<BR><BR><BR>
	<center>
	<table>
		<tr>
			<td>
				<%if lcase(formmode) = "list" OR lcase(formmode) = "edit" then%>
				<input checked type="radio" name="restore_type" value="replace">Replace current list<BR>
				<input type="radio" name="restore_type" value="intersect">Intersect with current list<br>
				<input type="radio" name="restore_type" value="subtract">Subtract from current list<BR>
				<input type="radio" name="restore_type" value="union">Union with current list<BR>
				<%else%>
				<input checked type="hidden" name="restore_type" value="replace">
				<%end if%>
			</td>
		</tr>
	</table>
	</center>
<%	Case "manage_hitlists", "history"%>
  <table border="0" width="398">
	<tr>
		 <td width="300">
			<a href="#" onclick="doManageHitlistAction('restore_hitlist');return false;"><img border="0" src="<%=button_path & "restore_btn.gif"%>" alt="restore selected hit list"></a>
			<%if LCase(manage_hitlist_mode) = "manage_hitlists" then%>
			<a href="#" onclick="doManageHitlistAction('edit_hitlist');return false;"><img border="0" src="<%=button_path & "edit_btn.gif"%>" alt="edit list information"></a>
			<a href="#" onclick="doManageHitlistAction('delete_hitlist');return false;"><img border="0" src="<%=button_path & "delete_btn.gif"%>" alt="delete selected list"></a>
			<%end if%>
			<a href="#" onclick="doReloadNav();return false;"><img border="0" src="<%=button_path & "Close.gif"%>" alt="close window"></a> 
		</td>
    </tr>
   <tr>
		<td>
			<input type = "hidden" name = "username" value = "<%=Session("USER_SETTINGS_ID" & dbkey) %>">
			<input type = "hidden" name = "new_name" value = "">
			<input type = "hidden" name = "is_public" value = "">
		</td>
	</tr>
</table>
<table border="0" width="398">
		<%
		'DGB Removed the FormGroup Selector to fix secondary issue described in CSBR-91859
		WriteCurrentFormGroup()    
		'WriteFormGroupSelector()
		WriteDBSelector()
		%>
	<tr>
		<td>
			Select a List:
		</td>
	</tr>
	<tr>
		<td>
			<%
			Response.Write "<SELECT name=""db_hitlist_item""  >"
			'Response.Write "<option value =>--Select One--</option>"
			if LCase(manage_hitlist_mode) = "history" then
				listType = "CSDO"
				WriteHistoryItems dbkey, formgroup
			Else
				WriteSavedItems dbkey, formgroup, false
			End if
			Response.Write "</SELECT>"
			%>
		</td>
	</tr>
</table>
<BR><BR><BR>
	<center>
	<table>
		<tr>
			<td>
				
				<%if lcase(formmode) = "list" OR lcase(formmode) = "edit" then%>
				<input checked type="radio" name="restore_type" value="replace">Replace current list<BR>
				<input type="radio" name="restore_type" value="intersect">Intersect with current list<br>
				<input type="radio" name="restore_type" value="subtract">Subtract from current list<BR>
				<input type="radio" name="restore_type" value="union">Union with current list<BR>
				<%else%>
				<input type="hidden" name="restore_type" value="replace">
				<%end if%>
			</td>
		</tr>
	</table>
	</center>
<%Case "edit_hitlist"%>
<table border="0" width="398">
	<tr>
		<td>
			<a href="#" onclick="doManageHitlistAction('update_hitlist');return false;"><img border="0" src="<%=button_path & "ok.gif"%>" alt="update hit list information"></a>
			<a href="#" onclick="doReturnMain();return false;"><img border="0" src="<%=button_path & "Cancel.gif"%>" alt="close window without changes"></a>
		</td>
	</tr>      
<%
hitListIDTableName = GetFullTableName(dbkey, formgroup,"USERHITLISTID")
GetUserSettingsConnection dbname, "base_form_group", "base_connection"
db_hitlist_item = request("db_hitlist_item")
tempArr = split(db_hitlist_item, ":")
hitlistID = tempArr(0)
number_hits = tempArr(1)
sql = "SELECT Name, Description, Is_Public from " & hitListIDTableName & " WHERE id= ?"
	
Set Cmd = Server.CreateObject("ADODB.COMMAND")
Cmd.ActiveConnection = UserSettingConn
Cmd.CommandType = adCmdText
Cmd.CommandText = sql
Cmd.Parameters.Append Cmd.CreateParameter("phitlistID", 5, 1, 0, hitlistID)
	
Set RS = Cmd.Execute
if not (RS.BOF and RS.EOF)then%>
<table border = "1">
	<input type="hidden" name = "db_hitlist_item" value = "<%=hitlistid%>">
	<input type = "hidden" name ="editable_fields" value = "hitlist_name,DESCRIPTION,IS_PUBLIC">
	<input type = "hidden" name ="username" value = "<%=Session("USER_SETTINGS_ID" & dbkey)%>">

	<tr>
		<td>
			List Name
		</td>
		<td >
			<input type = "text" size= "40" name ="hitlist_name" value = "<%=RS("name")%>">
		</td>
	</tr>
	<tr>
		<td >
			Description
		</td>
		<td >
			<input type = "text" size= "40" name ="DESCRIPTION" value = "<%=RS("description")%>">
		</td>
	</tr>
	<%
	if Application("ALLOW_PUBLIC_HITLISTS") = "1" then
	if RS("is_public").value = 1 then checkedVal = "checked"%>
	<tr>
		<td>
			Public List
		</td>
		<td size= "40" >
			<input type="checkbox" name = "IS_PUBLIC" <%=checkedVal%> value="1">
		</td>
	</tr>	
	<%end if%>
<%end if%>
</table>
<%End Select%>
<input type="hidden" name="listType" value="<%=listType%>">
</form>
</body>
</html>

<%
Sub WriteHistoryItems(dbkey, formgroup)
		sql = getSessionInfoFromCSDOHitlist(dbkey, formgroup,Session("USER_SETTINGS_ID" & dbkey))
		on error resume next
		
		GetManageQueriesConnection dbkey, formgroup, "base_connection"
		Set RS = ManageQueriesConn.Execute(sql)
		
		Response.Write "<option value =>--HISTORY ITEMS--</option>"
		if Not (RS.EOF and RS.BOF) then
			Do While Not RS.EOF  
				hitlist_id = RS("id") 
				number_hits = RS("number_hits") 
				Response.Write "<option value=""" & hitlist_id  & ":" & number_hits & """>" & RS("date_created") &  " (" & number_hits & " hits)</option>"
				RS.MoveNext
			Loop
		end if
End Sub

Sub WriteLastHitListItem(dbkey, formgroup)
		Dim nhits
		
		nhits = Session("LastHitListRecordcount" & dbkey & formgroup)
		Response.Write "<option value=""" & Session("LastHitListID" & dbkey & formgroup) & ":" & nhits & """>Last Hitlist (" & nhits & " hits)</option>"
End Sub

Sub WriteSavedItems(dbkey,formgroup, showPublic)
		sql = getSavedHitlistsSQL(dbkey, formgroup,Session("USER_SETTINGS_ID" & dbkey), showPublic)
			
		GetManageQueriesConnection dbkey, formgroup, "base_connection"
		Set RS = ManageQueriesConn.Execute(sql)
		
		Response.Write "<option value =>--SAVED HIT LISTS--</option>"
		if Not (RS.EOF and RS.BOF) then
			Do While Not RS.EOF
				hitlist_name = RS("name") 
				description = RS("description") 
				hitlist_id = RS("id")
				number_hits = RS("number_hits") 
				if RS("is_public") then
					isPublic = " (Public)"
				Else
					isPublic = ""
				End if
				Response.Write "<option value=""" & hitlist_id  & ":" & number_hits & """>" & hitlist_name & " (" & number_hits & " hits)" & isPublic & "</span> " &  "</option>"
				RS.MoveNext
			Loop
		rs.close
		end if
  End Sub
  
Sub WriteDBSelector()
	if lcase(formmode) <> "search" OR lcase(formgroupflag) <> "global_search" then Exit Sub
	'EXIT POINT
	
	multi_dbnames = Application("DBNames")
	multi_dbnames_array = split(multi_dbnames, ",", -1)
	arrSize = UBound(multi_dbnames_array )
	if  arrSize > 0 then 
		Response.Write "<tr>" & vblf
		Response.Write "	<td>" & vblf
		Response.Write "		Select a Database:" & vblf
		Response.Write "	</td>" & vblf
		Response.Write "</tr>" & vblf
		Response.Write "<tr>" & vblf
		Response.Write "	<td>" & vblf
		Response.Write "		<SELECT name=""db_selector"" onChange=""doSwitchDbkey()"" >" & vblf
		For i=0 to arrSize
			theDB = multi_dbnames_array(i)
			displayname = Application("DisplayName" & theDB)
			if theDB = dbkey then
				checked = "selected"
			Else
				checked = ""
			End if	
			Response.Write "		<option " & checked & " value=""" & theDB & """>" & displayname &"</option>"
		Next  
		Response.Write "</SELECT>" & vblf
		Response.Write "</td>" & vblf
		Response.Write "</tr>" & vblf
	end if
End sub	  

Sub WriteCurrentFormGroup()
    Dim RS
	Dim Cmd
	
	if NOT CBool(Application("ALLOW_HITILIST_MNGMNT_FG_SELECTOR")) then Exit Sub
	FORMGROUP_UNIQUE_IDENTIFIER = Application("FORMGROUP_UNIQUE_IDENTIFIER")
	schema =  getCoreSchemaPrefix(dbkey, formgroup)
	dbms =  GetUserSettingsSQLSyntax(dbkey, formgroup)
	if UCase(dbms) = "ORACLE" then
		sql = "SELECT FORMGROUP_ID,FORMGROUP_NAME, DESCRIPTION FROM " & schema & "." & "DB_FORMGROUP WHERE Upper(USER_ID) = ? OR IS_PUBLIC='1' OR IS_PUBLIC='Y' ORDER BY DESCRIPTION"
	else
		sql = "SELECT FORMGROUP_ID,FORMGROUP_NAME, DESCRIPTION FROM DB_FORMGROUP WHERE USER_ID = ? OR IS_PUBLIC='1' OR IS_PUBLIC='Y' ORDER BY DESCRIPTION"
	end if	
	GetManageQueriesConnection dbkey, formgroup, "base_connection"
	Set Cmd = Server.CreateObject("ADODB.COMMAND")
	Cmd.ActiveConnection = ManageQueriesConn
	Cmd.CommandType = adCmdText
	Cmd.CommandText = sql
	 
	Cmd.Parameters.Append Cmd.CreateParameter("pUserName", 200, 1, 30, UCase(Session("USER_SETTINGS_ID" & dbkey)))
	on error resume next
	Set RS = Cmd.Execute
	Response.Write "<tr>" & vblf
	Response.Write "	<td>" & vblf
	Response.Write "		Current Search Form:&nbsp;"
	currentForm = ""
	if err.number = 0 then
		if  NOT (RS.EOF AND RS.BOF) then 
			Do While NOT RS.EOF
				theFG = RS(FORMGROUP_UNIQUE_IDENTIFIER)
				displayname = RS("FORMGROUP_NAME") & ":" & RS("DESCRIPTION")
				if lcase(theFG) = lcase(formgroup) then
					currentForm = displayname
				End if	
				RS.MoveNext
			Loop
			if currentForm= "" then currentForm = formgroup
		end if
	else
	    currentForm = formgroup	
	end if
	Response.Write "	</td>" & vblf
	Response.Write "</tr>" & vblf
	Response.Write "<tr>" & vblf
	Response.Write "	<td>" & vblf 
	Response.Write "&nbsp;&nbsp;&nbsp;&nbsp;" & currentForm
	Response.Write "<BR><BR></td>" & vblf
	Response.Write "</tr>" & vblf
End sub

Sub WriteFormGroupSelector()
	Dim RS
	Dim Cmd
	
	if NOT CBool(Application("ALLOW_HITILIST_MNGMNT_FG_SELECTOR")) then Exit Sub
	FORMGROUP_UNIQUE_IDENTIFIER = Application("FORMGROUP_UNIQUE_IDENTIFIER")
	schema =  getCoreSchemaPrefix(dbkey, formgroup)
	
	dbms =  GetUserSettingsSQLSyntax(dbkey, formgroup)
	if UCase(dbms) = "ORACLE" then
		sql = "SELECT FORMGROUP_ID,FORMGROUP_NAME, DESCRIPTION FROM " & schema & "." & "DB_FORMGROUP WHERE Upper(USER_ID) = ? OR IS_PUBLIC='1' OR IS_PUBLIC='Y' ORDER BY DESCRIPTION"
	else
		sql = "SELECT FORMGROUP_ID,FORMGROUP_NAME, DESCRIPTION FROM DB_FORMGROUP WHERE USER_ID = ? OR IS_PUBLIC='1' OR IS_PUBLIC='Y' ORDER BY DESCRIPTION"
	end if	
	GetManageQueriesConnection dbkey, formgroup, "base_connection"
	Set Cmd = Server.CreateObject("ADODB.COMMAND")
	Cmd.ActiveConnection = ManageQueriesConn
	Cmd.CommandType = adCmdText
	Cmd.CommandText = sql
	 
	Cmd.Parameters.Append Cmd.CreateParameter("pUserName", 200, 1, 30, UCase(Session("USER_SETTINGS_ID" & dbkey)))
	on error resume next
	Set RS = Cmd.Execute
	
	if err.number = 0 then
		if  NOT (RS.EOF AND RS.BOF) then 
			Response.Write "<tr>" & vblf
			Response.Write "	<td>" & vblf
			Response.Write "		Select a Search Form:" & vblf
			Response.Write "	</td>" & vblf
			Response.Write "</tr>" & vblf
			Response.Write "<tr>" & vblf
			Response.Write "	<td>" & vblf
			Response.Write "		<SELECT name=""fg_selector"" onChange=""doSwitchFormGroup()"" >" & vblf
			Do While NOT RS.EOF
				theFG = RS(FORMGROUP_UNIQUE_IDENTIFIER)
				displayname = RS("FORMGROUP_NAME") & ":" & RS("DESCRIPTION")
				if lcase(theFG) = lcase(formgroup) then
					checked = "selected"
				Else
					checked = ""
				End if	
				Response.Write "		<option " & checked & " value=""" & theFG & """>" & displayname &"</option>"
				RS.MoveNext
			Loop 
			Response.Write "</SELECT>" & vblf
			Response.Write "</td>" & vblf
			Response.Write "</tr>" & vblf
		end if
	end if
End sub	

%>
