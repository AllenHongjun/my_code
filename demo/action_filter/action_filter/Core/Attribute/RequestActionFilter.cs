using action_filter.Models;
using action_filter_api.common.Helper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace action_filter_api.Core.Attribute
{
    public class RequestActionFilter : ActionFilterAttribute
    {   
        /// <summary>
        /// 在执行 action方法之前 由 asp.net mvc调用
        /// </summary>
        /// <param name="filterContext"></param>
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            filterContext.HttpContext.Response.Write("Action方法准备执行");
            string controllerName = filterContext.RouteData.Values["controller"].ToString();
            string actionName = filterContext.RouteData.Values["action"].ToString();

            var httpMethod = filterContext.HttpContext.Request.HttpMethod;
            var httpStatusCode = filterContext.HttpContext.Response.StatusCode;
            var clientInfo = filterContext.HttpContext.Request.Browser.Browser;
            //var duration = filterContext.HttpContext.Server.
            var absoluteUri = filterContext.RequestContext.HttpContext.Request.Url.AbsoluteUri;

            var query = filterContext.RequestContext.HttpContext.Request.Url.Query;
            var form = filterContext.RequestContext.HttpContext.Request.Form;
            var actionParameters = filterContext.ActionParameters;

            var reqData = new
            {
                controllerName,
                actionName,

                httpMethod,
                httpStatusCode,
                clientInfo,
                absoluteUri,

                query = query,
                from = form,
                actionParameters = actionParameters
            };
            Log4net.Info(reqData);
           
            base.OnActionExecuting(filterContext);
        }

        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            base.OnActionExecuted(filterContext);
        }


        public override void OnResultExecuting(ResultExecutingContext filterContext)
        {
            base.OnResultExecuting(filterContext);
        }

        public override void OnResultExecuted(ResultExecutedContext filterContext)
        {
            base.OnResultExecuted(filterContext);
        }
    }
}