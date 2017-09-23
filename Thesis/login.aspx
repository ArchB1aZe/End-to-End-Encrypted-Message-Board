<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Thesis.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<script src="src/sjcl.js"></script>
<script type="text/javascript">
    function check() {
        var user = document.getElementById("<%=TextBox1.ClientID%>").value;
        var pas = document.getElementById("<%=TextBox2.ClientID%>").value;
        if (user.length > 0 && pas.length > 0) {
            pwHashCheck();
        }
        else {
            
            document.getElementById("HiddenField4").value = "0";
            
        }
    }
    function pwHashCheck() {
        var temp = 0;
        var pass1 = document.getElementById("<%=TextBox2.ClientID%>").value;
        <%for (int z = 0; z < this.ds.Tables[0].Rows.Count; z++) {%>
        var salt1 = "<%=this.ds.Tables[0].Rows[z][3].ToString()%>";
        var salt = sjcl.codec.base64.toBits(salt1);
        var pHash1 = sjcl.codec.base64.fromBits(sjcl.misc.pbkdf2(pass1, salt, 1000, 256));
        if (pHash1 == "<%=this.ds.Tables[0].Rows[z][2].ToString()%>") {
            
            temp = 1;
            var symKey2_1 = sjcl.hash.sha256.hash(sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(pass1)) + sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(salt1)));
            var symKey2_2 = sjcl.codec.base64.fromBits(symKey2_1);
            var symKey1_1 = sjcl.hash.sha256.hash(sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(pass1)) + salt1);
            var symKey1_2 = sjcl.codec.base64.fromBits(symKey1_1);
            document.getElementById("HiddenField1").value = symKey2_2;
            var pKey_1 = "<%=this.ds.Tables[0].Rows[z][4].ToString()%>";
            var pKey_2 = sjcl.codec.base64.toBits(pKey_1);
            document.getElementById("HiddenField2").value = pKey_2;
            var sKey_1 = "<%=this.ds.Tables[0].Rows[z][5].ToString()%>";
            var sKey_2 = decodeURI(sKey_1);
            var sKey_3 = sjcl.decrypt(symKey1_2, sKey_2);
            var sKey_4 = sjcl.codec.base64.toBits(sKey_3);
            document.getElementById("HiddenField3").value = sKey_4;
            
        }   
        <%}%>
        if (temp == 1) {
            document.getElementById("HiddenField4").value = "1";
        }
        else {
            document.getElementById("HiddenField4").value = "2";
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
            <asp:HiddenField ID="HiddenField1" runat="server" />
            <asp:HiddenField ID="HiddenField2" runat="server" />
            <asp:HiddenField ID="HiddenField3" runat="server" />
            <asp:HiddenField ID="HiddenField4" runat="server" />
            <br />
            <asp:Label ID="Label1" runat="server" Text="Label" Visible="False"></asp:Label>
&nbsp;</div>
    </form>
</body>
</html>
