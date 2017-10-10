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
    public partial class create : System.Web.UI.Page
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
                SqlDataAdapter ad = new SqlDataAdapter("select * from [group]", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                ds = new DataSet();
                ad.Fill(ds);
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string check = HiddenField1.Value;
            if (check == "0")
            {
                Label1.Text = "GroupName can not be blank";
                Label1.BackColor = System.Drawing.Color.Red;
                Label1.Visible = true;
            }
            else if(check == "1")
            {
                Label1.Text = "GroupName already exist";
                Label1.BackColor = System.Drawing.Color.Red;
                Label1.Visible = true;
            }
            else
            {
                Label1.Visible = false;
            }
        }
    }
}