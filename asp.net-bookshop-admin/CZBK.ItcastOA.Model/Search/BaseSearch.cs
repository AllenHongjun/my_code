﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.Model.Search
{
   public class BaseSearch
    {
       public int PageIndex { get; set; }
       public int PageSize { get; set; }
       public int TotalCount { get; set; }
    }
}
