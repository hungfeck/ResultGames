using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ResultGame.Handlers
{
    /// <summary>
    /// Summary description for Login
    /// </summary>
    public class Login : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {
        
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            try
            {
                var username = context.Request.Form["username"].Trim();
                var password = context.Request.Form["password"].Trim();
                var role = context.Request.Form["role"].Trim();
                context.Session["username"] = username;
                context.Session["password"] = password;
                context.Session["role"] = role;
                context.Response.Write("1");
            }
            catch (Exception ex)
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