<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="create.aspx.cs" Inherits="Thesis.create" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="src/sjcl.js"></script>
    <script type="text/javascript">
        
        function check() {      //Checks if GroupName exist or not
            var grpName = document.getElementById("<%=TextBox1.ClientID%>").value;
            var flag = 0;
            if (grpName.length > 0) {
            <%for (int i = 0; i < this.ds.Tables[0].Rows.Count; i++)
        {%>
                if (grpName == "<%=this.ds.Tables[0].Rows[i][1].ToString()%>") {
                    flag = 1;
                   
                }
                <%}%>
                if (flag == 1) {
                    document.getElementById("HiddenField1").value = "1";
                } else {
                    
                    document.getElementById("HiddenField1").value = "2";
                    CreateGroup();
                }
            }
        
        else {

             document.getElementById("HiddenField1").value = "0"; 

        }
        }
        function CreateGroup() {
            var grpName = document.getElementById("<%=TextBox1.ClientID%>").value;
            var userList = document.getElementById("<%=TextBox2.ClientID%>").value;
            var salt1_1 = sjcl.random.randomWords(8);      //Randomly generated salt
            var salt1_2 = sjcl.codec.base64.fromBits(salt1_1);
            var salt2_1 = sjcl.random.randomWords(8);      //Randomly generated salt
            var salt2_2 = sjcl.codec.base64.fromBits(salt2_1);
            var grpKey = sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(salt1_2 + salt2_2));
            document.getElementById("HiddenField2").value = grpKey; 
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Group Name: <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            <br />
            Add Members: <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox> 
            <asp:HiddenField ID="HiddenField1" runat="server" />
            <asp:HiddenField ID="HiddenField2" runat="server" />
            <br />
            <asp:Button ID="Button1" runat="server" Text="Create" OnClick="Button1_Click" OnClientClick="check()"/>
            <br />
            <asp:Label ID="Label1" runat="server" Text="Label" Visible="False"></asp:Label>
        </div>
    </form>
</body>
</html>
