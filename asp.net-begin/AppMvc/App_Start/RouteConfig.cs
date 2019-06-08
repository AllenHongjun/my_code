﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Routing;

namespace AppMvc
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            //routes.MapRoute(
            //    name: "AdminDefault",
            //    url: "admin/{controller}/{action}/{id}",
            //    defaults: new { controller = "Login", action = "Index", id = UrlParameter.Optional },
            //    namespaces: new string[] { "AppMvc.Areas.Admin.Controllers" }
            //);


            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional },
                namespaces: new string[] { "AppMvc.Controllers" }
            );


        }
    }
}
