using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CZBK.ItcastOA.WebFormApp
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
          //  ServiceReference1.WebService1SoapClient client = new ServiceReference1.WebService1SoapClient();
          //// int sum= client.Add(3, 6);
          // Response.Write(client.LoadUserInfoList());

            ServiceReference2.WeatherWSSoapClient client = new ServiceReference2.WeatherWSSoapClient();
            DataSet ds=client.getRegionDataset();
            this.GridView1.DataSource = ds.Tables[0];
            this.GridView1.DataBind();
        }
    }
}