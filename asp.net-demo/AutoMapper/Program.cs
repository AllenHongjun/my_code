using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoMapper
{
    class Program
    {
        static void Main(string[] args)
        {

            /***
             * https://www.jianshu.com/p/3af537616d05   AutoMapper使用学习笔记
             * 
             * https://cloud.tencent.com/developer/article/1395087   AutoMapper快速上手
             * **/
            //install-package automapper -v 6.2.0
            //WhyUseAutoMapping();

            // 属性名字不一样的时候 就会抛出一个异常
            //TestPerfomance();

            //Mapping();

            //ReverseMap();

            //MapForMember();

            MapIsNull();

        }

        /// <summary>
        /// 为什么要使用功能 auto mapper
        /// 手动映射属性 会浪费比较多的时间
        /// 这样情况如果属性过多会导致浪费大量的时间在对象转换中
        /// </summary>

        public static void WhyUseAutoMapping()
        {
            // 将一个对象 的属性映射到 另外一个对象
            //初始化AutoMapper
            Mapper.Initialize(config => { });
            //源数据对象
            var source = new Source
            {
                Id = 1,
                SName = "张三"
            };
            //映射  可以把一个对象的值 自动的赋值给另外一个对象   
            //已经有的很多功能 如何来使用

            //写一个专门验证的方法 来处理一下 。。
            var target = Mapper.Map<Source, Target>(source);
            Console.WriteLine(target.Id);
            Console.WriteLine(target.TName);
        }

        /// <summary>
        /// 1.2 测试auto mapping 的性能
        /// </summary>
        public static void TestPerfomance()
        {
            //映射1万个对象
            //初始化AutoMapper
            //Mapper.Initialize()方法执行AutoMapper的初始化操作,此操作在一个应用程序中只能执行一次.在初始化方法中可以初始化映射中的任何操作
            Mapper.Initialize(config => { });
            //源数据对象
            IList<Source> sourceList = new List<Source>();
            for (int i = 0; i < 10000; i++)
            {//创建1万个对象进行映射
                sourceList.Add(new Source
                {
                    Id = i,
                    SName = "张三" + i
                });
            }
            Stopwatch watch = new Stopwatch();
            watch.Start();
            //映射
            var targetList = Mapper.Map<IList<Source>, IList<Target>>(sourceList);
            watch.Stop();
            Console.WriteLine("映射1万个对象的时间为:" + watch.ElapsedMilliseconds);
            Console.ReadKey();
        }

        /// <summary>
        /// 1. 映射
        /// </summary>
        public static void Mapping()
        {
            //CreateMap 所以推荐手动加上映射配置,以防异常
            Mapper.Initialize(x => x.CreateMap<Source,Target>());
            //Mapper.CreateMap<Source, Target>();
            var source = new Source { Id = 1, SName = "张三", Age = 11, DateTime = "2018-4-23" };
            //执行映射
            var target = Mapper.Map<Source, Target>(source);
            Console.WriteLine(target.Id);
            Console.WriteLine(target.TName);
            Console.WriteLine(target.Age);
            Console.WriteLine(target.DateTime);
        }

        /// <summary>
        /// 2.反向映射 
        /// </summary>
        public static void ReverseMap()
        {
            //初始化AutoMapper
            Mapper.Initialize(config =>
            {
                //Initialize方法为AutoMapper初始化方法
                //6.2.0版本后如果不需要额外的配置,则CreateMap可省略,但6.2.0版本之前不可省略【不过不建议省略】
                //ReverseMap方法可以实现反向映射

                //只有属性名字相同的才会映射过去 
                config.CreateMap<Source, Target>().ReverseMap();
            });

            var source = new Source { Id = 1, SName = "张三", Age = 11, DateTime = "2018-4-23" };
            //执行映射
            var target = Mapper.Map<Source, Target>(source);
            Console.WriteLine(target.Id);
            Console.WriteLine(target.TName);
            Console.WriteLine(target.Age);
            Console.WriteLine(target.DateTime);
            Console.WriteLine();
            //反向映射
            var reverSource = Mapper.Map<Target, Source>(target);
            Console.WriteLine(reverSource.Id);
            Console.WriteLine(reverSource.SName);
            Console.WriteLine(reverSource.Age);
            Console.WriteLine(reverSource.DateTime);

        }

        /// <summary>
        /// 属性名称不一致的时候映射
        /// </summary>
        public static void MapForMember()
        {
            //初始化AutoMapper
            Mapper.Initialize(config =>
            {
                //Initialize方法为AutoMapper初始化方法
                //6.2.0版本后如果不需要额外的配置,则CreateMap可省略,但6.2.0版本之前不可省略【不过不建议省略】
                config.CreateMap<Source, Target>()
                //ForMember可以配置一系列的配置信息
                //参数1:目标类型属性的表达式
                //参数2:执行操作的选择   AutoMapper定义了一系列的配置选择供开发者使用
                .ForMember(dest => dest.TName, options => options.MapFrom(sou => sou.SName));
            });

            var source = new Source { Id = 1, SName="张三", Age = 11, DateTime = "2018-4-23" };
            //执行映射
            var target = Mapper.Map<Source, Target>(source);
            Console.WriteLine(target.Id);
            Console.WriteLine(target.TName);
            Console.WriteLine(target.Age);
            Console.WriteLine(target.DateTime);

        }


        /// <summary>
        /// 空值替换   AutoMapper中允许设置一个备用值来代替源类型中的空值
        /// </summary>
        public static void MapIsNull()
        {
            //初始化AutoMapper
            Mapper.Initialize(config =>
            {
                //Initialize方法为AutoMapper初始化方法
                //6.2.0版本后如果不需要额外的配置,则CreateMap可省略,但6.2.0版本之前不可省略【不过不建议省略】
                config.CreateMap<Source, Target>()
                //ForMember可以配置一系列的配置信息
                //参数1:目标类型属性的表达式
                //参数2:执行操作的选择   AutoMapper定义了一系列的配置选择供开发者使用
                .ForMember(dest => dest.TName, options => options.MapFrom(sou => sou.SName))
                //NullSubstitute是空值替换的配置操作
                .ForMember(dest => dest.TName, options => options.NullSubstitute(" "));
            });

            var source = new Source { Id = 1,  Age = 11, DateTime = "2018-4-23" };
            //执行映射
            var target = Mapper.Map<Source, Target>(source);
            Console.WriteLine(target.Id);
            Console.WriteLine(target.TName);
            Console.WriteLine(target.Age);
            Console.WriteLine(target.DateTime);
        }


        // 有继承的类  嵌套的类的属性 配置 
        // options 添加几个配置的规则..和使用.


    }


    
}
