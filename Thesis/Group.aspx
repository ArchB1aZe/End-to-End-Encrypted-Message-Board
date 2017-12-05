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
        for(int i=0; i<msgInfo[0].Length; i++)
        {
            SqlDataAdapter ad1 = new SqlDataAdapter("select username from [user] where uid = '" + msgInfo[1][i] + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            DataSet ds2 = new DataSet();
            ad1.Fill(ds2);
            msgInfo[1][i] = ds2.Tables[0].Rows[0][0].ToString();
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
        for(int i=0; i<msgInfo[0].Length; i++)
        {
            SqlDataAdapter ad1 = new SqlDataAdapter("select username from [user] where uid = '" + msgInfo[1][i] + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            DataSet ds2 = new DataSet();
            ad1.Fill(ds2);
            msgInfo[1][i] = ds2.Tables[0].Rows[0][0].ToString();
        }
        return msgInfo;

    }
</script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8"/>
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
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
                        var htmlString = '<img src="' + srcString + '"width="400" height="400">';
                        cell1.innerHTML = messages[1][i];
                        cell2.innerHTML = messages[0][i];
                        if (imga != "random string") {
                            cell3.innerHTML = htmlString;
                        }
                        
                        
                    }
                }
            </script>
            <tr>
                <td>
                    <asp:Button ID="Button1" runat="server" Text="Write" OnClick="Button1_Click" /></td>
                <td>
                    <asp:Button ID="Button2" runat="server" Text="LeaveGroup" OnClientClick="RemoveUser()" OnClick="Button2_Click" /></td>
                
            </tr>
        </table>
        <asp:HiddenField ID="HiddenField1" runat="server" />
    </form>
</body>
<script type="text/javascript">
    function RemoveUser() {
        var oldGroupKey = document.getElementById("HiddenField1").value;
        var salt1_1 = sjcl.random.randomWords(8);      //Randomly generated salt
        var salt1_2 = sjcl.codec.base64.fromBits(salt1_1);
        var salt2_1 = sjcl.random.randomWords(8);      //Randomly generated salt
        var salt2_2 = sjcl.codec.base64.fromBits(salt2_1);
        var newGroupKey = sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(salt1_2 + salt2_2));
        var gidAcc = "<%=this.gid%>";
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetGlist',
            async: false,
            data: JSON.stringify({ gidAcc: gidAcc }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (dictGlist) {
                EncryptGlist(dictGlist.d, oldGroupKey, newGroupKey, gidAcc);
            }
        });
    }
    function EncryptGlist(dictGlist, oldGroupKey, newGroupKey, gidAcc) {
        var idArray_1 = [];
        var idArray_2 = [];
        var typeArray = [];
        var uid = "<%=this.uid%>";
        var tmp = 0;
        for (i = 0; i < Object.keys(dictGlist).length; i++) {
            if (sjcl.decrypt(oldGroupKey, decodeURIComponent(Object.keys(dictGlist)[i])) != uid) {
                idArray_1[tmp] = sjcl.decrypt(oldGroupKey, decodeURIComponent(Object.keys(dictGlist)[i]));
                typeArray[tmp] = dictGlist[Object.keys(dictGlist)[i]];
                tmp++;
            }           
        }
        for (i = 0; i < idArray_1.length; i++) {
            idArray_2[i] = encodeURIComponent(sjcl.encrypt(newGroupKey, idArray_1[i]));
        }
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/UpdateGlist',
            async: false,
            data: JSON.stringify({ idArray: idArray_2, typeArray: typeArray, gidAcc: gidAcc }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (abc) {
                GetPublicKey(oldGroupKey, newGroupKey, idArray_1, gidAcc, uid);
            }
        });
    }
    function GetPublicKey(oldGroupKey, newGroupKey, idArray, gidAcc, uid) {
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetPublicKeyArray',
            async: false,
            data: JSON.stringify({ idArray: idArray }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (pKeys) {
                UpdateKey(pKeys.d, oldGroupKey, newGroupKey, gidAcc, uid)
            }
        });
    }
    function UpdateKey(pKeysDict, oldGroupKey, newGroupKey, gidAcc, uid) {
        var groupKeyArray = [];
        var uidArray = [];
        for (i = 0; i < Object.keys(pKeysDict).length; i++) {
            var pKey_1 = new sjcl.ecc.elGamal.publicKey(
                sjcl.ecc.curves.c256,
                sjcl.codec.base64.toBits(pKeysDict[Object.keys(pKeysDict)[i]])
            )
            groupKeyArray[i] = encodeURIComponent(sjcl.encrypt(pKey_1, newGroupKey));
            uidArray[i] = Object.keys(pKeysDict)[i];
        }
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/EnterPublicKeys',
            async: false,
            data: JSON.stringify({ groupKeyArray: groupKeyArray, gidAcc: gidAcc, uidArray: uidArray }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (xyz) {
                GetGroupMessages(gidAcc, oldGroupKey, newGroupKey, uid);
            }
        });
    }
    function GetGroupMessages(gidAcc, oldGroupKey, newGroupKey, uid) {
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetMessages',
            async: false,
            data: JSON.stringify({ gidAcc: gidAcc }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (messages) {
                ReEncryptMessages(messages.d, oldGroupKey, newGroupKey, uid, gidAcc);
            }
        });
    }
    function ReEncryptMessages(messagesArray, oldGroupKey, newGroupKey, uid, gidAcc) {
        for (i = 0; i < messagesArray[0].length; i++) {
            messagesArray[1][i] = sjcl.decrypt(oldGroupKey, decodeURIComponent(messagesArray[1][i]));
            messagesArray[2][i] = sjcl.decrypt(oldGroupKey, decodeURIComponent(messagesArray[2][i]));

        }
        for (j = 0; j < messagesArray[0].length; j++) {
            messagesArray[1][j] = encodeURIComponent(sjcl.encrypt(newGroupKey, messagesArray[1][j]));
            messagesArray[2][j] = encodeURIComponent(sjcl.encrypt(newGroupKey, messagesArray[2][j]));

        }
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/UpdateMessages',
            async: false,
            data: JSON.stringify({ mid: messagesArray[0], encMessage: messagesArray[1], encImage: messagesArray[2] }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function () {
                window.location.href = "userHome.aspx";
            }
        });
    }
</script>
</html>
