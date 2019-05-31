<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebApp.Pages.webform.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <style>

        .red{
            font-size:18px;
            color:red;
        }
    </style>
</head>
<body>
    <%--用户量不多
        很着急
        开发效率快

        所有控件的都有的属性
        服务端执行 生成对应的html的标签

        ClientID 客户端ID
        客户端ID和 服务端的ID是不一样的

        
        aspx 中的页面不用编译 也能执行


        一些服务端控件的使用 
        知道如何使用就可以了
        不用管他的原理是什么  就是 放到viewStae里面把请求发送到服务端
        --%>
    <form id="form1" runat="server">

        <asp:Calendar ID="Calendar1" runat="server"></asp:Calendar>


        <div>

            <asp:Panel ID="Panel1" runat="server">

                一些文字。。嵌套的在其他的标签的使用
            </asp:Panel>

        </div>


        <div>

            <%--value值  text生成的值  会把选中值提交给服务端
                radio dropDownList checkbox 
                下拉框 单选框  多选框 对应的html的标签
                设置成 需要的样式 和ace的模板结合
                这个框 这个控件 其实就是一个类底层帮你new出来
                可以在页面中获取这个对象实例的各种 属性 封装好的各种属性
                各种事件 会帮你发送请求到服务端 然后服务端重新 处理好之后
                设置了属性的值。重新渲染了页面 返回客户端
                之前使用控件写好的功能修改
                一些常用属性 和事件 知道如何使用 

                什么事件发生了 修改什么属性的值 
                反正都是服务端的控件 不是服务端控件 
                获取这个对象 . 出他的属性 修改一下

                添加的控件的事件 也会帮你 在客户端生成对应的 
                js的事件。 
                更多时候 知识作为一个模板引擎 渲染数据使用
                事件 用的还是比价少

                他会帮你自动找到对应事件的方法


                
                --%>
            <asp:DropDownList ID="DropDownList1" runat="server" OnTextChanged="DropDownList1_TextChanged" AutoPostBack="true" > 
                <asp:ListItem Text="北京"  Selected="True" Value="1"/>
                <asp:ListItem Text="上海"   Value="2"/>
                <asp:ListItem Text="南京"  Value="3"/>
                <asp:ListItem Text="金华"  Value="4"/>
            </asp:DropDownList>



            <%--GroupName 会生成name属性值
                服务端控件 就按照控件的做法来使用

                习惯一下 使用winform开发这种模式 属性 方法 和时间 
                回头在学习唐大仕 到老师winform的课程 先不管他的样式 

                首先 这些代码 可以让你在C#中完成 选中事件 文字修改事件 
                按钮提交事件 事件发生的时候 你想处理的事情。就在事件的代码里面处理就可以了

                // js里面的代码 他都帮你分装好了 很多是混和的来编程的
                //控件 属性 后台点出来 打一个空格就可以选择 测试  事件 就双击一下 就可以了
                //在看视频 看看别人是如何使用的
                表单提交 就是 按钮点击  获取 Checkbox 选中的值 。

                从另外一种开发方式来理解。 常用的一些事件的处理。
                所有的事件都会__dopostBack 发送一个请求到服务端来处理
                然后页面后面可以 可以获得这个对象 然后就可以处理 你想处理的事情了
                注意一下 需要什么事件 设置什么属性
                适合网站后台数据展示的开发
                --%>
            <asp:RadioButton ID="RadioButton3" runat="server" GroupName="Sex" Text="男" OnCheckedChanged="RadioButton3_CheckedChanged"  AutoPostBack="true"/>
            <asp:RadioButton ID="RadioButton2" runat="server" GroupName="Sex" Text="女"/>
            <asp:RadioButtonList ID="RadioButtonList1" runat="server"></asp:RadioButtonList>

        </div>

        <div>
            <%=TextBox1.ClientID %>
            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>

            <asp:Button ID="Button1" runat="server" Text="Button" />

            <asp:TextBox ID="TextBox2" runat="server" Visible="false"></asp:TextBox>

            <asp:Label ID="Label1" runat="server" Text="Label" CssClass="red">
                生成了一个span标签
                CssClas 生成了 class属性</asp:Label>

            <asp:button runat="server" ID="Button2" Text="这是一个按钮" />



            <br />
            <hr />

            <%--点击label 按钮就可以选中文本输入框
                
                21天精通C# 学了很多天 都没有明白
                --%>
            <asp:TextBox ID="TextBox3" runat="server"></asp:TextBox>
            <asp:Label ID="Label2" runat="server" Text="Label" AssociatedControlID="TextBox3"></asp:Label>

            <hr />
            <asp:CheckBox ID="CheckBox1" runat="server"  Text="男"/>
            <asp:Label ID="Label3" runat="server" Text="Label" AssociatedControlID="CheckBox1"></asp:Label>




        </div>

        <div>
            <%--TextMode 的格式 文本框属性  可以类似winform来开发 winform能理解好的话 就更好的理解
                就当做winform 一样的使用 winform的控件 你也不会去管他是怎么 封装

                05 06 asp asp.net 刚出来 15 16 10之后

                __doPostBack 会提交表单

                服务端你控件 

                表单元素必须放在 form 控件里面 大部分的时候都要放在 form表单元素的控件当中

                gridView

                --%>
            <asp:TextBox AutoPostBack="true" ID="TextBox4" runat="server" Height="266px" TextMode="Email" Width="424px" OnTextChanged="TextBox4_TextChanged"></asp:TextBox>


            <asp:RadioButton ID="RadioButton1" runat="server" />



            <%--类型“RadioButton”的控件“RadioButton2”必须放在具有 runat=server 的窗体标记内。--%>
        </div>
    </form>
    <%--<asp:RadioButton ID="RadioButton2" runat="server" />--%>


    <asp:Table ID="Table1" runat="server"></asp:Table>


    <asp:Repeater ID="Repeater1" runat="server"></asp:Repeater>


    <%--<asp:GridView ID="GridView1" runat="server"></asp:GridView>--%>


</body>
</html>

