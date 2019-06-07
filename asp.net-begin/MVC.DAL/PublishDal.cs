using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IDAL;
using MVC.Model;

namespace MVC.DAL
{   
    /// <summary>
    /// 出版社
    /// </summary>
    public class PublishDal:BaseDal<Publishers>,IPublishDal
    {
        //这些类都是要别的层来调用 当然是要public  可以T4模板来生成
    }
}
