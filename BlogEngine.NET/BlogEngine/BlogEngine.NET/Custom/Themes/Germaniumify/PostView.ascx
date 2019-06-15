<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PostView.ascx.cs" Inherits="BlogEngine.Core.Web.Controls.PostViewBase" EnableViewState="false" %>
<article class="post" id="post<%=Index %>">    
    <header>
        <div class="title">
            <h3 class="post-title entry-title" style="float:left"><a href="<%=Post.RelativeOrAbsoluteLink %>"><%=Server.HtmlEncode(Post.Title) %></a></h3>
            <div style="float: left; margin: 10px 0pt 0pt; width: 10px; height: 38px; background-color: rgb(235, 235, 235);"></div>
            <div style="clear: both; margin: 0pt 0px 0pt 20px; height: 10px; background-color: rgb(235, 235, 235);"></div>
        </div>
        <div class="post-header">
            <div class="post-header-line-1">
                <span class="date-header"><%=Post.DateCreated.ToString("d. MMMM yyyy") %></span>
                <span class="post-author vcard"><span class="fn"><a href="<%=BlogEngine.Core.Utils.AbsoluteWebRoot + "author/" + BlogEngine.Core.Utils.RemoveIllegalCharacters(Post.Author) + BlogEngine.Core.BlogConfig.FileExtension %>"><%=Post.AuthorProfile != null ? Post.AuthorProfile.DisplayName : Post.Author %></a></span></span>                              
                <span class="post-category"><%=CategoryLinks(", ") %></span>
            </div>         
        </div>
    </header>
    <section class="post-body">
        <asp:PlaceHolder ID="BodyContent" runat="server" />
        <div class="clear"></div>           
    </section>

    <footer class="post-footer">        
        <div class="post-footer-line post-footer-line-1">
            <span class="post-labels">
                <%if (this.Post.Tags.Count>0) { %>
                 <%=Resources.labels.tags %> : <%=TagLinks(", ") %><%} %>
            </span>           
        </div>      
    </footer>
</article>
