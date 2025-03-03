using System;
using Jayrock.Json;
using Inqwise.Skipad.Managers;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    private const string ACCOUNTS_ARRAY_SCRIPT = "accountArrayScript";
    public string BaseUrl;
    protected void Page_Load(object sender, EventArgs e)
    {
        BaseUrl = Request.Url.GetLeftPart(UriPartial.Authority);
        if (!IsPostBack)
        {
            if (Page.User.Identity.IsAuthenticated)
            {
                RegisterAccountsArray(); 
            }
        }
    }

    protected string UserName
    {
        get
        {
            return Page.User.Identity.Name;
        }
    }

    protected void RegisterAccountsArray()
    {
        if (!Page.ClientScript.IsClientScriptBlockRegistered("accounts"))
        {
            var arr = new JsonArray();
            
            var accounts = AccountsManager.GetMeny(UserName);
            foreach (var account in accounts)
            {
                var jo = new JsonObject();
                jo.Put("accountId", account.Id);
                jo.Put("name", account.Name);
                jo.Put("isDefault", account.IsDefault);
                arr.Put(jo);
            }
            

            /*
            //TODO: remove
            arr.Put(new { accountId = 1, name = "test01" });
            arr.Put(new { accountId = 2, name = "test02", isDefault = true });
             */

            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "accounts", string.Format("var accounts = {0}", arr), true); 
        }
    }
}
