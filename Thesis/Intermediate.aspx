<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Intermediate.aspx.cs" Inherits="Thesis.Intermediate" %>

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
        <asp:Label ID="Label1" runat="server" Text="Label" Height="38px" Width="500px" Font-Bold="True" Font-Size="Larger"></asp:Label>
        <br />
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Leave" Width="112px" />
&nbsp;
        <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Subscribe" Width="112px"/>
        </div>
                <div class="col-sm-4"></div>
            </div>
        </div>
    </form>
</body>
</html>
