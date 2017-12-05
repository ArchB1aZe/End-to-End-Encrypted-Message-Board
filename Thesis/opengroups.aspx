<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="opengroups.aspx.cs" Inherits="Thesis.opengroups" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta charset="utf-8"/>
    <title></title>
</head>

<body>
    <form id="form1" runat="server">
        <table>
            <tr>
                <th>Group Name</th>
                <th>Type</th>
            </tr>
            <%for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {%>
            <tr>
                
                <td><a href ="Intermediate.aspx?groupName=<%=ds.Tables[0].Rows[i][1].ToString()%>"><%=ds.Tables[0].Rows[i][1].ToString()%></a></td>
                <td><%=ds.Tables[0].Rows[i][2].ToString()%></td>
                
            </tr>
            <%} %>
        </table>
    </form>
</body>
</html>
