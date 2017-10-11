﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="userHome.aspx.cs" Inherits="Thesis.userHome" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <table>
            <tr>
                <th>Group Name</th>
            </tr>
            <%for (int i = 0; i < this.gname.Count; i++)
                { %>
            <tr>
                <td><a href="group.aspx"><%=this.gname.ElementAt(i)%></a></td>
            </tr>
            <%} %>
            <tr style="text-align:center">
                <td><asp:Button ID="Button1" runat="server" Text="Create New Group" OnClick="Button1_Click" /></td>
                <td><asp:Button ID="Button2" runat="server" Text="See All Groups" OnClick="Button2_Click" /></td>
            </tr>
        </table>
    </form>
</body>
</html>