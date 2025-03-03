using System;
using Inqwise.Skipad.Managers;

public partial class AdDomainStatistics : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        AdId = int.Parse(Request["ad_id"]);
		//Domain = String.Parse(Request["domain"]);
    }
 
 	protected int AdId { get; private set; }
	//protected String Domain { get; private set; }
}
