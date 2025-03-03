using System;
using Inqwise.Skipad.Managers;

public partial class AdStatistics : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        AdId = int.Parse(Request["ad_id"]);
    }
 
 	protected int AdId { get; private set; }
}
