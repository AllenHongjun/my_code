using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Script.Serialization;

namespace WebApp.ACE.my
{
    public partial class GetCities : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            var str  = new object[]
            {
                new {Id=1,ProvinceName="广东省",CityName="广州市"},
                new {Id=2,ProvinceName="山东省",CityName="济南市"},
                new {Id=3,ProvinceName="江苏省",CityName="南京市"},
                new {Id=4,ProvinceName="浙江省",CityName="金华市"},
                new {Id=5,ProvinceName="北京省",CityName="北京市"},

            };

            JavaScriptSerializer jsonSerialize = new JavaScriptSerializer();
            string strJson = jsonSerialize.Serialize(str);

            Response.Write(strJson);

        }
    }
}