using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using WebShop.WebHelper;

namespace WebShop.WebTest
{
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