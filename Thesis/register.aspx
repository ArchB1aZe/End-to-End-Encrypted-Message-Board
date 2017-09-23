<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="Thesis.register" %>

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
            document.getElementById("HiddenField5").value = "1";
            pwHash();
        }
        else {
            document.getElementById("HiddenField5").value = "0"; 
        }
    }
    function pwHash(){          //For Hashing User's Password'     
        var pass = document.getElementById("<%=TextBox2.ClientID%>").value;
        var salt = sjcl.random.randomWords(8);
        var salt1 = sjcl.codec.base64.fromBits(salt);
        var pHash = sjcl.misc.pbkdf2(pass, salt, 1000, 256);
        var pHash1 = sjcl.codec.base64.fromBits(pHash);
        document.getElementById("HiddenField3").value = pHash1;
        keyGenerate(pass, salt1);
    }
    function keyGenerate(pass, salt1) {         //To Generate the Pair of Keys         
        var pass = pass;
        var salt1 = salt1;
        var pair = sjcl.ecc.elGamal.generateKeys(256);
        var pKey = pair.pub.get();
        pKey = sjcl.codec.base64.fromBits(pKey.x.concat(pKey.y));
        document.getElementById("HiddenField1").value = pKey;
        var sKey = pair.sec.get();
        sKey = sjcl.codec.base64.fromBits(sKey);
        sKeyEncryption(sKey, pass, salt1);
    }
    function sKeyEncryption(sKey, pass, salt1) {          //To Encrypt the Private Key of the User
        var sKey = sKey;
        var pass = pass;
        var salt1 = salt1;
        var symKey = sjcl.hash.sha256.hash(sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(pass)) + salt1);
        var symKey1 = sjcl.codec.base64.fromBits(symKey);
        var encSecretKey = sjcl.encrypt(symKey1, sKey);
        var encSecretKey1 = encodeURIComponent(encSecretKey);
        document.getElementById("HiddenField2").value = encSecretKey1;
        document.getElementById("HiddenField4").value = salt1;
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
            <asp:Button ID="Button1" runat="server" Text="Register" OnClick="Button1_Click" OnClientClick="check()"/>
            <asp:HiddenField ID="HiddenField1" runat="server" />
            <asp:HiddenField ID="HiddenField2" runat="server" />
            <asp:HiddenField ID="HiddenField3" runat="server" />
            <asp:HiddenField ID="HiddenField4" runat="server" />
            <asp:HiddenField ID="HiddenField5" runat="server" />
            <br />
            <asp:Label ID="Label1" runat="server" Text="Label" Visible="False"></asp:Label>
&nbsp;</div>
    </form>
</body>
</html>
