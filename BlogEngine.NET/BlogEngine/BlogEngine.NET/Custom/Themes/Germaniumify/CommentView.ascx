<%@ Control Language="C#" EnableViewState="False" Inherits="BlogEngine.Core.Web.Controls.CommentViewBase" %>
<div id="Blog1_comments-block-wrapper" class="comments">
    <dl class="avatar-comment-indent" id="comments-block">
        <dt class="comment-author" id="<%=Comment.Id %>">
            <div class="avatar-image-container vcard">
               <span dir="ltr">
                  <a href="<%=(this.Comment.Website == null ? "#" : this.Comment.Website.ToString()) %>"><img class="delayLoad" title="<%=Comment.Author %>" src="<%=BlogEngine.Core.Data.Services.Avatar.GetSrc(this.Comment.Email, (this.Comment.Website == null ? "" : this.Comment.Website.ToString())) %>" /></a>
               </span>
            </div>
            <a href="<%=(this.Comment.Website == null ? "#" : this.Comment.Website.ToString() )%> rel="nofollow"><%=Comment.Author %></a> <%=AdminLinks %>
        </dt>
        <dd class="comment-body" id="Blog1_cmt-<%=Comment.Id %>"><%=Text %></dd>
        <div class="comment-footer"><span class="comment-timestamp"><%= Comment.DateCreated.ToString("yyyy-MM-dd HH:mm") %></span></div>
    </dl>
</div>
