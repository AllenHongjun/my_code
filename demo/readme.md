



- [Quartz.Net使用教程](https://www.cnblogs.com/youring2/p/quartz_net.html)



在项目的开发过程中，难免会遇见后需要后台处理的任务，例如定时发送邮件通知、后台处理耗时的数据处理等，这个时候你就需要`Quartz.Net`了。

`Quartz.Net`是纯净的，它是一个.Net程序集，是非常流行的Java作业调度系统Quartz的C#实现。

`Quartz.Net`一款功能齐全的任务调度系统，从小型应用到大型企业级系统都能适用。功能齐全体现在触发器的多样性上面，即支持简单的定时器，也支持Cron表达式；即能执行重复的作业任务，也支持指定例外的日历；任务也可以是多样性的，只要继承IJob接口即可。

对于小型应用，`Quartz.Net`可以集成到你的系统中，对于企业级系统，它提供了Routing支持，提供了Group来组织和管理任务，此外还有持久化、插件功能、负载均衡和故障迁移等满足不同应用场景的需要。

## Hello Quartz.Net

开始使用一个框架，和学习一门开发语言一样，最好是从Hello World程序开始。

首先创建一个示例程序，然后添加Quartz.Net的引用。

```
Install-Package Quartz -Version 3.0.7
```

我们使用的是当前最新版本3.0.7进行演示。添加引用以后，来创建一个Job类`HelloQuartzJob`。

```
public class HelloQuartzJob : IJob
{
    public Task Execute(IJobExecutionContext context)
    {
        return Task.Factory.StartNew(() =>
        {
            Console.WriteLine("Hello Quartz.Net");
        });
    }
}
```

这是个非常简单的Job类，它在执行时输出文本`Hello Quartz.Net`。

接下来，我们在程序启动时创建调度器（Scheduler），并添加HelloQuartzJob的调度：

```
static async Task MainAsync()
{
    var schedulerFactory = new StdSchedulerFactory();
    var scheduler = await schedulerFactory.GetScheduler();
    await scheduler.Start();
    Console.WriteLine($"任务调度器已启动");

    //创建作业和触发器
    var jobDetail = JobBuilder.Create<HelloQuartzJob>().Build();
    var trigger = TriggerBuilder.Create()
                                .WithSimpleSchedule(m => {
                                    m.WithRepeatCount(3).WithIntervalInSeconds(1);
                                })
                                .Build();

    //添加调度
    await scheduler.ScheduleJob(jobDetail, trigger);
}
```

然后运行程序，你会看到如下图：
![HelloQuartzJob Run](https://images.cnblogs.com/cnblogs_com/youring2/1487154/o_HelloQuartzJob-Run.png)

通过演示可以看出，要执行一个定时任务，一般需要四步：

1. 创建任务调度器。调度器通常在应用程序启动时创建，一个应用程序实例通常只需要一个调度器即可。
2. 创建Job和JobDetail。Job是作业的类型，描述了作业是如何执行的，这个类是由我们定义的；JobDetail是Quartz对作业的封装，它包含Job类型，以及Job在执行时用到的数据，还包括是否要持久化、是否覆盖已存在的作业等选项。
3. 创建触发器。触发器描述了在何时执行作业。
4. 添加调度。当完成以上三步以后，就可以对作业进行调度了。

## 作业：Job和JobDetail

Job是作业的类型，描述了作业是如何执行的，这个类型是由我们定义的，例如上文的`HelloQuartzJob`。Job实现IJob接口，而IJob接口只有一个`Execute`方法，参数`context`中包含了与当前上下文中关联的Scheduler、JobDetail、Trigger等。

一个典型的Job定义如下：

```
public class HelloQuartzJob : IJob
{
    public Task Execute(IJobExecutionContext context)
    {
        return Task.Factory.StartNew(() =>
        {
            Console.WriteLine("Hello Quartz.Net");
        });
    }
}
```

### JobData

Job不是孤立存在的，它需要执行的参数，这些参数如何传递进来呢？我们来定义一个Job类进行演示。

```
public class SayHelloJob : IJob
{
    public string UserName { get; set; }

    public Task Execute(IJobExecutionContext context)
    {
        return Task.Factory.StartNew(() =>
        {
            Console.WriteLine($"Hello {UserName}!");
        });
    }
}
```

`SayHelloJob`在执行时需要参数`UserName`，这个参数被称为JobData，`Quartz.Net`通过JobDataMap的方式传递参数。代码如下：

```
//创建作业
var jobDetail = JobBuilder.Create<SayHelloJob>()
                            .SetJobData(new JobDataMap() {
                                new KeyValuePair<string, object>("UserName", "Tom")
                            })
                            .Build();
```

通过JobBuilder的SetJobData方法，传入JobDataMap对象，JobDataMap对象中可以包含多个参数，这些参数可以映射到Job类的属性上。我们完善代码运行示例，可以看到如下图：

![SayHelloJob-Run](https://images.cnblogs.com/cnblogs_com/youring2/1487154/o_SayHelloJob-Run.png)

### JobDetail

JobDetail是Quartz对作业的封装，它包含Job类型，以及Job在执行时用到的数据，还包括是否孤立存储、请求恢复作业等选项。

JobDetail是通过JobBuilder进行创建的。例如：

```
var jobDetail = JobBuilder.Create<SayHelloJob>()
                            .SetJobData(new JobDataMap() {
                                new KeyValuePair<string, object>("UserName", "Tom")
                            })
                            .StoreDurably(true)
                            .RequestRecovery(true)
                            .WithIdentity("SayHelloJob-Tom", "DemoGroup")
                            .WithDescription("Say hello to Tom job")
                            .Build();
```

**参数说明：**

- SetJobData：设置JobData
- StoreDurably：孤立存储，指即使该JobDetail没有关联的Trigger，也会进行存储
- RequestRecovery：请求恢复，指应用崩溃后再次启动，会重新执行该作业
- WithIdentity：作业的唯一标识
- WithDescription：作业的描述信息

除此之外，`Quartz.Net`还支持两个非常有用的特性：

- DisallowConcurrentExecution：禁止并行执行，该特性是针对JobDetail生效的
- PersistJobDataAfterExecution：在执行完成后持久化JobData，该特性是针对Job类型生效的，意味着所有使用该Job的JobDetail都会在执行完成后持久化JobData。

### 持久化JobData

我们来演示一下该`PersistJobDataAfterExecution`特性，在`SayHelloJob`中，我们新加一个字段`RunSuccess`，记录任务是否执行成功。

首先在`SayHelloJob`添加特性：

```
[PersistJobDataAfterExecution]
public class SayHelloJob : IJob { }
```

然后在创建`JobDetail`时添加JobData：

```
var jobDetail = JobBuilder.Create<SayHelloJob>()
                            .SetJobData(new JobDataMap() {
                                new KeyValuePair<string, object>("UserName", "Tom"),
                                new KeyValuePair<string, object>("RunSuccess", false)
                            })
```

在执行时Job时，更新RunSuccess的值：

```
public Task Execute(IJobExecutionContext context)
{
    return Task.Factory.StartNew(() =>
    {
        Console.WriteLine($"Prev Run Success:{RunSuccess}");
        Console.WriteLine($"Hello {UserName}!");

        context.JobDetail.JobDataMap.Put("RunSuccess", true);
    });
}
```

接下来看一下执行效果：

![image](https://images.cnblogs.com/cnblogs_com/youring2/1487154/o_SayHelloJob-PersistData-Run.png)

## 触发器：Trigger

Trigger是触发器，用来定制执行作业。Trigger有两种类型：SampleTrigger和CronTrigger，我们分别进行说明。

### SampleTrigger

顾名思义，这是个简单的触发器，有以下特性：

- 重复执行：WithRepeatCount()/RepeatForever()
- 设置间隔时间：WithInterval()
- 定时执行：StartAt()/StartNow()
- 设定优先级：WithPriority()，默认为5

需要注意：当Trigger到达StartAt指定的时间时会执行一次，这一次执行是不包含在WithRepeatCount中的。在我们上面的例子中可以看出，添加调度后会立即执行一次，然后重复三次，最终执行了四次。

### CronTrigger

CronTrigger是通过Cron表达式来完成调度的。Cron表达式非常灵活，可以实现几乎各种定时场景的需要。

关于Cron表达式，大家可以移步 [Quartz Cron表达式](https://www.cnblogs.com/sunjie9606/archive/2012/03/15/2397626.html)

使用CronTrigger的示例如下：

```
var trigger = TriggerBuilder.Create()
                            .WithCronSchedule("*/1 * * * * ?")
                            .Build();
```

### 日历：Calendar

Calendar可以与Trigger进行关联，从Trigger中排出执行计划。例如你只希望在工作日执行作业，那么我们可以定义一个休息日的日历，将它与Trigger关联，从而排出休息日的执行计划。

Calendar示例代码如下：

```
var calandar = new HolidayCalendar();
calandar.AddExcludedDate(DateTime.Today);

await scheduler.AddCalendar("holidayCalendar", calandar, false, false);

var trigger = TriggerBuilder.Create()
                        .WithCronSchedule("*/1 * * * * ?")
                        .ModifiedByCalendar("holidayCalendar")
                        .Build();
```

在这个示例中，我们创建了HolidayCalendar日历，然后添加排除执行的日期。我们把今天添加到排除日期后，该Trigger今天将不会触发。

## 监听器：JobListeners/TriggerListeners/SchedulerListeners

监听器是`Quartz.Net`的另外一个出色的功能，它允许我们编写监听器达到在运行时获取作业状态、处理作业数据等功能。

### JobListener

JobListener可以监听Job执行前、执行后、否决执行的事件。我们通过代码进行演示：

```
public class MyJobListener : IJobListener
{
    public string Name { get; } = nameof(MyJobListener);

    public Task JobToBeExecuted(IJobExecutionContext context, CancellationToken cancellationToken = default)
    {
        //Job即将执行
        return Task.Factory.StartNew(() =>
        {
            Console.WriteLine($"Job: {context.JobDetail.Key} 即将执行");
        });
    }

    public Task JobExecutionVetoed(IJobExecutionContext context, CancellationToken cancellationToken = default)
    {
        return Task.Factory.StartNew(()=> {
            Console.WriteLine($"Job: {context.JobDetail.Key} 被否决执行");
        });
    }

    public Task JobWasExecuted(IJobExecutionContext context, JobExecutionException jobException, CancellationToken cancellationToken = default)
    {
        //Job执行完成
        return Task.Factory.StartNew(() =>
        {
            Console.WriteLine($"Job: {context.JobDetail.Key} 执行完成");
        });
    }
}
```

定义完成后，将`MyJobListener`添加到Scheduler中：

```
scheduler.ListenerManager.AddJobListener(new MyJobListener(), GroupMatcher<JobKey>.AnyGroup());
```

然后我们再运行程序，就可以看到Listener被调用了：

![image](https://images.cnblogs.com/cnblogs_com/youring2/1487154/o_JobListener-Execute.png)

通过图片可以看到，`JobToBeExecuted`和`JobWasExecuted`都被执行了，`JobExecutionVetoed`没有执行，那么如何触发`JobExecutionVetoed`呢？请继续阅读`TriggerListener`的演示。

### TriggerListener

TriggerListener可以监听Trigger的执行情况，我们通过代码进行演示：

```
public class MyTriggerListener : ITriggerListener
{
    public string Name { get; } = nameof(MyTriggerListener);

    public Task TriggerComplete(ITrigger trigger, IJobExecutionContext context, SchedulerInstruction triggerInstructionCode, CancellationToken cancellationToken = default)
    {
        return Task.CompletedTask;
    }

    public Task TriggerFired(ITrigger trigger, IJobExecutionContext context, CancellationToken cancellationToken = default)
    {
        return Task.CompletedTask;
    }

    public Task TriggerMisfired(ITrigger trigger, CancellationToken cancellationToken = default)
    {
        return Task.CompletedTask;
    }

    public Task<bool> VetoJobExecution(ITrigger trigger, IJobExecutionContext context, CancellationToken cancellationToken = default)
    {
        return Task.FromResult(true);   //返回true表示否决Job继续执行
    }
}
```

将`MyTriggerListener`添加到Scheduler中：

```
scheduler.ListenerManager.AddTriggerListener(new MyTriggerListener(), GroupMatcher<TriggerKey>.AnyGroup());
```

运行代码可以看到如下效果：

![image](https://images.cnblogs.com/cnblogs_com/youring2/1487154/o_TriggerListener-Execute.png)

从图片中可以看到，JobListener中的`JobExecutionVetoed`被执行了。

### SchedulerListener

ISchedulerListener提供了Job、Trigger管理的监听，与调度程序相关的事件包括：添加作业/触发器，删除作业/触发器，调度程序中的严重错误，调度程序关闭的通知等。完整的接口定义如下：

```
public interface ISchedulerListener
{
    Task JobAdded(IJobDetail jobDetail, CancellationToken cancellationToken = default);
    Task JobDeleted(JobKey jobKey, CancellationToken cancellationToken = default);
    Task JobInterrupted(JobKey jobKey, CancellationToken cancellationToken = default);
    Task JobPaused(JobKey jobKey, CancellationToken cancellationToken = default);
    Task JobResumed(JobKey jobKey, CancellationToken cancellationToken = default);
    Task JobScheduled(ITrigger trigger, CancellationToken cancellationToken = default);
    Task JobsPaused(string jobGroup, CancellationToken cancellationToken = default);
    Task JobsResumed(string jobGroup, CancellationToken cancellationToken = default);
    Task JobUnscheduled(TriggerKey triggerKey, CancellationToken cancellationToken = default);
    Task SchedulerError(string msg, SchedulerException cause, CancellationToken cancellationToken = default);
    Task SchedulerInStandbyMode(CancellationToken cancellationToken = default);
    Task SchedulerShutdown(CancellationToken cancellationToken = default);
    Task SchedulerShuttingdown(CancellationToken cancellationToken = default);
    Task SchedulerStarted(CancellationToken cancellationToken = default);
    Task SchedulerStarting(CancellationToken cancellationToken = default);
    Task SchedulingDataCleared(CancellationToken cancellationToken = default);
    Task TriggerFinalized(ITrigger trigger, CancellationToken cancellationToken = default);
    Task TriggerPaused(TriggerKey triggerKey, CancellationToken cancellationToken = default);
    Task TriggerResumed(TriggerKey triggerKey, CancellationToken cancellationToken = default);
    Task TriggersPaused(string triggerGroup, CancellationToken cancellationToken = default);
    Task TriggersResumed(string triggerGroup, CancellationToken cancellationToken = default);
}
```

添加SchedulerListener的代码如下：

```
scheduler.ListenerManager.AddSchedulerListener(mySchedListener);
```

## 持久化：JobStore

`Quartz.Net`支持Job的持久化操作，被称为JobStore。默认情况下，Quartz将数据持久化到内存中，好处是内存的速度很快，坏处是无法提供负载均衡的支持，并且在程序崩溃后，我们将丢失所有Job数据，对于企业级系统来说，坏处明显大于好处，因此有必要将数据存储在数据库中。

### ADO.NET存储

Quartz使用`ADO.NET`访问数据库，支持的数据库厂商非常广泛：

- SqlServer - .NET Framework 2.0的SQL Server驱动程序
- OracleODP - Oracle的Oracle驱动程序
- OracleODPManaged - Oracle的Oracle 11托管驱动程序
- MySql - MySQL Connector / .NET
- SQLite - SQLite ADO.NET Provider
- SQLite-Microsoft - Microsoft SQLite ADO.NET Provider
- Firebird - Firebird ADO.NET提供程序
- Npgsql - PostgreSQL Npgsql

数据库的创建语句可以在`Quartz.Net`的源码中找到：https://github.com/quartznet/quartznet/tree/master/database/tables

我们可以通过配置文件来配置Quartz使用数据库存储：

```
# job store
quartz.jobStore.type = Quartz.Impl.AdoJobStore.JobStoreTX, Quartz
quartz.jobStore.dataSource = quartz_store
quartz.jobStore.driverDelegateType = Quartz.Impl.AdoJobStore.PostgreSQLDelegate, Quartz
#quartz.jobStore.useProperties = true

quartz.dataSource.quartz_store.connectionString = Server=localhost;Database=quartz_store;userid=quartz_net;password=xxxxxx;Pooling=true;MinPoolSize=1;MaxPoolSize=10;Timeout=15;SslMode=Disable;
quartz.dataSource.quartz_store.provider = Npgsql
```

## 负载均衡

负载均衡是实现高可用的一种方式，当任务量变大以后，单台服务器很难满足需要，使用负载均衡则使得系统具备了横向扩展的能力，通过部署多个节点来增加处理Job的能力。

`Quartz.Net`在使用负载均衡时，需要依赖ADO JobStore，意味着你需要使用数据库持久化数据。然后我们可以使用以下配置完成负载均衡功能：

```
quartz.jobStore.clustered = true
quartz.scheduler.instanceId = AUTO
```

- clustered：集群的标识
- instanceId：当前Scheduler实例的ID，每个示例的ID不能重复，使用AUTO时系统会自动生成ID

当我们在多台服务器上运行Scheduler实例时，需要设置服务器的时钟时间，确保服务器时间是相同的。针对windows服务器，可以设置从网络自动同步时间。

## 通过Routing访问Quartz实例

通过Routing访问Quartz实例的功能，为我们做系统分离提供了很好的途径。

我们可以通过以下配置实现Quartz的服务器端远程访问：

```
# export this server to remoting context
quartz.scheduler.exporter.type = Quartz.Simpl.RemotingSchedulerExporter, Quartz
quartz.scheduler.exporter.port = 555
quartz.scheduler.exporter.bindName = QuartzScheduler
quartz.scheduler.exporter.channelType = tcp
quartz.scheduler.exporter.channelName = httpQuartz
```

然后我们在客户端系统中配置访问：

```
quartz.scheduler.proxy = true
quartz.scheduler.proxy.address = tcp://localhost:555/QuartzScheduler
```

## 开发实践

理想中的任务调度系统应该是一个后台服务，默无声息的运行在系统后台，业务系统通过接口完成对任务的添加、删除等操作。在构架Windows服务时，可以和TopShelf集成完成windows服务的开发。

```
Install-Package Topshelf
```

进行服务开发的另外一个问题是，Quartz本身是不支持依赖注入的，而解决依赖注入的问题，则可以使用Autofac，幸运的是已经有大神完成了TopShelf与Autofac的集成，我们只需要使用即可。

```
Install-Package Topshelf.Autofac
```

Quartz.Net Job的添加有两种方式：运行时动态添加和通过配置文件添加。这里推荐使用动态的方式进行添加（示例代码是采用动态方式进行添加的），除非你的Job是相对固定的。

而对Scheduler的配置可以采用配置文件的方式，方便在部署时进行维护。

## 参考资料

- [Quartz.Net官方文档](https://www.quartz-scheduler.net/documentation/quartz-3.x/tutorial/using-quartz.html)
- [Github：Quartz.Net源码](https://github.com/quartznet/quartznet)
- [Quartz Cron表达式](http://www.cnblogs.com/drubber/p/5845014.html)
- [SampleQuartz源码下载](https://github.com/qifei2012/sample_quartznet)

如果认为此文对您有帮助，别忘了支持一下哦！

**声明：**本博客原创文字只代表本人工作中在某一时间内总结的观点或结论，与本人所在单位没有直接利益关系。转载时请在文章页面明显位置给出原文链接。