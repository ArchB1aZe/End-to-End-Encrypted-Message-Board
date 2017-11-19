using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Collections;

namespace Thesis
{
    public partial class userHome : System.Web.UI.Page
    {
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
                DataSet ds = new DataSet();
                ad.Fill(ds);
                SqlDataAdapter ad1 = new SqlDataAdapter("select gid from [opengroup] where uid = '" + Convert.ToInt32(Session["id"]) + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                DataSet ds1 = new DataSet();
                ad1.Fill(ds1);
                Hashtable hTable = new Hashtable();
                ArrayList duplicateList = new ArrayList();

                //Add list of all the unique item value to hashtable, which stores combination of key, value pair.
                //And add duplicate item value in arraylist.
                foreach (DataRow drow in ds1.Tables[0].Rows)
                {
                    if (hTable.Contains(drow[0]))
                        duplicateList.Add(drow);
                    else
                        hTable.Add(drow[0], string.Empty);
                }

                //Removing a list of duplicate items from datatable.
                foreach (DataRow dRow in duplicateList)
                    ds1.Tables[0].Rows.Remove(dRow);

                //Datatable which contains unique records will be return as output.
                ds.Merge(ds1);
                if (ds.Tables[0].Rows.Count != 0)
                {
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        SqlDataAdapter ad2 = new SqlDataAdapter("select * from [group] where gid = '" + Convert.ToInt32(ds.Tables[0].Rows[i][0]) + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                        DataSet ds2 = new DataSet();
                        ad2.Fill(ds2);
                        gname.Add(ds2.Tables[0].Rows[0][1].ToString());
                        type.Add(ds2.Tables[0].Rows[0][2].ToString());
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

        protected void Button3_Click(object sender, EventArgs e)
        {
            Response.Redirect("JoinRequests.aspx");
        }
    }
}