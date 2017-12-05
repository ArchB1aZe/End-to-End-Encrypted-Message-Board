using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace Thesis
{
    public partial class Group : System.Web.UI.Page
    {
        DataSet ds;
        public string gid;
        public string gname;
        public string uid;
        public int test=0;
        public string sKey;
        public string img;
        public string tmpGrpKey;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["id"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                
                sKey = Session["sKey"].ToString();
                uid = Session["id"].ToString();
                string groupName = gname = Request.QueryString["groupName"];
                SqlDataAdapter ad = new SqlDataAdapter("select * from [group] where gname = '"+groupName+"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                ds = new DataSet();
                ad.Fill(ds);
                gid = ds.Tables[0].Rows[0][0].ToString();
                if (ds.Tables[0].Rows[0][2].ToString().Equals("Closed"))
                {
                    test = 1;
                }
                ClientScript.RegisterStartupScript(this.GetType(), "client click", "check()", true);
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Session["grpKey"] = HiddenField1.Value;
            Response.Redirect("WriteMessage.aspx?gid="+gid+"&gname="+gname+"&test="+test+"");
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            Response.Redirect("userHome.aspx");
        }
    }
}