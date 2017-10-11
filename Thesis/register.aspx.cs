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
    public partial class register : System.Web.UI.Page
    {
   
        protected void Page_Load(object sender, EventArgs e)
        {
           
            
        }
        
        protected void Button1_Click(object sender, EventArgs e)
        {
            string check = HiddenField5.Value;      //Gets this value from javascript code
            if (check == "0")       
            {
                Label1.Text = "Username or Password can not be left blank";
                Label1.BackColor = System.Drawing.Color.Red;
                Label1.Visible = true;
            }
            else        //If the username and password fields are non empty stores the values in database
            {
                Label1.Visible = false;
                string pubKey = HiddenField1.Value;
                string encSecKey = HiddenField2.Value;
                string encPass = HiddenField3.Value;
                string salt = HiddenField4.Value;
                
                SqlConnection conn = new SqlConnection();
                conn.ConnectionString = "Data source = DESKTOP-LAR7HDI; Database = Thesis; Integrated Security = true";
                conn.Open();
                string query = "INSERT INTO [user] (username, password, salt1, pKey, sKey)";
                query += " VALUES (@username, @password, @salt1, @pKey, @sKey)";
                SqlCommand myCommand = new SqlCommand(query, conn);
                myCommand.Parameters.AddWithValue("@username", TextBox1.Text);
                myCommand.Parameters.AddWithValue("@password", encPass);
                myCommand.Parameters.AddWithValue("@salt1", salt);
                myCommand.Parameters.AddWithValue("@pKey", pubKey);
                myCommand.Parameters.AddWithValue("@sKey", encSecKey);
                myCommand.ExecuteNonQuery();
                conn.Close();
                Response.Redirect("login.aspx");
               
            }
        }
    }
}