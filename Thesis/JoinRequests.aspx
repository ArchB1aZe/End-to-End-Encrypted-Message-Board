<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JoinRequests.aspx.cs" Inherits="Thesis.JoinRequests" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Services" %>
<script src="src/jquery-3.2.1.min.js"></script>
<script type="text/C#" runat="server">
    [WebMethod]
    public static Dictionary<string, string> GetUserKeys(string uid)
    {
        Dictionary<string, string> uKeys = new Dictionary<string, string>();
        SqlDataAdapter ad = new SqlDataAdapter("select gid, enckey from [key] where uid = '" + uid + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds2 = new DataSet();
        ad.Fill(ds2);
        for(int i=0; i<ds2.Tables[0].Rows.Count; i++)
        {
            uKeys.Add(ds2.Tables[0].Rows[i][0].ToString(), ds2.Tables[0].Rows[i][1].ToString());
        }

        return uKeys;
    }

    [WebMethod]
    public static Dictionary<string, string> GetUserIds(string[] gids)
    {
        Dictionary<string, string> uIds = new Dictionary<string, string>();
        for(int i = 0; i < gids.Length; i++)
        {
            SqlDataAdapter ad = new SqlDataAdapter("select * from [glist] where gid = '" + gids[i] + "' and type = 'admin'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            DataSet ds2 = new DataSet();
            ad.Fill(ds2);
            uIds.Add(ds2.Tables[0].Rows[0][1].ToString(), ds2.Tables[0].Rows[0][0].ToString());
        }
        return uIds;
    }
    [WebMethod]
    public static Dictionary<string, string> GetRequests(string[] gids)
    {
        Dictionary<string, string> requests = new Dictionary<string, string>();
        SqlDataAdapter ad = new SqlDataAdapter("select * from [request]", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds2 = new DataSet();
        ad.Fill(ds2);
        return requests;
    }
</script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<script src="src/sjcl.js"></script>
<script type="text/javascript">
    function GetKeys() {
        var uid = "<%=this.uid%>";
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetUserKeys',
            async: false,
            data: JSON.stringify({ uid: uid }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (dict) {
                GetUid(dict.d);
            }
        });
    }
    function GetUid(keysDict) {
        var keysDict = keysDict;
        var gids = [];
        for (i = 0; i < Object.keys(keysDict).length; i++) {
            gids[i] = Object.keys(keysDict)[i];
        }
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetUserIds',
            async: false,
            data: JSON.stringify({ gids: gids }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (dictUid) {
                DecryptUids(dictUid.d, keysDict);
            }
        });
        
    }
    function DecryptUids(uidsDict, keysDict) {
        var sKey_1 = "<%=this.sKey%>";
        var sKey_2 = new sjcl.ecc.elGamal.secretKey(
            sjcl.ecc.curves.c256,
            sjcl.ecc.curves.c256.field.fromBits(sjcl.codec.base64.toBits(sKey_1))
        )
        var uid = "<%=this.uid%>";
        var gidList = [];
        temp = 0;
        for (i = 0; i < Object.keys(uidsDict).length; i++) {
            for (j = 0; j < Object.keys(keysDict).length; j++) {
                if (uidsDict[Object.keys(uidsDict)[i]] == Object.keys(keysDict)[j]) {
                    var grpKey = sjcl.decrypt(sKey_2, decodeURIComponent(keysDict[Object.keys(keysDict)[j]]));
                    id = sjcl.decrypt(grpKey, decodeURIComponent(Object.keys(uidsDict)[i]));
                    if (id == uid) {
                        gidList[temp] = Object.keys(keysDict)[j];
                        temp++;
                    }
                }
            }
        }
        console.log(gidList);
        //CheckRequest(id); Check for the request and match them with the gids in gidList and then display them in Cells with approve or reject buttons!
    }
    function CheckRequest(id) {
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetRequests',
            async: false,
            data: JSON.stringify({ uids: id }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (uid) {
                console.log(uid.d);
            }
        });
    }
</script>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
