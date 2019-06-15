<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.RelatedPostsBase" %>
<div id="relatedPosts">
    <h3><%=Resources.labels.relatedPosts %></h3>
    <ol>
         <%foreach (var item in RelatedPostList){%>
            <li><a href="<%=item.Link %>"><%=item.Title %></a></li>
         <% } %>
    </ol>   
</div>
