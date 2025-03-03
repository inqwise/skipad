using System;
using System.Web;

public class Global : System.Web.HttpApplication
{

    private static readonly NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();

    protected void Application_Start(object sender, EventArgs e)
    {
        Log.Info("SkipAd FrontOffice - Started");
    }

    protected void Session_Start(object sender, EventArgs e)
    {
    }

    protected void Application_BeginRequest(object sender, EventArgs e)
    {
    }

    protected void Application_AuthenticateRequest(object sender, EventArgs e)
    {
    }

    protected void Application_Error(object sender, EventArgs e)
    {
        HttpContext ctx = HttpContext.Current;
        Exception exception = ctx.Server.GetLastError();
        while (null != exception.InnerException && exception is HttpUnhandledException)
        {
            exception = exception.InnerException;
        }

        if (exception is HttpException)
        {
            // Page not Found
        }
        else
        {
            string errorInfo = "An unhandled error occured at " + ctx.Request.Url + " (Referrer: " + ctx.Request.UrlReferrer + ")";
            Log.FatalException(errorInfo, exception);
        }
    }

    protected void Session_End(object sender, EventArgs e)
    {
    }

    protected void Application_End(object sender, EventArgs e)
    {
    }
}