using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ResultGame.Handlers
{
    /// <summary>
    /// Summary description for Logout
    /// </summary>
    public class Logout : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            try
            {
                context.Session["username"] = null;
                context.Session["password"] = null;
                context.Session["role"] = null;
                context.Response.Write("1");
            }
            catch(Exception e)
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