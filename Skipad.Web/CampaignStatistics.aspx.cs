using System;
using Inqwise.Skipad.Managers;

public partial class CampaignStatistics : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        CampaignId = int.Parse(Request["campaign_id"]);
    }

    protected int CampaignId { get; private set; }
	
}
