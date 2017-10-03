<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="opengroups.aspx.cs" Inherits="Thesis.opengroups" %>

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
            <%for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {%>
            <tr>
                <td><a href ="group.aspx"></a><%=ds.Tables[0].Rows[i][1].ToString()%></td>
            </tr>
            <%} %>
        </table>
    </form>
</body>
</html>
