<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Reports.aspx.cs" Inherits="Reports" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">



	<link rel="stylesheet" type="text/css" href="css/datatable/datatable.css" />
	<link rel="stylesheet" type="text/css" href="Styles/colorbox/colorbox.css" />


	<script type="text/javascript" src="scripts/datatable/datatable.js"></script>
	<script type="text/javascript" src="Scripts/jquery.colorbox-min.js"></script>



</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
    <h1>Reports</h1>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    
    
    <div class="content-middle-tabs-section">
		<div class="content-middle-tabs">
	    	<ul class="content-middle-tabs-container">
	    		<li><a href="/" title="Dashboard"><span>Dashboard</span></a></li>
	    		<li><a href="campaigns.aspx" title="Campaigns"><span>Campaigns</span></a></li>
	    		<li><a href="ads.aspx" title="Ads"><span>Ads</span></a></li>
	    		<li><a href="reports.aspx" class="selected" title="Reports"><span>Reports</span></a></li>
	    	</ul>
    	</div>
    </div>
    <div style="clear: both; padding-top: 20px;">
    	<div>TEST</div>
    	
		<div id="table_reports"></div>
	
    </div>
    
    
<script type="text/javascript">
var servletUrl = "handlers/ads.ashx";

$(function () {

});
</script>

</asp:Content>
