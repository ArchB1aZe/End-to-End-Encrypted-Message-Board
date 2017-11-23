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
            uKeys.Add(ds2.Tables[0].Rows[i][1].ToString(), ds2.Tables[0].Rows[i][0].ToString());
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
    [WebMethod]
    public static Dictionary<string, string> GetGlist(string gidAcc)
    {
        Dictionary<string, string> gList = new Dictionary<string, string>();
        SqlDataAdapter ad = new SqlDataAdapter("select * from [glist] where gid = '" + gidAcc +"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds2 = new DataSet();
        ad.Fill(ds2);
        for(int i=0; i<ds2.Tables[0].Rows.Count; i++)
        {
            gList.Add(ds2.Tables[0].Rows[i][1].ToString(), ds2.Tables[0].Rows[i][2].ToString());
        }
        SqlDataAdapter ad1 = new SqlDataAdapter("delete from [glist] where gid = '" + gidAcc +"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds1 = new DataSet();
        ad1.Fill(ds1);
        return gList;
    }
    [WebMethod]
    public static int UpdateGlist(string[] idArray, string[] typeArray, string gidAcc)
    {

        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
        conn.Open();
        for(int i=0; i<idArray.Length; i++)
        {
            string query = "INSERT INTO [glist] (gid, uid, type)";
            query += " VALUES (@gid, @uid, @type)";
            SqlCommand myCommand = new SqlCommand(query, conn);
            myCommand.Parameters.AddWithValue("@gid", gidAcc);
            myCommand.Parameters.AddWithValue("@uid", idArray[i]);
            myCommand.Parameters.AddWithValue("@type", typeArray[i]);
            myCommand.ExecuteNonQuery();
        }
        conn.Close();

        return 1;
    }
    [WebMethod]
    public static Dictionary<string, string> GetPublicKeyArray(string[] idArray)
    {
        Dictionary<string, string> pKeyDict = new Dictionary<string, string>();
        for(int i=0; i<idArray.Length; i++)
        {
            SqlDataAdapter ad = new SqlDataAdapter("select uid, pKey from [user] where uid = '" + idArray[i] + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            DataSet ds2 = new DataSet();
            ad.Fill(ds2);
            pKeyDict.Add(ds2.Tables[0].Rows[0][0].ToString(), ds2.Tables[0].Rows[0][1].ToString());
        }

        return pKeyDict;
    }
    [WebMethod]
    public static int EnterPublicKeys(string[] groupKeyArray, string gidAcc, string[] uidArray)
    {
        SqlDataAdapter ad = new SqlDataAdapter("delete from [key] where gid = '" + gidAcc + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds2 = new DataSet();
        ad.Fill(ds2);
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
        conn.Open();
        for(int i=0; i<groupKeyArray.Length; i++)
        {
            string query = "INSERT INTO [key] (gid, enckey, uid)";
            query += " VALUES (@gid, @enckey, @uid)";
            SqlCommand myCommand = new SqlCommand(query, conn);
            myCommand.Parameters.AddWithValue("@gid", gidAcc);
            myCommand.Parameters.AddWithValue("@enckey", groupKeyArray[i]);
            myCommand.Parameters.AddWithValue("@uid", uidArray[i]);
            myCommand.ExecuteNonQuery();
        }
        conn.Close();

        return 1;
    }
    [WebMethod]
    public static Dictionary<string, string> GetMessages(string gidAcc)
    {
        List<string> mid = new List<string>();
        List<string> encryptedMessages = new List<string>();
        List<string> img = new List<string>();
        //Here define the array which holds all above lists and then pass this array down there for the messagessss
        SqlDataAdapter ad = new SqlDataAdapter("select mid, encm, img from [message] where gid = '" + gidAcc + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
        DataSet ds2 = new DataSet();
        ad.Fill(ds2);
        for(int i=0; i < ds2.Tables[0].Rows.Count; i++)
        {
            mid.Add(ds2.Tables[0].Rows[i][0].ToString());
            encryptedMessages.Add(ds2.Tables[0].Rows[i][1].ToString());
            img.Add(ds2.Tables[0].Rows[i][2].ToString());
        }
        return pKeyDict;
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
            gids[i] = keysDict[Object.keys(keysDict)[i]];
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
                if (uidsDict[Object.keys(uidsDict)[i]] == keysDict[Object.keys(keysDict)[j]]) {
                    var grpKey = sjcl.decrypt(sKey_2, decodeURIComponent(Object.keys(keysDict)[j]));
                    id = sjcl.decrypt(grpKey, decodeURIComponent(Object.keys(uidsDict)[i]));
                    if (id == uid) {
                        gidList[temp] = keysDict[Object.keys(keysDict)[j]];
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
        var uid = "<%=this.uid%>";
        //Get the group key
        $.ajax({
            type: 'POST',
            url: 'Group.aspx/GetGroupKey',
            async: false,
            data: JSON.stringify({ uid: uid, gid: gidAcc }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (key) {
                DecryptTheGroupKey(decodeURIComponent(key.d), gidAcc, uidAcc);
            }
        });
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
    function DecryptTheGroupKey(key, gidAcc, uidAcc) {
        var sKey_1 = "<%=this.sKey%>";
        var sKey_2 = new sjcl.ecc.elGamal.secretKey(
            sjcl.ecc.curves.c256,
            sjcl.ecc.curves.c256.field.fromBits(sjcl.codec.base64.toBits(sKey_1))
        )
        var oldGroupKey = sjcl.decrypt(sKey_2, key);
        var salt1_1 = sjcl.random.randomWords(8);      //Randomly generated salt
        var salt1_2 = sjcl.codec.base64.fromBits(salt1_1);
        var salt2_1 = sjcl.random.randomWords(8);      //Randomly generated salt
        var salt2_2 = sjcl.codec.base64.fromBits(salt2_1);
        var newGroupKey = sjcl.codec.base64.fromBits(sjcl.hash.sha256.hash(salt1_2 + salt2_2));
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetGlist',
            async: false,
            data: JSON.stringify({ gidAcc: gidAcc }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (dictGlist) {
                EncryptGlist(dictGlist.d, oldGroupKey, newGroupKey, uidAcc, gidAcc)
            }
        });
    }
    function EncryptGlist(dictGlist, oldGroupKey, newGroupKey, uidAcc, gidAcc) {
        var idArray_1 = [];
        var idArray_2 = [];
        var typeArray = [];
        for (i = 0; i < Object.keys(dictGlist).length; i++){
            idArray_1[i] = sjcl.decrypt(oldGroupKey, decodeURIComponent(Object.keys(dictGlist)[i]));
            typeArray[i] = dictGlist[Object.keys(dictGlist)[i]];
        }
        idArray_1[idArray_1.length] = uidAcc;
        typeArray[typeArray.length] = "normal";
        for (i= 0; i < idArray_1.length; i++){
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
                GetPublicKey(oldGroupKey, newGroupKey, idArray_1, gidAcc)
            }
        });
    }
    function GetPublicKey(oldGroupKey, newGroupKey, idArray, gidAcc) {
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetPublicKeyArray',
            async: false,
            data: JSON.stringify({ idArray: idArray }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (pKeys) {
                UpdateKey(pKeys.d, oldGroupKey, newGroupKey, gidAcc)
            }
        });
    }
    function UpdateKey(pKeysDict, oldGroupKey, newGroupKey, gidAcc) {
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
                GetGroupMessages(gidAcc, oldGroupKey, newGroupKey);
            }
        });
    }
    function GetGroupMessages(gidAcc, oldGroupKey, newGroupKey) {
        $.ajax({
            type: 'POST',
            url: 'JoinRequests.aspx/GetMessages',
            async: false,
            data: JSON.stringify({ gidAcc: gidAcc }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (messages) {
                console.log(mesages.d);
            }
        });
    }
</script>
</html>
