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
    public partial class login : System.Web.UI.Page
    {
        public string pass;
        public string hPass;
        public string salt;
        public string pKey;
        public string sKey;
        public DataSet ds;
        protected void Page_Load(object sender, EventArgs e)
        {            
            SqlDataAdapter ad = new SqlDataAdapter("select * from [user]", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
            ds = new DataSet();
            ad.Fill(ds);
        }
        
        protected void Button1_Click(object sender, EventArgs e)
        {
            string check = HiddenField5.Value;
            if (check == "0")
            {
                Label1.Text = "Username or Password can not be left blank";
                Label1.BackColor = System.Drawing.Color.Red;
                Label1.Visible = true;
            }
            else if(check == "1")
            {
                ClientScript.RegisterStartupScript(this.GetType(), "client click", "alert('yo!')", true);
            }
            else
            {
                Label1.Text = "Invalid Username or Password";
                Label1.Visible = true;
            }
        }
    }
}