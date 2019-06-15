<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.CommentFormBase" %>
<%@ Import Namespace="BlogEngine.Core" %>
<div class="comment-form">
    <h4><%=Resources.labels.addComment %></h4>
    <div id="allHolder">
        <div id="commentsHolder">
            <textarea name="txtContent" id="txtContent" rows="4" cols="50" placeholder="Enter your comment..."></textarea>
            <br />
            <div id="identityControlsHolder">
                <div class="form-group">
                   <label><%=Resources.labels.name %> *</label><input type="text" class="form-control" name="txtName" id="txtName" />
                </div>
                <div class="form-group">
                   <label><%=Resources.labels.email %> *</label>  <input type="text" class="form-control" id="txtEmail" />
                </div>
                  <div class="form-group">
                   <label><%=Resources.labels.website %></label>  <input type="text" class="form-control" id="txtWebsite" />
                </div>
                <div class="form-group" style="margin-left:65px">
                    <input type="checkbox" id="cbNotify" class="cmnt-frm-notify" /> <%=Resources.labels.notifyOnNewComments %></label>
                </div>
            </div>
        </div>
        <div id="postCommentButtonHolder" class="postCommentButtonHolder">
            <input type="button" id="btnSaveAjax" value="<%=Resources.labels.saveComment %>" class="postCommentSubmit" onclick="return BlogEngine.validateAndSubmitCommentForm()" />
            <input type="button" id="preview" name="preview" class="postCommentPreview" onclick="return BlogEngine.showCommentPreview()" value="<%=Resources.labels.livePreview%>">
              <div id="commentPreview" class="form-control comment-preview">
                    <img src="<%=Utils.RelativeWebRoot %>pics/ajax-loader.gif" style="display: none" alt="Loading" />
             </div>
        </div>
    </div>    
</div>
