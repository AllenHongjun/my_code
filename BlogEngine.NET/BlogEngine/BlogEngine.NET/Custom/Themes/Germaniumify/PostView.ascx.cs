using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BlogEngine.Core;

namespace UserControls
{
    public partial class PostView : BlogEngine.Core.Web.Controls.PostViewBase
    {
        public new string Body
        {
            get
            {
                var post = this.Post;
                var body = post.Content;

                if (Blog.CurrentInstance.IsSiteAggregation)
                {
                    body = Utils.ConvertPublishablePathsToAbsolute(body, post);
                }
               
                if (this.ShowExcerpt)
                {                                     
                    if (!string.IsNullOrEmpty(post.Description))
                    {
                        body = post.Description.Replace(Environment.NewLine, "<br />");
                    }
                    else
                    {
                        body = Utils.StripHtml(body);
                        if (body.Length > this.DescriptionCharacters && this.DescriptionCharacters > 0)
                        {
                            body = body.Substring(0, this.DescriptionCharacters);// string.Format("{0}...{1}", body.Substring(0, this.DescriptionCharacters), link);
                        }
                    }
                }

                var arg = new ServingEventArgs(body, this.Location, this.ContentBy);
                Post.OnServing(post, arg);

                if (arg.Cancel)
                {
                    if (arg.Location == ServingLocation.SinglePost)
                    {
                        this.Response.Redirect("~/error404.aspx", true);
                    }
                    else
                    {
                        this.Visible = false;
                    }
                }
                body = arg.Body;
                if (this.ShowExcerpt)
                {
                    var link = string.Format("<div class=\"jump-link\"><a href=\"{0}\">{1}</div>", post.RelativeLink, Resources.labels.more);// string.Format(" <a href=\"{0}\">[{1}]</a>", post.RelativeLink, Utils.Translate("more"));                   
                    body += link;
                }
                return body;
            }
        }

        protected override void OnLoad(EventArgs e)
        {
            var bodyContent = (PlaceHolder)this.FindControl("BodyContent");
            if (bodyContent == null)
            {
                // We have no placeholder so we assume this is an old style <% =Body %> theme and do nothing.
            }
            else
            {                
                Utils.InjectUserControls(bodyContent, this.Body);
            }
        }
    }
}
