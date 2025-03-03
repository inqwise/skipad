<%@ Page Title="Log In" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Login.aspx.cs" Inherits="Account_Login" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
	<h1>Log In</h1>
</asp:Content>


<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
	<div style="font-weight: bold; background-color: #FFEAEA; border: 1px solid red; padding: 4px;color: #000">Please Disable your Ad Blocker in this domain before Log in!</div>
   	<p>Please enter your username and password. <asp:HyperLink ID="RegisterHyperLink" runat="server" EnableViewState="false">Register</asp:HyperLink> if you don't have an account.</p>
    <asp:Login ID="LoginUser" runat="server" EnableViewState="false" RenderOuterTable="false" OnLoggedIn="LoginUser_LoggedIn">
        <LayoutTemplate>
            <span class="status">
                <asp:Literal ID="FailureText" runat="server"></asp:Literal>
            </span>
            <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="status" 
                 ValidationGroup="LoginUserValidationGroup"/>
                 
				<div>
                
                
                 <div style="padding-top: 24px;">
                 	
                 
                    <div class="params">
                    	<div class="param-name">
                        	<asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">Username:</asp:Label>
                        </div>
                        <div class="param-value">
                        
                        	<asp:TextBox ID="UserName" runat="server" CssClass="InputField"></asp:TextBox>
                        	<asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" 
	                             CssClass="status" ErrorMessage="User Name is required." ToolTip="User Name is required." 
	                             ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
                        
                        </div>
                    </div>
                    <div class="params">
                        <div class="param-name">
                        	<asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                        </div>
                        <div class="param-value">
                        
	                        <asp:TextBox ID="Password" runat="server" CssClass="InputField" TextMode="Password"></asp:TextBox>
	                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" 
	                             CssClass="status" ErrorMessage="Password is required." ToolTip="Password is required." 
	                             ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
                             
                    	</div>
                    </div>
                    <div class="params">
                    	<div class="param-name"></div>
                        <div class="param-value">
	                        <asp:CheckBox ID="RememberMe" runat="server"/>
	                        <asp:Label ID="RememberMeLabel" runat="server" AssociatedControlID="RememberMe" CssClass="inline">Keep me logged in</asp:Label>
                   		</div>
                    </div>
                    <div class="params">
                    	<div class="param-name"></div>
                        <div class="param-value">    
                    		<asp:Button ID="LoginButton" runat="server" CssClass="button-white" CommandName="Login" Text="Log In" ValidationGroup="LoginUserValidationGroup"/>
               			</div>
                   	</div>
                 </div>
                 
                 
            </div>
        </LayoutTemplate>
    </asp:Login>
    
    <script type="text/javascript">
    $(function() {
    
    	$("#MainContent_LoginUser_UserName").focus();
    	
    });
    </script>
    
</asp:Content>