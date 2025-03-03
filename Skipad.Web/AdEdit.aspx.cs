using System;
using Inqwise.Skipad.Managers;

public partial class AdEdit : System.Web.UI.Page
{
    protected string SkipRollPreviewUrl
    {
        get { return ResourcesManager.SkipRollPreviewUrl; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        AdId = int.Parse(Request["ad_id"]);
    }
 
 	protected int AdId { get; private set; }
}
