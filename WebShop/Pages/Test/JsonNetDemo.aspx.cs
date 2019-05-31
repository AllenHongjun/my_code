using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebShop.WebHelper;

namespace WebShop.Pages.Test
{
    public partial class JsonNetDemo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            


        }


        /// <summary>
        /// 序列化一个对象。。class。不是一篇博客 看一下 你就会的。。
        /// 最起码 要写一个demo测试一下吧。。
        /// 以后下次用到了 就容易很多
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void seriliaze_Click(object sender, EventArgs e)
        {
            Student student = new Student();
            student.ID = 1;
            student.Name = "李丹";
            student.NickName = "蛋蛋";
            student.Class = new Class { Name = "CS2017", ID = 2017 };

            //序列化一个对象 然后输出
            //着是一个对象 转化层一个字符串 看着那么简单。。
            //如果不是mvc的返回里面 你怎么使用 对吧。。其他他是做很多的工作的。
            //但是使用这些组件 你就可以很简单的实现工功能
            //挖掘需要的点。。.net你要使用一个对象 一般都是需要先定义一个实体类
            //而且还好注意实例类之间 可以通过属性 来建立关系的这一点
            string jsonStudent = JsonHelper.SerializeObject(student);

            //反序列化   序列化出来着个字符串是一个什么类型
            //反序列出来的这个对象 如何打印输出呢 》？？ WebShop.Pages.Test.JsonNetDemo+Student
            var studentDe = JsonHelper.DeserializeJsonToObject<Student>(jsonStudent);

            Response.Write(jsonStudent);
            Response.Write(studentDe);


            
        }




        //单元测试的项目 你怎么运行都不知道。。
        //能够使用出来的为主。。。

        protected void Button1_Click(object sender, EventArgs e)
        {
            Student sdudent = new Student();
            sdudent.ID = 1;
            sdudent.Name = "陈晨";
            sdudent.NickName = "石子儿";
            sdudent.Class = new Class() { Name = "CS0216", ID = 0216 };


            Student sdudent1 = new Student {
                ID = 2,
                Name = "李四",
                NickName = "滴滴答答",
                Class = new Class() { Name = "CS0216", ID = 0216 }
            };

            //实体集合序列化和反序列化
            List<Student> sdudentList = new List<Student>() { sdudent, sdudent1 };
            string json2 = JsonHelper.SerializeObject(sdudentList);
            Response.Write(json2);

            //分析一下这个对象结构是什么样子的 然后构建响应的 实例类把他解析出来
            //List解析出来是一个数组 List 队形的话还是一个对象

            //需要一个helper帮助类 需要一些测试的demo 然后调试使用一下。。
            //json: [{"ID":1,"Name":"陈晨","NickName":"石子儿","Class":{"ID":216,"Name":"CS0216"}},{"ID":1,"Name":"陈晨","NickName":"石子儿","Class":{"ID":216,"Name":"CS0216"}}]
            List<Student> sdudentList2 = JsonHelper.DeserializeJsonToList<Student>(json2);
        }

        protected void Button2_Click(object sender, EventArgs e)
        {

        }



        protected void Button3_Click1(object sender, EventArgs e)
        {
            //匿名对象解析  接受请求的哪一步 老王帮我们都处理好了。。
            var tempEntity = new { ID = 0, Name = string.Empty };
            string json5 = JsonHelper.SerializeObject(tempEntity);
            Response.Write(json5);
            //json5 : {"ID":0,"Name":""}

            //关键要构建 这个json对象 对应的实体类型 然后才能够 解析 就是常说的实体类。。

            //每一个都是构建出来。。不然难 就是属性 字段比较的多。
            tempEntity = JsonHelper.DeserializeAnonymousType("{\"ID\":\"112\",\"Name\":\"石子儿\"}", tempEntity);
            var tempStudent = new Student();

            //解析过来 如果属性的值没有赋值那就是null 对象数组 对量的集合 对象对象  对象 属性包容一个对象
            //对象的属性包容一个对象的集合 。对象的属性 包容一个对象的属性 。然后还可以继续关联下去 无线关联下去都是一样的。
            tempStudent = JsonHelper.DeserializeAnonymousType("{\"ID\":\"112\",\"Name\":\"石子儿\"}", tempStudent);
        }

        /// <summary>
        /// Json测试
        /// </summary>
        /// : IRun
        public class JsonTest
        {
            public void Run()
            {
                Student sdudent = new Student();
                sdudent.ID = 1;
                sdudent.Name = "陈晨";
                sdudent.NickName = "石子儿";
                sdudent.Class = new Class() { Name = "CS0216", ID = 0216 };

                //实体序列化和反序列化
                string json1 = JsonHelper.SerializeObject(sdudent);
                //json1 : {"ID":1,"Name":"陈晨","NickName":"石子儿","Class":{"ID":216,"Name":"CS0216"}}
                Student sdudent1 = JsonHelper.DeserializeJsonToObject<Student>(json1);

                //实体集合序列化和反序列化
                List<Student> sdudentList = new List<Student>() { sdudent, sdudent1 };
                string json2 = JsonHelper.SerializeObject(sdudentList);
                //json: [{"ID":1,"Name":"陈晨","NickName":"石子儿","Class":{"ID":216,"Name":"CS0216"}},{"ID":1,"Name":"陈晨","NickName":"石子儿","Class":{"ID":216,"Name":"CS0216"}}]
                List<Student> sdudentList2 = JsonHelper.DeserializeJsonToList<Student>(json2);

                //DataTable序列化和反序列化
                DataTable dt = new DataTable();
                dt.TableName = "Student";
                dt.Columns.Add("ID", typeof(int));
                dt.Columns.Add("Name");
                dt.Columns.Add("NickName");
                DataRow dr = dt.NewRow();
                dr["ID"] = 112;
                dr["Name"] = "战三";
                dr["NickName"] = "小三";
                dt.Rows.Add(dr);
                string json3 = JsonHelper.SerializeObject(dt);
                //json3 : [{"ID":112,"Name":"战三","NickName":"小三"}]
                DataTable sdudentDt3 = JsonHelper.DeserializeJsonToObject<DataTable>(json3);
                List<Student> sdudentList3 = JsonHelper.DeserializeJsonToList<Student>(json3);

                //验证对象和数组
                Student sdudent4 = JsonHelper.DeserializeJsonToObject<Student>("{\"ID\":\"112\",\"Name\":\"石子儿\"}");
                List<Student> sdudentList4 = JsonHelper.DeserializeJsonToList<Student>("[{\"ID\":\"112\",\"Name\":\"石子儿\"}]");

                //匿名对象解析
                var tempEntity = new { ID = 0, Name = string.Empty };
                string json5 = JsonHelper.SerializeObject(tempEntity);
                //json5 : {"ID":0,"Name":""}
                tempEntity = JsonHelper.DeserializeAnonymousType("{\"ID\":\"112\",\"Name\":\"石子儿\"}", tempEntity);
                var tempStudent = new Student();
                tempStudent = JsonHelper.DeserializeAnonymousType("{\"ID\":\"112\",\"Name\":\"石子儿\"}", tempStudent);

                Console.Read();
            }

        }

        /// <summary>
        /// 学生信息实体
        /// </summary>
        public class Student
        {
            public int ID { get; set; }
            public string Name { get; set; }
            public string NickName { get; set; }
            public Class Class { get; set; }
        }

        /// <summary>
        /// 学生班级实体
        /// </summary>
        public class Class
        {
            public int ID { get; set; }
            public string Name { get; set; }
        }

    }
}