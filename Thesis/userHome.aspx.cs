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
    public partial class userHome : System.Web.UI.Page
    {
        public DataSet ds;
        public DataSet ds1;
        public List<string> gname = new List<string>();
        public List<string> type = new List<string>();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["id"] == null)
            {
            Response.Redirect("login.aspx");
            }
            else
            {
                SqlDataAdapter ad = new SqlDataAdapter("select gid from [key] where uid = '" + Convert.ToInt32(Session["id"]) + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                ds = new DataSet();
                ad.Fill(ds);
                if (ds.Tables[0].Rows.Count != 0)
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        SqlDataAdapter ad1 = new SqlDataAdapter("select * from [group] where gid = '" + Convert.ToInt32(ds.Tables[0].Rows[i][0]) + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                        ds1 = new DataSet();
                        ad1.Fill(ds1);
                        gname.Add(ds1.Tables[0].Rows[0][1].ToString());
                        type.Add(ds1.Tables[0].Rows[0][2].ToString());
                    }
                }
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("create.aspx");
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            Response.Redirect("opengroups.aspx");
        }
    }
}