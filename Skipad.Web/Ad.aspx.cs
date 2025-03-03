using System;
using Inqwise.Skipad.Managers;

public partial class Ad : System.Web.UI.Page
{
    protected string SkipRollPreviewUrl
    {
        get { return ResourcesManager.SkipRollPreviewUrl; }
    }

    protected string SkipRollMraidPreviewUrl
    {
        get { return ResourcesManager.SkipRollMraidPreviewUrl; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        AdId = int.Parse(Request["ad_id"]);
    }
 
 	protected int AdId { get; private set; }
}
