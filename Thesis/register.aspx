<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="Thesis.register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css"/>
    <title></title>
</head>
<script src="src/sjcl.js"></script>
<script type="text/javascript">
    function check() {      //Checks if the username and password fields are blank or not     
        var user = document.getElementById("<%=TextBox1.ClientID%>").value;     
        var pas = document.getElementById("<%=TextBox2.ClientID%>").value;
        if (user.length > 0 && pas.length > 0) {        //Fields are not empty so moves forward with the execution
            document.getElementById("HiddenField5").value = "1";
            pwHash();
        }
        else {      //one of the field is empty so breaks the execution
            document.getElementById("HiddenField5").value = "0"; 
        }
    }
    function pwHash(){          //For Hashing User's Password'     
        var pass = document.getElementById("<%=TextBox2.ClientID%>").value;
        var salt = sjcl.random.randomWords(8);      //Randomly generated salt
        var salt1 = sjcl.codec.base64.fromBits(salt);       //Conversion of salt into Base64 format
        var pHash = sjcl.misc.pbkdf2(pass, salt, 1000, 256);        //Generation of the user's password hash
        var pHash1 = sjcl.codec.base64.fromBits(pHash);     //Conversion of hash into Base64 format
        document.getElementById("HiddenField3").value = pHash1;
        keyGenerate(pass, salt1);
    }
    function keyGenerate(pass, salt1) {         //To Generate the Pair of Keys         
        var pass = pass;
        var salt1 = salt1;
        var pair = sjcl.ecc.elGamal.generateKeys(256);      //Generation of public and private keys
        var pKey = pair.pub.get();
        pKey = sjcl.codec.base64.fromBits(pKey.x.concat(pKey.y));       //Serialization of public key
        document.getElementById("HiddenField1").value = pKey;
        var sKey = pair.sec.get();
        sKey = sjcl.codec.base64.fromBits(sKey);        //Serialization of private key
        sKeyEncryption(sKey, pass, salt1);
    }
    function sKeyEncryption(sKey, pass, salt1) {          //To Encrypt the Private Key of the User
        var sKey = sKey;
        var pass = pass;
        var salt1 = salt1;
        var symKey = sjcl.hash.sha256.hash(sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(pass)) + salt1);        //Symmetric key to be used to encrypt the private key
        var symKey1 = sjcl.codec.base64.fromBits(symKey);
        var encSecretKey = sjcl.encrypt(symKey1, sKey);         //Encrypted secret key     
        var encSecretKey1 = encodeURIComponent(encSecretKey);       //Encoding of secret key to hide special characters ({, ?, /, ...)
        document.getElementById("HiddenField2").value = encSecretKey1;
        document.getElementById("HiddenField4").value = salt1;
    }
</script>
<body style="background-color:#eee; padding-top:60px">
    <form id="form1" runat="server">
        <nav class="navbar navbar-expand-sm fixed-top" style="background-color:#310ba1; height:60px;">
            <a class="navbar-brand" href="about.aspx" style="padding-left:10%"><img src="img/logo.png" style=" width:70px; height:60px;" /></a>
            <ul class="navbar-nav" style="padding-left:63%;">
                <li class="nav-item">
                  <a href="login.aspx"><button type="button" class="btn-light" style="height:60px; border-width:0px; font-family:fantasy;" >Login</button></a>   
                </li>
                <li class="nav-item">
                  <a href="about.aspx"><button type="button" class="btn-light" style="height:60px; border-width:0px; font-family:fantasy;" >About</button></a> 
                </li>
                <li class="nav-item">
                  <a href="contact.aspx"><button type="button" class="btn-light" style="height:60px; border-width:0px; font-family:fantasy; color:#310ba1" >Contact</button></a> 
                </li>
            </ul>
        </nav>
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-12">
                    <div class="row" style="padding-top:10%">
                        <div class="col-sm-6" style="padding-top:60px;">
                            <pre style="font-size:larger;">
                                 <mark style="font-size:xx-large; color:#310ba1; background:#eee; font-family:fantasy">EMBER</mark> is an End-toEnd
                                 Encrypted Message Board
                                 which considers user's
                                 privacy as its main goal.
                            </pre>
                        </div>
                        <div class="col-sm-4" style="background-color:white; border-radius:25px;  padding-top:50px; padding-bottom:50px; padding-left:40px;">
                            <h4>Username</h4>
                            <asp:TextBox ID="TextBox1" runat="server" style="border-radius:5px"></asp:TextBox>                            
                            <h4>Password</h4>
                            <asp:TextBox ID="TextBox2" runat="server" TextMode="Password" style="border-radius:5px"></asp:TextBox>
                            <br /><br />
                            <asp:Button ID="Button1" CssClass="btn btn-dark" runat="server" Text="Register" OnClick="Button1_Click" OnClientClick="check()"/>
                            <asp:HiddenField ID="HiddenField1" runat="server" />
                            <asp:HiddenField ID="HiddenField2" runat="server" />
                            <asp:HiddenField ID="HiddenField3" runat="server" />
                            <asp:HiddenField ID="HiddenField4" runat="server" />
                            <asp:HiddenField ID="HiddenField5" runat="server" />
                            <br /><br />
                            <asp:Label ID="Label1" CssClass="alert alert-danger" runat="server" Text="Label" Visible="False"><strong>Warning!</strong> Username or Password can not be left blank.</asp:Label>
                        </div>    
                    </div>
                </div>
                
            </div> 
            
&nbsp;</div>
    </form>
</body>
</html>
