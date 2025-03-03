using System;
using Inqwise.Skipad.Managers;

public partial class Theme : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        ThemeId = int.Parse(Request["theme_id"]);
    }

    protected int ThemeId { get; private set; }
 
}
