using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
        public string gname;
        public string img;

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
            if (FileUpload1.HasFile)
            {
                System.IO.Stream fs = FileUpload1.PostedFile.InputStream;
                System.IO.BinaryReader br = new System.IO.BinaryReader(fs);
                byte[] bytes = br.ReadBytes((Int32)fs.Length);
                img = Convert.ToBase64String(bytes, 0, bytes.Length);
            }
            else
            {
                img = "random string";
            }
            ClientScript.RegisterStartupScript(this.GetType(), "client click", "Check()", true);
        }
    }
}