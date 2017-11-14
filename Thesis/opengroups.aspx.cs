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
    public partial class opengroups : System.Web.UI.Page
    {
        public DataSet ds;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["id"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                string uid = Session["id"].ToString();
                SqlDataAdapter ad = new SqlDataAdapter("select * from [group]" , "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                ds = new DataSet();
                ad.Fill(ds);
                SqlDataAdapter ad1 = new SqlDataAdapter("select gid from [key] where uid = '"+uid+"'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                DataSet ds1 = new DataSet();
                ad1.Fill(ds1);
                int temp = 0;
                for (int i = 0; i <= ds.Tables[0].Rows.Count; i++)
                {
                    
                    for(int j = 0; j < ds1.Tables[0].Rows.Count; j++)
                    {
                        if(ds1.Tables[0].Rows[j][0].ToString() == ds.Tables[0].Rows[temp][0].ToString())
                        {              
                            ds.Tables[0].Rows.RemoveAt(temp);
                            temp = temp - 1;
                        }
                    }
                    temp++;
                }
                ds.AcceptChanges();
            }
        }
    }
}