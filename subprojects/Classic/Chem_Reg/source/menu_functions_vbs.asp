<%'Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved%>
<%'PURPOSE OF FILE: TO add custom vbscript functions to an applciation
'All form files generated by the wizard have a #INCLUDE for this file. Add the #INCLUDE to form files
'that you might add to the application.%>


<%


'Menu Bar hide/dim functions




function dohideAdministrativeMenu(dbkey, formgroup)
	if Session("ADD_ADMIN_SCHEMA" & dbkey) or Session("EDIT_ADMIN_SCHEMA" & dbkey) or  Session("DELETE_ADMIN_SCHEMA" & dbkey) or Session("CSS_CREATE_USER" & dbkey) OR Session("CSS_EDIT_USER" & dbkey) OR Session("CSS_DELETE_USER" & dbkey) or  Session("CSS_CREATE_ROLE" & dbkey) OR Session("CSS_EDIT_ROLE" & dbkey) OR Session("CSS_DELETE_ROLE" & dbkey) then
		thereturn = false
	else
		thereturn = true
	end if 
	dohideAdministrativeMenu = thereturn
end function



function dohideManageUsers(dbkey, formgroup)

	if Session("CSS_CREATE_USER" & dbkey) OR Session("CSS_EDIT_USER" & dbkey) OR Session("CSS_DELETE_USER" & dbkey) then
		thereturn = false
	else
		thereturn = true
	end if 
	dohideManageUsers = thereturn
end function

function dohideManageRoles(dbkey, formgroup)

	if Session("CSS_CREATE_ROLE" & dbkey) OR Session("CSS_EDIT_ROLE" & dbkey) OR Session("CSS_DELETE_ROLE" & dbkey)  then
		thereturn = false
	else
		thereturn = true
	end if 
	dohideManageRoles = thereturn
end function



%>