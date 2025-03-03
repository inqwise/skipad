<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Register.aspx.cs" Inherits="Account_Register" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

</asp:Content>

<asp:Content ID="TitleContent" runat="server" ContentPlaceHolderID="TitleHolder">
	<h1>Registration</h1>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
   	
   	<p>Please enter your registration details.<!--<asp:HyperLink ID="RegisterHyperLink" runat="server" EnableViewState="false">Register</asp:HyperLink> if you don't have an account.--></p>
    <asp:CreateUserWizard ID="RegisterUser" runat="server" EnableViewState="false" OnCreatedUser="RegisterUser_CreatedUser">
        <LayoutTemplate>
            <asp:PlaceHolder ID="wizardStepPlaceholder" runat="server"></asp:PlaceHolder>
            <asp:PlaceHolder ID="navigationPlaceholder" runat="server"></asp:PlaceHolder>
        </LayoutTemplate>
        <WizardSteps>
            <asp:CreateUserWizardStep ID="RegisterUserWizardStep" runat="server">
                <ContentTemplate>
                    <span class="status">
                        <asp:Literal ID="ErrorMessage" runat="server"></asp:Literal>
                    </span>
                    <asp:ValidationSummary ID="RegisterUserValidationSummary" runat="server" CssClass="status" 
                         ValidationGroup="RegisterUserValidationGroup"/>
                    
                    
                    <div>
                    <p>Use the form below to create a new account.</p>
                    <p>Passwords are required to be a minimum of <%= Membership.MinRequiredPasswordLength %> characters in length.</p>

                    	<div style="padding-top: 24px;">

                        
                        	<div class="params">
                        		<div class="param-name">
                        			<asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label>
                        		</div>
                        		<div class="param-value">
                        			<asp:TextBox ID="UserName" runat="server" CssClass="InputField"></asp:TextBox>
	                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" 
	                                     CssClass="status" ErrorMessage="User Name is required." ToolTip="User Name is required." 
	                                     ValidationGroup="RegisterUserValidationGroup">*</asp:RequiredFieldValidator>
                        		</div>
                            </div>
                            <div class="params">
                        		<div class="param-name">
                            		<asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email">E-mail:</asp:Label>
                            	</div>
                            	<div class="param-value">
	                            	<asp:TextBox ID="Email" runat="server" CssClass="InputField"></asp:TextBox>
	                                <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email" 
	                                     CssClass="status" ErrorMessage="E-mail is required." ToolTip="E-mail is required." 
	                                     ValidationGroup="RegisterUserValidationGroup">*</asp:RequiredFieldValidator>
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
	                                     ValidationGroup="RegisterUserValidationGroup">*</asp:RequiredFieldValidator>
                            	</div>
                            </div>
                            <div class="params">
                        		<div class="param-name">
                            		<asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword">Confirm Password:</asp:Label>
                            	</div>
                            	<div class="param-value">
	                            	<asp:TextBox ID="ConfirmPassword" runat="server" CssClass="InputField" TextMode="Password"></asp:TextBox>
	                                <asp:RequiredFieldValidator ControlToValidate="ConfirmPassword" CssClass="status" Display="Dynamic" 
	                                     ErrorMessage="Confirm Password is required." ID="ConfirmPasswordRequired" runat="server" 
	                                     ToolTip="Confirm Password is required." ValidationGroup="RegisterUserValidationGroup">*</asp:RequiredFieldValidator>
	                                <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" 
	                                     CssClass="status" Display="Dynamic" ErrorMessage="The Password and Confirmation Password must match."
	                                     ValidationGroup="RegisterUserValidationGroup">*</asp:CompareValidator>
                            	</div>
                            </div>
                            <div class="params">
                        		<div class="param-name"></div>
                             	<div class="param-value">
                               		<asp:Button ID="CreateUserButton" CssClass="button-white" runat="server" CommandName="MoveNext" Text="Create User" ValidationGroup="RegisterUserValidationGroup"/>
                              	</div>
                            </div>
                        
                        
                        
                        </div>
                    </div>
                </ContentTemplate>
                <CustomNavigationTemplate>
                </CustomNavigationTemplate>
            </asp:CreateUserWizardStep>
        </WizardSteps>
    </asp:CreateUserWizard>
    
    
    <script type="text/javascript">
    $(function() {
    
    	$("#MainContent_RegisterUser_CreateUserStepContainer_UserName").focus();
    	
    });
    </script>
    
</asp:Content>