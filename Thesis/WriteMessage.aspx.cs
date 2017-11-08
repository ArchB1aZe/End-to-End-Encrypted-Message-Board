using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thesis
{
    public partial class WriteMessage : System.Web.UI.Page
    {
        public string gid;
        public string grpKey;
        public string uid;
        public string test;
        string gname;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["id"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                gid = Request.QueryString["gid"];
                grpKey = Session["grpKey"].ToString();
                uid = Session["id"].ToString();
                gname = Request.QueryString["gname"];
                test = Request.QueryString["test"];
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("Group.aspx?groupName="+gname+"");
        }
    }
}