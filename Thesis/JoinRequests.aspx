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
    public static Array GetRequests(string[] gidList)
    {
        List<string> gids = new List<string>();
        List<string> uids = new List<string>();
        Array[] holder = new Array[2];
        int tempGid = -1;
        for(int i = 0; i < gidList.Length; i++)
        {
            if(tempGid != Convert.ToInt32(gidList[i]))
            {
                SqlDataAdapter ad = new SqlDataAdapter("select * from [request] where gid = '"+ gidList[i] +"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                DataSet ds2 = new DataSet();
                ad.Fill(ds2);
                if(ds2.Tables[0].Rows.Count != 0)
                {
                    for(int j = 0; j < ds2.Tables[0].Rows.Count; j++)
                    {
                        gids.Add(ds2.Tables[0].Rows[j][0].ToString());
                        uids.Add(ds2.Tables[0].Rows[j][1].ToString());
                    }
                     tempGid = Convert.ToInt32(gidList[i]);
                }

                   
            }
        }
        holder[0] = gids.ToArray<string>();
        holder[1] = uids.ToArray<string>();
        return holder;
    }
    [WebMethod]
    public static Array GetNames(string[] gids, string[] uids)
    {
        List<string> gNames = new List<string>();
        List<string> uNames = new List<string>();
        Array[] namesHolder = new Array[2];
        for(int i = 0; i < gids.Length; i++)
        {
            SqlDataAdapter ad = new SqlDataAdapter("select username from [user] where uid = '"+ uids[i] +"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            DataSet ds = new DataSet();
            ad.Fill(ds);
            SqlDataAdapter ad1 = new SqlDataAdapter("select gname from [group] where gid = '"+ gids[i] +"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            DataSet ds1 = new DataSet();
            ad1.Fill(ds1);
            gNames.Add(ds.Tables[0].Rows[0][0].ToString());
            uNames.Add(ds1.Tables[0].Rows[0][0].ToString());
        }
        namesHolder[0] = gNames.ToArray<string>();
        namesHolder[1] = uNames.ToArray<string>();
        return namesHolder;
    }
    [WebMethod]
    public static int DeleteRequest(string uidDel, string gidDel)
    {
        
        SqlDataAdapter ad = new SqlDataAdapter("delete from [request] where gid = '" + gidDel + "' and uidr = '"+uidDel+"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds2 = new DataSet();
        ad.Fill(ds2);
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
        CheckRequest(gidList);
    }
    function CheckRequest(gidList) {
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetRequests',
            async: false,
            data: JSON.stringify({ gidList: gidList }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (holder) {
                GetData(holder.d);
            }
        });
    }
    function GetData(holder) {
        var gids = holder[0];
        var uids = holder[1];
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetNames',
            async: false,
            data: JSON.stringify({ gids: gids, uids: uids }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (newData) {
                DisplayData(newData.d, gids, uids);
            }
        });
    }
</script>
<body>
    <form id="form1" runat="server">
        <div>
            <table id="t1">
                 <script type="text/javascript">
                     function DisplayData(namesArray, gidArray, uidArray) {
                         var table = document.getElementById("t1");
                         t1.innerHTML = " ";
                         if (namesArray[0].length != 0) {
                             var row = table.insertRow(0);
                             var head1 = row.insertCell(0);
                             var head2 = row.insertCell(1);
                             head1.outerHTML = "<th>User</th>";
                             head2.outerHTML = "<th>Group</th>";
                             for (i = 0; i < namesArray[0].length; i++) {
                                 var row1 = table.insertRow(1);
                                 var row2 = table.insertRow(2);
                                 var cell1 = row1.insertCell(0);
                                 var cell2 = row1.insertCell(1);
                                 var cell3 = row1.insertCell(2);
                                 var cell4 = row1.insertCell(3);
                                 cell1.innerHTML = namesArray[0][i];
                                 cell2.innerHTML = namesArray[1][i];
                                 var id1 = "b1t" + i;
                                 var id2 = "b2t" + i;
                                 cell3.outerHTML = '<button id=' + id1 + ' type="button" onClick="Accept(\'' + uidArray[i] + '\', \'' + gidArray[i] + '\')">Approve</button>';
                                 cell4.outerHTML = '<button id=' + id2 + ' type="button" onClick="Reject(\'' + uidArray[i] + '\', \'' + gidArray[i] + '\')">Disapprove</button>';
                             }
                         }
                         else {
                             var row = table.insertRow(0);
                             var head1 = row.insertCell(0);
                             head1.outerHTML = "<th><h3 style='background-color: red'>You do not have any more pending requests.</h3></th>";
                         }
                        
                     }
                 </script>
            </table>
        </div>
    </form>
</body>
<script type="text/javascript">
    function Accept(uidAcc, gidAcc) {
        console.log(uidAcc + " " + gidAcc);
        //implement this!!!!!!
    }
    function Reject(uidDel, gidDel) {
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/DeleteRequest',
            async: false,
            data: JSON.stringify({ uidDel: uidDel, gidDel: gidDel }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (holder) {
                GetKeys();
            }
        });
    }
</script>
</html>
