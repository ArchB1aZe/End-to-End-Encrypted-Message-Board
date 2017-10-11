<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="create.aspx.cs" Inherits="Thesis.create" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Services" %>
<script src="src/jquery-3.2.1.min.js"></script>
<script type="text/C#" runat="server">
    [WebMethod]
    public static int CreateGroup(string gname, string type)
    {
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
        conn.Open();
        string query = "INSERT INTO [group] (gname, type)";
        query += " VALUES (@gname, @type)";
        SqlCommand myCommand = new SqlCommand(query, conn);
        myCommand.Parameters.AddWithValue("@gname", gname);
        myCommand.Parameters.AddWithValue("@type", type);
        myCommand.ExecuteNonQuery();
        conn.Close();
        SqlDataAdapter ad = new SqlDataAdapter("select gid from [group] where gname = '" + gname + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds1 = new DataSet();
        ad.Fill(ds1);
        return Convert.ToInt32(ds1.Tables[0].Rows[0][0]);
    }
    [WebMethod]
    public static string[] GetUserKeys(string[] userNames1)
    {
        for(int i=0; i<userNames1.Length; i++)
        {
            SqlDataAdapter ad = new SqlDataAdapter("select uid, pKey from [user] where username = '" + userNames1[i] + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            DataSet ds2 = new DataSet();
            ad.Fill(ds2);         
        }
        return userNames1;
    }
</script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="src/sjcl.js"></script>
    <script type="text/javascript">
        
        function check() {      //Checks if GroupName exist or not
            var grpName = document.getElementById("<%=TextBox1.ClientID%>").value;
            var type1 = document.getElementById("<%=DropDownList1.ClientID%>").value;
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
                    /*
                    function CreateGid() {
                        $.ajax({
                            type: 'POST',
                            url: 'create.aspx/CreateGroup',
                            async: false,
                            data: JSON.stringify({ gname: grpName, type: type1 }),
                            contentType: 'application/json; charset=utf-8',
                            dataType: 'json',
                            success: function (gid) {
                                CreateGroupKey(gid.d);
                            }
                        });
                    }
                    */
                    //CreateGid();
                    CreateGroupKey(1);
                }
            }
        
        else {

             document.getElementById("HiddenField1").value = "0"; 

        }
        }
        function CreateGroupKey(gid) {
            var gid = gid;
            var grpName = document.getElementById("<%=TextBox1.ClientID%>").value;
            var userList = document.getElementById("<%=TextBox2.ClientID%>").value;
            var salt1_1 = sjcl.random.randomWords(8);      //Randomly generated salt
            var salt1_2 = sjcl.codec.base64.fromBits(salt1_1);
            var salt2_1 = sjcl.random.randomWords(8);      //Randomly generated salt
            var salt2_2 = sjcl.codec.base64.fromBits(salt2_1);
            var grpKey = sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(salt1_2 + salt2_2));
            CreateIDArray(gid, grpKey);
        }
        function CreateIDArray(gid, grpKey) {
            var gid = gid;
            var grpKey = grpKey;
            var userNames = document.getElementById("<%=TextBox2.ClientID%>").value;
            var userNamesArray = userNames.split(',');
            userNamesArray[userNamesArray.length] = document.getElementById("HiddenField2").value;
            function CallGetUserKeys() {
                $.ajax({
                    type: 'POST',
                    url: 'create.aspx/GetUserKeys',
                    async: false,
                    data: JSON.stringify({ userNames1: userNamesArray }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (gid11) {
                        alert(gid11.d)
                    }
                });
            }
            CallGetUserKeys();
        }
        function UpdateGList(){}
        function UpdateKey(){}
        
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Group Name: <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            <br />
            Add Members: <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox> 
            <br />
            Type:
            <asp:DropDownList ID="DropDownList1" runat="server">
                <asp:ListItem>Open</asp:ListItem>
                <asp:ListItem Selected="True">Closed</asp:ListItem>
            </asp:DropDownList>
&nbsp;<asp:HiddenField ID="HiddenField1" runat="server" />
            <asp:HiddenField ID="HiddenField2" runat="server" />
            <br />
            <asp:Button ID="Button1" runat="server" Text="Create" OnClick="Button1_Click" OnClientClick="check()"/>
            <br />
            <asp:Label ID="Label1" runat="server" Text="Label" Visible="False"></asp:Label>
        </div>
    </form>
</body>
</html>
