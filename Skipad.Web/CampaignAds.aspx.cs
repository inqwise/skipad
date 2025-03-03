using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Configuration;

public partial class CampaignAds : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CampaignId = int.Parse(Request["campaign_id"]);
    }

    protected int CampaignId { get; private set; }
}
