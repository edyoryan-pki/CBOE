<%@ Page Language="C#" AutoEventWireup="true" CodeFile="COETableManagerTest.aspx.cs" Inherits="COETableManagerTest"  ValidateRequest="false"%>

<%@ Register Assembly="CambridgeSoft.COE.Framework" Namespace="CambridgeSoft.COE.Framework.Controls.COETableManager"
    TagPrefix="COECntrl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>COEtableManager Server Control Sample Application</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <COECntrl:COETableManager ID="COETableManager1" runat="server" AppName="SAMPLE" Height="300px"
            Width="500px" />
        &nbsp;</div>
    </form>
</body>
</html>