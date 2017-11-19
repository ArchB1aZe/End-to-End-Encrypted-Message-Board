using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thesis
{
    public partial class JoinRequests : System.Web.UI.Page
    {
        public string uid;
        public string sKey;
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
                ClientScript.RegisterStartupScript(this.GetType(), "client click", "GetKeys()", true);
            }
        }
    }
}