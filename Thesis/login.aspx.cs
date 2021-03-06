﻿using System;
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
        public DataSet ds;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["id"] != null)
            {
                Session.Clear();
                Label1.CssClass = "alert alert-success";
                Label1.Text = "<strong>Success!</strong> You have successfully logged out";
                Label1.Visible = true;
            }
        }
        
        protected void Button1_Click(object sender, EventArgs e)
        {
          
            string check = HiddenField4.Value;
            if (check == "0")
            {
                Label1.Text = "<strong>Warning!</strong> Username or Password can not be left blank";
                Label1.CssClass = "alert alert-danger";
                Label1.Visible = true;
            }
            else if(check == "1")
            {
                Session["id"] = HiddenField5.Value;
                Session["name"] = TextBox1.Text;
                Session["pKey"] = HiddenField2.Value;
                Session["sKey"] = HiddenField3.Value;
                Label1.Visible = false;
                Response.Redirect("userHome.aspx");
            }
            else
            {
                Label1.CssClass = "alert alert-danger";
                Label1.Text = "<strong>Warning!</strong>Invalid Username or Password";
                Label1.Visible = true;
            }
        }

    }
}