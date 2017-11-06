<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Group.aspx.cs" Inherits="Thesis.Group" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Services" %>
<script src="src/jquery-3.2.1.min.js"></script>
<script type="text/C#" runat="server">
    [WebMethod]
    public static string GetGroupKey(string uid, string gid)
    {
        SqlDataAdapter ad = new SqlDataAdapter("select enckey from [key] where gid = '" + gid + "' and uid = '" + uid +"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds1 = new DataSet();
        ad.Fill(ds1);
        return ds1.Tables[0].Rows[0][0].ToString();
    }

    [WebMethod]
    public static Dictionary<string, string> GetClosedMessages(string gid)
    {
        Dictionary<string,  string> msgInfo = new Dictionary<string, string>();
        SqlDataAdapter ad = new SqlDataAdapter("select * from [message] where gid = '" + gid + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds1 = new DataSet();
        ad.Fill(ds1);
        for(int i=0; i<ds1.Tables[0].Rows.Count; i++)
        {
            msgInfo[ds1.Tables[0].Rows[i][1].ToString()] = ds1.Tables[0].Rows[i][2].ToString();
        }
        return msgInfo;
    }
    [WebMethod]
    public static Dictionary<string, string> GetOpenMessages(string gid)
    {
        Dictionary<string,  string> msgInfo = new Dictionary<string, string>();
        SqlDataAdapter ad = new SqlDataAdapter("select * from [opengroup] where gid = '" + gid + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds1 = new DataSet();
        ad.Fill(ds1);
        for(int i=0; i<ds1.Tables[0].Rows.Count; i++)
        {
            msgInfo[ds1.Tables[0].Rows[i][1].ToString()] = ds1.Tables[0].Rows[i][2].ToString();
        }
        return msgInfo;
    }
</script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
    <script src="src/sjcl.js"></script>
<script type="text/javascript">
    function check() {
        var test = "<%=this.test%>";
        var gid = "<%=this.gid%>";
        if (test == "0")
        {
            InvokeOpenGroup(gid);
        }
        else {
            InvokeClosedGroup(gid);
        }
    }
    function InvokeOpenGroup(gid) {
        grpKey = "0";
        GetMessages(gid, grpKey);
    }
    function InvokeClosedGroup(gid) {
        var uid = "<%=this.uid%>";
        $.ajax({
            type: 'POST',
            url: 'Group.aspx/GetGroupKey',
            async: false,
            data: JSON.stringify({ uid: uid, gid: gid }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (enckey) {
                DecryptGroupKey(gid, enckey.d)
            }
        });
    }
    function DecryptGroupKey(gid, encGrpKey) {
        var sKey_1 = "<%=this.sKey%>";
        var sKey_2 = new sjcl.ecc.elGamal.secretKey(
            sjcl.ecc.curves.c256,
            sjcl.ecc.curves.c256.field.fromBits(sjcl.codec.base64.toBits(sKey_1))
        )
        var grpKey = sjcl.decrypt(sKey_2, decodeURIComponent(encGrpKey));
        document.getElementById("HiddenField1").value = grpKey;
        GetMessages(gid, grpKey);
    }
    function GetMessages(gid, grpKey) {
        if (grpKey == "0") {
            $.ajax({
                type: 'POST',
                url: 'Group.aspx/GetOpenMessages',
                async: false,
                data: JSON.stringify({ gid: gid }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (ds) {
                    DisplayMessages(ds.d)
                }
            });
        } else {
            $.ajax({
                type: 'POST',
                url: 'Group.aspx/GetClosedMessages',
                async: false,
                data: JSON.stringify({ gid: gid }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (ds) {
                    DecryptMessages(ds.d, grpKey);
                }
            });
        }
        
        function DecryptMessages(encMessages, grpKey) {
            var messages = {};
            for (i = 0; i < Object.keys(encMessages).length; i++) {
                var decryptedMessage = sjcl.decrypt(grpKey, decodeURIComponent(Object.keys(encMessages)[i]));
                messages[decryptedMessage] = encMessages[Object.keys(encMessages)[i]];
            }
            DisplayMessages(messages);
        }
    }
</script>
<body>
    <form id="form1" runat="server">
        <table id="t1">
            <script type="text/javascript">
                function DisplayMessages(messages) {
                    var table = document.getElementById("t1");
                    var row = table.insertRow(0);
                    var head1 = row.insertCell(0);
                    var head2 = row.insertCell(1);
                    head1.outerHTML = "<th>Author</th>";
                    head2.outerHTML = "<th>Message</th>";
                    for (i = 0; i < Object.keys(messages).length; i++) {
                        var row = table.insertRow(i+1);
                        var cell1 = row.insertCell(0);
                        var cell2 = row.insertCell(1);
                        cell1.innerHTML = messages[Object.keys(messages)[i]];
                        cell2.innerHTML = Object.keys(messages)[i];
                    }
                }
            </script>
            <tr>
                <td colspan="2">
                    <asp:Button ID="Button1" runat="server" Text="Write" OnClick="Button1_Click" /></td>
            </tr>
        </table>
        <asp:HiddenField ID="HiddenField1" runat="server" />
    </form>
</body>
</html>
