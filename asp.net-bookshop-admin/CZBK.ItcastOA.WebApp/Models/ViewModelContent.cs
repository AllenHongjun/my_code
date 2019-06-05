using CZBK.ItcastOA.Model.EnumType;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CZBK.ItcastOA.WebApp.Models
{
    public class ViewModelContent
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public LuceneTypeEnum LuceneTypeEnum { get; set; }
    }
}