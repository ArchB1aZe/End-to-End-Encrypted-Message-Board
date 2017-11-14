<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WriteMessage.aspx.cs" Inherits="Thesis.WriteMessage" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Services" %>
<script src="src/jquery-3.2.1.min.js"></script>
<script type="text/C#" runat="server">
    [WebMethod]
    public static int EnterDatabase(string gid, string encm, string uid, string img)
    {
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
        conn.Open();
        string query = "INSERT INTO [message] (encm, uid, gid, img)";
        query += " VALUES (@encm, @uid, @gid, @img)";
        SqlCommand myCommand = new SqlCommand(query, conn);
        myCommand.Parameters.AddWithValue("@encm", encm);
        myCommand.Parameters.AddWithValue("@uid", uid);
        myCommand.Parameters.AddWithValue("@gid", gid);
        myCommand.Parameters.AddWithValue("@img", img);
        myCommand.ExecuteNonQuery();
        conn.Close();
        return 1;
    }
     [WebMethod]
    public static int EnterDatabaseOpen(string gid, string msg, string uid, string img)
    {
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
        conn.Open();
        string query = "INSERT INTO [opengroup] (msg, uid, gid, img)";
        query += " VALUES (@msg, @uid, @gid, @img)";
        SqlCommand myCommand = new SqlCommand(query, conn);
        myCommand.Parameters.AddWithValue("@msg", msg);
        myCommand.Parameters.AddWithValue("@uid", uid);
        myCommand.Parameters.AddWithValue("@gid", gid);
        myCommand.Parameters.AddWithValue("@img", img);
        myCommand.ExecuteNonQuery();
        conn.Close();
        return 1;
    }
</script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
    <script src="src/sjcl.js"></script>
    <script type="text/javascript">
        function Check() {
            var msg = document.getElementById("<%=TextBox1.ClientID%>").value;
            var test = "<%=this.test%>";
            var img = "<%=this.img%>";
            if (msg.replace(/\s/g, "").length == 0) {
                alert("Message Can Not Be Empty");
            }
            else {
                if (test == "1")
                {
                    EncryptMessage(msg, img);
                }
                else {
                    OpenMessage(msg, img);
                }
                
            }
        }
        function EncryptMessage(msg, img){
            var grpKey = "<%=this.grpKey%>";
            var uid = "<%=this.uid%>";
            var encMessage = encodeURIComponent(sjcl.encrypt(grpKey, msg));
            var encImg = encodeURIComponent(sjcl.encrypt(grpKey, img));
            var gid = "<%=this.gid%>";
            var gname = "<%=this.gname%>";
            $.ajax({
                type: 'POST',
                url: 'WriteMessage.aspx/EnterDatabase',
                async: false,
                data: JSON.stringify({ gid: gid, encm: encMessage, uid: uid, img: encImg }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function () {
                    window.location.href = "Group.aspx?groupName=" + gname +"";
                }
            });
        }

        function OpenMessage(msg, img) {
            var uid = "<%=this.uid%>";
            var gid = "<%=this.gid%>";
            var gname = "<%=this.gname%>";
            var encImg = encodeURIComponent(img);
            $.ajax({
                type: 'POST',
                url: 'WriteMessage.aspx/EnterDatabaseOpen',
                async: false,
                data: JSON.stringify({ gid: gid, msg: msg, uid: uid, img: encImg }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function () {
                    window.location.href = "Group.aspx?groupName="+ gname +"";
                }
            });
        }
        
    </script>
<body>
    <form id="form1" runat="server">
        <div>

            <asp:TextBox ID="TextBox1" runat="server" Height="291px" TextMode="MultiLine" Width="601px"></asp:TextBox>
            <br />
            
            Upload Image(Max 2MB) :
            
            <asp:FileUpload ID="FileUpload1" runat="server" />
            <asp:HiddenField ID="HiddenField1" runat="server" />
            
            <br />
            <asp:Button ID="Button1" runat="server" Text="Submit" OnClick="Button1_Click" />
            <br />

        </div>
    </form>
</body>
</html>
