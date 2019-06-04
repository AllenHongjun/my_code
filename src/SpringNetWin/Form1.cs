using Spring.Context;
using Spring.Context.Support;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SpringNetWin
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            //控制反转 创建对象的工作 交给 spring.net unity.net autofac 来做。
            //找到我们需要使用的来做就行了。。不是所没一点都要会用。。用到需要的会用 找到自己需要的就可以了。
            //找有经验的 人 开发视频 学习一下 别人是怎么做的 抄 学 魔方 一步一步走

            //在代码中，我们引用了Spring.Context命名空间，以便用IApplicationContext接口访问IoC容器，其中... 
            //IApplicationContext ctx = ContextRegistry.GetContext();
            //...返回的就是一个已经根据<objects/>节点的内容配置好的容器对象。 

            //MovieLister lister = (MovieLister)ctx.GetObject("MyMovieLister");

            //获取配置文件中的内容
            IApplicationContext ctx = ContextRegistry.GetContext();
            //根据配置文件 注册读取我们 要的对象 回帮我们创建 我们需要的对象
            //UserInfoService lister = (UserInfoService)ctx.GetObject("UserInfoService");

            //根据我们知道的类型 把这个对象的实例 转换成我们需要的类型。这就搞定了。

            //直接配置使用还是一个比较简单的步骤 。有些东西 不是都放在一个项目里面 
            //弄一个小的测试项目 就能很快的运行了。
            IUserInfoService lister2 = (IUserInfoService)ctx.GetObject("UserInfoService");
            MessageBox.Show(lister2.ShowMsg());


            //按照官网的例子 文档又需要的来弄一个小的demo 然后看一下 别人 要配置到项目中是如何来使用的。 模仿着写一写就可以了。
        }
    }
}
