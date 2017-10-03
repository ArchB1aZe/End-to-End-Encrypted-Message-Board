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
                SqlDataAdapter ad = new SqlDataAdapter("select * from [group] where type = 'open'", "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true");
                ds = new DataSet();
                ad.Fill(ds);
            }
        }
    }
}