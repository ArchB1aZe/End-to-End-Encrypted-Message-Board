<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Thesis.login" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Services" %>
<script src="src/jquery-3.2.1.min.js"></script>
<script type="text/C#" runat="server">
    [WebMethod]
    public static string[] GetUserInfo(string userName)
    {
        string[] userInfo = new string[6];
        SqlDataAdapter ad = new SqlDataAdapter("select * from [user] where username = '" + userName + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds2 = new DataSet();
        ad.Fill(ds2);
        for(int i=0; i < ds2.Tables[0].Columns.Count; i++)
        {
            if(ds2.Tables[0].Rows.Count > 0)
            {
                userInfo[i] = ds2.Tables[0].Rows[0][i].ToString();
            }
            else
            {
                userInfo[i] = null;
            }


        }
        return userInfo;
    }
</script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta charset="utf-8"/>
    <title></title>
</head>
<script src="src/sjcl.js"></script>
<script type="text/javascript">
    function check() {      //Checks if username and password fields are empty or not
        var user = document.getElementById("<%=TextBox1.ClientID%>").value;
        var pas = document.getElementById("<%=TextBox2.ClientID%>").value;
        if (user.length > 0 && pas.length > 0) {
            retreiveUserInfo();
        }
        else {
            
            document.getElementById("HiddenField4").value = "0";
            
        }
    }
    function retreiveUserInfo() {
        var userName = document.getElementById("<%=TextBox1.ClientID%>").value;
        $.ajax({
            type: 'POST',
            url: 'login.aspx/GetUserInfo',
            async: false,
            data: JSON.stringify({ userName: userName }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (uName) {
                pwHashCheck(uName.d);
            }
        });
        
    }
    function pwHashCheck(userInfo) {
        if (userInfo[0] == null) {
            document.getElementById("HiddenField4").value = "2";
        }
        else {
            var temp = 0;
            var userName = userInfo[1];
            var pass1 = document.getElementById("<%=TextBox2.ClientID%>").value;
            var salt1 = userInfo[3];     //gets the salt value from database
            var salt = sjcl.codec.base64.toBits(salt1);
            var pHash1 = sjcl.codec.base64.fromBits(sjcl.misc.pbkdf2(pass1, salt, 1000, 256));
            if (pHash1 == userInfo[2]) {     //compares the hash of password with the hash stored in database
                temp = 1;       //if hash matches, retreives the keys and stores them in user's current session
                var symKey1_1 = sjcl.hash.sha256.hash(sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(pass1)) + salt1);        //Key used to encrypt the private key
                var symKey1_2 = sjcl.codec.base64.fromBits(symKey1_1);
                var pKey_1 = userInfo[4];
                document.getElementById("HiddenField2").value = pKey_1;
                var sKey_1 = userInfo[5];
                var sKey_2 = decodeURIComponent(sKey_1);
                var sKey_3 = sjcl.decrypt(symKey1_2, sKey_2);
                document.getElementById("HiddenField3").value = sKey_3;
                document.getElementById("HiddenField5").value = userInfo[0];
            }
            if (temp == 1) {        //Everything is fine and moves forward with the code
                document.getElementById("HiddenField4").value = "1";
            }
            else {      //Either username or password is incorrect
                document.getElementById("HiddenField4").value = "2";
            }
        }
        
    }

       
       
    
</script>
<body>
    <form id="form1" runat="server">
        <div>
            Username:
            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            <br />
            Password:
            <asp:TextBox ID="TextBox2" runat="server" TextMode="Password"></asp:TextBox>
            <br />
            <asp:Button ID="Button1" runat="server" Text="Login" OnClick="Button1_Click" OnClientClick="check()"/>
            <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Register" />
            <asp:HiddenField ID="HiddenField1" runat="server" />
            <asp:HiddenField ID="HiddenField2" runat="server" />
            <asp:HiddenField ID="HiddenField3" runat="server" />
            <asp:HiddenField ID="HiddenField5" runat="server" />
            <asp:HiddenField ID="HiddenField4" runat="server" />
            <br />
            <asp:Label ID="Label1" runat="server" Text="Label" Visible="False"></asp:Label>
&nbsp;</div>
    </form>
</body>
</html>
