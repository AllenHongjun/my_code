using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common
{
    public static class PageBarHelper
    {   
        /// <summary>
        /// 从那一页开始 显示几页的数字条码
        /// 每一个页面 就是一个a链接
        /// 这个条码的接口 可以自己另外拼接
        /// 样式就是按照那个结构 添加class就行了
        /// 就有很大的 自主性 拼接处好看的样式来
        /// 
        /// 条码是一块  
        /// 分页显示内容是一块
        /// 首页 上一页 下一页 尾页 页面显示判断是一块
        /// 各个组装起来才是一个完整的功能
        /// 了解了这个功能 其他封装好了就能更好的理解和实现了
        /// 敲了代码才会有更加深刻的理解
        /// </summary>
        /// <param name="pageIndex">开始页数</param>
        /// <param name="pageCount">总页数</param>
        public static string GetPageBar(int pageIndex,int pageCount)
        {   
            //如果只有一页就不用显示了
            if (pageCount == 1)
            {   

                return String.Empty;
            }

            int start = pageIndex - 5;
            if (start < 1)
            {
                start = 1;
            }
            int end = start + 9;
            if (end > pageCount)
            {
                end = pageCount;
                //重新计算开始页数 不能超过开始 也不能超过结束
                start = end - 9 < 1? 1:end - 9;
            }
            StringBuilder sb = new StringBuilder();
            //首页
            if (pageIndex > 1)
            {
                sb.AppendFormat("<a href='?page={0}'>上一页</a>", pageIndex - 1);
            }
            //start end 每一页面的数字
            for (int i = start; i <= end; i++)
            {
                if (i == pageIndex)
                {
                    //当前页面不需要链接
                    sb.Append(i);
                }
                else
                {
                    sb.AppendFormat("<a href='?page={0}'>   {0}   </a>", i);
                }
            }

            //尾页
            if (pageIndex < pageCount)
            {
                sb.AppendFormat("<a href='?page={0}'>下一页</a>", pageIndex + 1);
            }

            return sb.ToString();

        }


    }
}
