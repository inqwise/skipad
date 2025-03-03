using System;
using Inqwise.Skipad.Managers;

public partial class Campaign : System.Web.UI.Page
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
        CampaignId = int.Parse(Request["campaign_id"]);
    }

    protected int CampaignId { get; private set; }
}
