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
    public static Dictionary<string, string> GetUserKeys(string[] userNames1)
    {
        Dictionary<string, string> uKeys = new Dictionary<string, string>();
        for(int i=0; i<userNames1.Length; i++)
        {
            SqlDataAdapter ad = new SqlDataAdapter("select uid, pKey from [user] where username = '" + userNames1[i] + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            DataSet ds2 = new DataSet();
            ad.Fill(ds2);
            uKeys.Add(ds2.Tables[0].Rows[0][0].ToString(), ds2.Tables[0].Rows[0][1].ToString());
        }
        return uKeys;
    }
    [WebMethod]
    public static int EnterGlist(string[] userID, string gid1, string[] type)
    {
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
        conn.Open();
        string query = "INSERT INTO [glist] (gid, uid, type)";
        query += " VALUES (@gid, @uid, @type)";
        for(int i=0; i<userID.Length; i++) {
            SqlCommand myCommand = new SqlCommand(query, conn);
            myCommand.Parameters.AddWithValue("@gid", gid1);
            myCommand.Parameters.AddWithValue("@uid", userID[i]);
            myCommand.Parameters.AddWithValue("@type", type[i]);
            myCommand.ExecuteNonQuery();
        }
        conn.Close();
        return 1;
    }
    [WebMethod]
    public static int EnterKey(string gid, Dictionary<string, string> encGrpKey)
    {
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
        conn.Open();
        string query = "INSERT INTO [key] (gid, enckey, uid)";
        query += " VALUES (@gid, @enckey, @uid)";
        string[] keys = encGrpKey.Keys.ToArray();
        for(int i=0; i<keys.Length; i++)
        {
            SqlCommand myCommand = new SqlCommand(query, conn);
            myCommand.Parameters.AddWithValue("@gid", gid);
            myCommand.Parameters.AddWithValue("@enckey", encGrpKey[keys[i]]);
            myCommand.Parameters.AddWithValue("@uid", keys[i]);
            myCommand.ExecuteNonQuery();
        }
        conn.Close();
        return 1;
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
                    
                    CreateGid();
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
            if (userNames === "") {
                var userNamesArray = [document.getElementById("HiddenField2").value];
            }
            else {
                var userNamesArray = userNames.split(',');
                userNamesArray[userNamesArray.length] = document.getElementById("HiddenField2").value;
            }
            
            function CallGetUserKeys() {
                $.ajax({
                    type: 'POST',
                    url: 'create.aspx/GetUserKeys',
                    async: false,
                    data: JSON.stringify({ userNames1: userNamesArray }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (gid11) {
                        UpdateGList(gid11.d, gid, grpKey);
                    }
                });
            }
            CallGetUserKeys();
        }
        function UpdateGList(dic, gid, grpKey) {
            var gid = gid;
            var grpKey = grpKey;
            var id = "<%=this.id%>";
            var encUid = [];
            var type = [];
            for (i = 0; i < Object.keys(dic).length; i++) {
                encUid[i] = (encodeURIComponent(sjcl.encrypt(grpKey, Object.keys(dic)[i])));
                if (id == Object.keys(dic)[i]) {
                    type[i] = "admin";
                }
                else {
                    type[i] = "normal";
                }
            }
            $.ajax({
                type: 'POST',
                url: 'create.aspx/EnterGlist',
                async: false,
                data: JSON.stringify({ userID: encUid, gid1: gid, type: type }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function () {
                    UpdateKey(dic,gid,grpKey);
                }
            });
        }
        function UpdateKey(dic, gid, grpKey) {
            var gid = gid;
            var grpKey = grpKey;
            var encGrpKey = {};
            for (i = 0; i < Object.keys(dic).length; i++){
                var pKey_1 = new sjcl.ecc.elGamal.publicKey(
                    sjcl.ecc.curves.c256,
                    sjcl.codec.base64.toBits(dic[Object.keys(dic)[i]])
                )
                encGrpKey[Object.keys(dic)[i]] = encodeURIComponent(sjcl.encrypt(pKey_1, grpKey));
            }
            $.ajax({
                type: 'POST',
                url: 'create.aspx/EnterKey',
                async: false,
                data: JSON.stringify({ gid: gid, encGrpKey: encGrpKey }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function () {
                    console.log("Entered the keys successfully");
                }
            });
        }
        
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
