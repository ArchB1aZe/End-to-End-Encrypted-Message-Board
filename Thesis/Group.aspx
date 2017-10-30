<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Group.aspx.cs" Inherits="Thesis.Group" %>

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
        alert(test);
        if (test == "0")
        {
            //InvokeOpenGroup(gid, gname);
        }
        else {
            InvokeClosedGroup(gid);
        }
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
            success: function () {
                //UpdateKey(dic, gid, grpKey);
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
