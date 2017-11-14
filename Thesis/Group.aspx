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
    public static string[][] GetClosedMessages(string gid)
    {
        string[][] msgInfo = new string[3][];
        SqlDataAdapter ad = new SqlDataAdapter("select * from [message] where gid = '" + gid + "' order by mid DESC", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds1 = new DataSet();
        ad.Fill(ds1);
        msgInfo[0] = new string[ds1.Tables[0].Rows.Count];
        msgInfo[1] = new string[ds1.Tables[0].Rows.Count];
        msgInfo[2] = new string[ds1.Tables[0].Rows.Count];
        for(int i=0; i<ds1.Tables[0].Rows.Count; i++)
        {
            msgInfo[0][i] = ds1.Tables[0].Rows[i][1].ToString();
            msgInfo[1][i] = ds1.Tables[0].Rows[i][2].ToString();
            msgInfo[2][i] = ds1.Tables[0].Rows[i][4].ToString();
        }
        return msgInfo;
    }
    [WebMethod]
    public static string[][] GetOpenMessages(string gid)
    {
        string[][] msgInfo = new string[3][];
        SqlDataAdapter ad = new SqlDataAdapter("select * from [opengroup] where gid = '" + gid + "' order by mid DESC", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds1 = new DataSet();
        ad.Fill(ds1);
        msgInfo[0] = new string[ds1.Tables[0].Rows.Count];
        msgInfo[1] = new string[ds1.Tables[0].Rows.Count];
        msgInfo[2] = new string[ds1.Tables[0].Rows.Count];
        for(int i=0; i<ds1.Tables[0].Rows.Count; i++)
        {
            msgInfo[0][i] = ds1.Tables[0].Rows[i][1].ToString();
            msgInfo[1][i] = ds1.Tables[0].Rows[i][2].ToString();
            msgInfo[2][i] = ds1.Tables[0].Rows[i][4].ToString();
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
            data: JSON.stringify({ uid: uid, gid: gid}),
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
            for (i = 0; i < encMessages[0].length; i++) {
                encMessages[0][i] = sjcl.decrypt(grpKey, decodeURIComponent(encMessages[0][i]));
                encMessages[2][i] = sjcl.decrypt(grpKey, decodeURIComponent(encMessages[2][i]));
            }
            DisplayMessages(encMessages);
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
                    for (i = 0; i < messages[0].length; i++) {
                        var row1 = table.insertRow(1);
                        var row2 = table.insertRow(2);
                        var cell1 = row1.insertCell(0);
                        var cell2 = row1.insertCell(1);
                        var cell3 = row2.insertCell(0);
                        cell1.rowSpan = 2;
                        var imga = decodeURIComponent(messages[2][i]); //Extracted image from database(in bytes)
                        var srcString = "data:image / png;base64," + imga + "";
                        var htmlString = '<img src="' + srcString + '">';
                        cell1.innerHTML = messages[1][i];
                        cell2.innerHTML = messages[0][i];
                        cell3.innerHTML = htmlString;
                        
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
