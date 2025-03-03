using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Configuration;

public partial class _Default : System.Web.UI.Page
{
    public string VastUrl = ConfigurationManager.AppSettings["VastUrl"];
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
}
