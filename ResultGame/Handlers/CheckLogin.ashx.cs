using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using ResultGame.Model;

namespace ResultGame.Handlers
{
    /// <summary>
    /// Summary description for CheckLogin1
    /// </summary>
    public class CheckLogin1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            try
            {
                var username = context.Session["username"].ToString();
                var password = context.Session["password"].ToString();
                var role = context.Session["role"].ToString();
                if (String.IsNullOrEmpty(username))
                {
                    context.Response.Redirect("/login.aspx");
                    return;
                }
                var user = new users();
                user.username = username;
                user.password = password;
                user.role = role;
                string result = Newtonsoft.Json.JsonConvert.SerializeObject(user);
                context.Response.Write(result);
            }
            catch (Exception e)
            {
                context.Response.Write(null);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}