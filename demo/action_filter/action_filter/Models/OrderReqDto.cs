using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace action_filter.Models
{
    public class OrderReqDto
    {
        public string Keyword { get; set; }

        public int Page { get; set; }

        public int Limit { get; set; }


    }
}