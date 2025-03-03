using System;
using System.Web;

public partial class Account_Login : System.Web.UI.Page
{
    private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            RegisterHyperLink.NavigateUrl = "Register.aspx?ReturnUrl=" + HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
        }
        catch (Exception ex)
        {
            Log.ErrorException("Failed to login", ex);
        }
    }
    protected void LoginUser_LoggedIn(object sender, EventArgs e)
    {
        var httpCookie = new HttpCookie("aid", null);
        
        Response.Cookies.Add(httpCookie);
    }
}
