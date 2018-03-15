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
    public partial class Intermediate : System.Web.UI.Page
    {
        string gname;
        DataSet ds;
        int test = 0;
        string uid;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["id"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                gname = Request.QueryString["groupName"];
                SqlDataAdapter ad = new SqlDataAdapter("select * from [group] where gname = '" + gname + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                ds = new DataSet();
                ad.Fill(ds);
                if(ds.Tables[0].Rows[0][2].ToString() == "Open")
                {
                    Response.Redirect("Group.aspx?groupName=" + gname + "");
                }
                else
                {
                    uid = Session["id"].ToString();
                    SqlDataAdapter ad2 = new SqlDataAdapter("select * from [request] where uidr ='" + uid + "' and gid = '"+ds.Tables[0].Rows[0][0].ToString()+"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                    DataSet ds2 = new DataSet();
                    ad2.Fill(ds2);
                    if(ds2.Tables[0].Rows.Count == 0)
                    {
                        Label1.Text = "Sorry, You are not allowed to access this group!!!";
                    }
                    else
                    {
                        Label1.Text = "You have already sent the subscribe request to this group!!!";
                        Button2.Text = "Unsubscribe";
                        test = 1;
                    }
                    
                    
                }
            }

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("opengroups.aspx");
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            if(test == 0)
            {
                SqlConnection conn = new SqlConnection();
                conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
                conn.Open();
                string query = "INSERT INTO [request] (gid, uidr)";
                query += " VALUES (@gid, @uidr)";
                SqlCommand myCommand = new SqlCommand(query, conn);
                myCommand.Parameters.AddWithValue("@gid", ds.Tables[0].Rows[0][0].ToString());
                myCommand.Parameters.AddWithValue("@uidr", Session["id"].ToString());
                myCommand.ExecuteNonQuery();
                conn.Close();
                Response.Redirect("opengroups.aspx");
            }
            else
            {
                SqlDataAdapter ad1 = new SqlDataAdapter("delete from [request] where uidr ='" + uid + "' and gid = '" + ds.Tables[0].Rows[0][0].ToString() + "'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                DataSet ds1 = new DataSet();
                ad1.Fill(ds1);
                Response.Redirect("opengroups.aspx");
            }
            
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            Response.Redirect("JoinRequests.aspx");
        }
    }
}