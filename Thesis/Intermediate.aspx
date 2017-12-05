<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Intermediate.aspx.cs" Inherits="Thesis.Intermediate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Label ID="Label1" runat="server" Text="Label" Height="38px" Width="500px" Font-Bold="True" Font-Size="Larger"></asp:Label>
        <br />
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Leave" Width="112px" />
&nbsp;
        <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Subscribe" Width="112px"/>
        <div>
        </div>
    </form>
</body>
</html>
