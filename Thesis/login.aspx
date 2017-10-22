<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Thesis.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<script src="src/sjcl.js"></script>
<script type="text/javascript">
    function check() {      //Checks if username and password fields are empty or not
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
        <%for (int z = 0; z < this.ds.Tables[0].Rows.Count; z++) {%>  //Iterate through all the rows of user table
            var salt1 = "<%=this.ds.Tables[0].Rows[z][3].ToString()%>";     //gets the salt value from database
            var salt = sjcl.codec.base64.toBits(salt1);
            var pHash1 = sjcl.codec.base64.fromBits(sjcl.misc.pbkdf2(pass1, salt, 1000, 256));
            if (pHash1 == "<%=this.ds.Tables[0].Rows[z][2].ToString()%>") {     //compares the hash of password with the hash stored in database
                temp = 1;       //if hash matches, retreives the keys and stores them in user's current session
                var symKey1_1 = sjcl.hash.sha256.hash(sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(pass1)) + salt1);        //Key used to encrypt the private key
                var symKey1_2 = sjcl.codec.base64.fromBits(symKey1_1);
                var pKey_1 = "<%=this.ds.Tables[0].Rows[z][4].ToString()%>";
                var pKey_2 = new sjcl.ecc.elGamal.publicKey(
                    sjcl.ecc.curves.c256,
                    sjcl.codec.base64.toBits(pKey_1)
                )
                document.getElementById("HiddenField2").value = pKey_2;
                var sKey_1 = "<%=this.ds.Tables[0].Rows[z][5].ToString()%>";
                var sKey_2 = decodeURIComponent(sKey_1);
                var sKey_3 = sjcl.decrypt(symKey1_2, sKey_2);
                var sKey_4 = new sjcl.ecc.elGamal.secretKey(
                    sjcl.ecc.curves.c256,
                    sjcl.ecc.curves.c256.field.fromBits(sjcl.codec.base64.toBits(sKey_3))
                )
                document.getElementById("HiddenField3").value = sKey_4;
                document.getElementById("HiddenField5").value = "<%=ds.Tables[0].Rows[z][0].ToString()%>"; 
            }   
        <%}%>
        if (temp == 1) {        //Everything is fine and moves forward with the code
            document.getElementById("HiddenField4").value = "1";
        }
        else {      //Either username or password is incorrect
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
            <asp:HiddenField ID="HiddenField5" runat="server" />
            <asp:HiddenField ID="HiddenField4" runat="server" />
            <br />
            <asp:Label ID="Label1" runat="server" Text="Label" Visible="False"></asp:Label>
&nbsp;</div>
    </form>
</body>
</html>
