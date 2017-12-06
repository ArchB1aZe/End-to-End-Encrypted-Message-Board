<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="userHome.aspx.cs" Inherits="Thesis.userHome" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css"/>
    <title></title>
</head>
<body style="background-color:#eee; padding-top:60px">
    <form id="form1" runat="server">
        <nav class="navbar navbar-expand-sm fixed-top" style="background-color:#310ba1; height:60px;">
            <a class="navbar-brand" href="about.aspx" style="padding-left:10%"><img src="img/logo.png" style=" width:70px; height:60px;" /></a>
            <ul class="navbar-nav" style="padding-left:63%;">
                <li class="nav-item">
                  <asp:Button ID="Button3" runat="server" Text="Requests" OnClick="Button3_Click" class="btn-light" style="height:60px; border-width:0px; font-family:fantasy;" />
                </li>
                <li class="nav-item">
                  <a href="settings.aspx"><button type="button" class="btn-light" style="height:60px; border-width:0px; font-family:fantasy;" >Settings</button></a> 
                </li>
                <li class="nav-item">
                  <a href="login.aspx"><button type="button" class="btn-light" style="height:60px; border-width:0px; font-family:fantasy; color:#310ba1" >Logout</button></a> 
                </li>
            </ul>
        </nav>
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-4"></div>
                <div class="col-sm-4">
                    <table class="table table-striped table-hover">
                        <tr>
                            <th>Group Name</th>
                            <th>Type</th>
                        </tr>
                        <%for (int i = 0; i < this.gname.Count; i++)
                            { %>
                        <tr>
                            <td><a href="Group.aspx?groupName=<%=this.gname.ElementAt(i).ToString()%>"><%=this.gname.ElementAt(i)%></a></td>
                            <td><%=this.type.ElementAt(i)%></td>
                        </tr>
                        <%} %>
                        <tr>
                            <td><asp:Button CssClass="btn btn-dark" ID="Button1" runat="server" Text="Create New Group" OnClick="Button1_Click" /></td>
                            <td><asp:Button CssClass="btn btn-dark" ID="Button2" runat="server" Text="See All Groups" OnClick="Button2_Click" /></td>
                            
                        </tr>
                    </table>
                </div>
                <div class="col-sm-4"></div>
            </div>
        </div>
        
    </form>
</body>
</html>
