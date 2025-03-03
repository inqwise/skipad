<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MenuSide.ascx.cs" Inherits="UserControls_MenuSide" %>
 <div style="width:100%;padding-left:20px;">
 <h4>Select demo</h4>
 <br />
 </div>
 <ul class="sidemenu">
        <li><a href="~/Demos/TestSlider300.aspx" id="aSlider300" runat="server">Slider 300x250</a></li>
        <li class="separator"></li>
        <li><a href="~/Demos/TestSlider180.aspx" id="aSlider180" runat="server">Slider 180x150</a></li>
        <li class="separator"></li>
        <li><a href="~/Demos/TestSkipFlash.aspx" id="aTestFlash" runat="server">Skip PreRoll Ad demo</a></li>
        <li class="separator"></li>
        <li><a href="~/Demos/TestSkip.aspx" id="aTestSkip" runat="server">Welcome Ad, with Skip Ad option</a></li>
        <%if(Page.User.Identity.IsAuthenticated) {%>
        <li class="separator"></li>
        <li><a href="~/LandingDemo/Demos.aspx" id="aDemos" runat="server">Custom demos</a></li>
        <%}; %>
</ul>
 <div id="divPlayVideo" style="width:100%;padding-left:20px;padding-top:180px;">
<h4>Play video</h4>
<div class="description" style="margin:20px 0 0 20px;cursor:pointer;display:none;">
<img id="imgVideo" src="" alt="video" />
</div>
 </div>
 <ul class="sidemenu">
        <li><a href="~/Demos/Videos.aspx?n=0" id="a2" runat="server">Slide to Fit captcha</a></li>
        <li class="separator"></li>
 </ul>

 <script type="text/javascript">

     $(document).ready(function () {

         $("#imgVideo").bind("click", function () {

             try {
                 $.colorbox({ iframe: true, href: '', width: "900px", height: "550px" });
             }
             catch (e) {
                 window.open('', 'video', 'resizable=no,scrollbars=no,status=no,width=900,height=550,menubar=no,toolbar=no');
             }
         });


     });
 </script>
