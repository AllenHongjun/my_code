using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;

namespace BookService
{
    public class BundleConfig
    {

        public static void RegisterBundles(BundleCollection bundles)
        {
            // ...

            // New code:
            bundles.Add(new ScriptBundle("~/bundles/app").Include(
                      "~/Scripts/knockout-{version}.js",
                      "~/Scripts/app.js"));
        }
    }
}