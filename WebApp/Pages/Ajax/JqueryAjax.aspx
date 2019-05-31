<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JqueryAjax.aspx.cs" Inherits="WebApp.Pages.Ajax.JqueryAjax" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <script src="../../Scripts/jquery-3.4.1.js"></script>

    <script type="text/javascript">
        $(function () {
            $("#btnGet").click(function () {
                //把你请求的内容 转化为了查询字符串
                //需要的是把请求 是json格式的发送给服务单端
                $.get("GetDate.ashx", { "name": "lisi", "pwd": "123" },
                    function (data) {
                        alert(data);
                    });
                //如何设置请求的格式 就是api的使用
            })

            //Content-Type: application/x-www-form-urlencoded; charset=UTF-8

            //会帮你把数据对象转化 name=name&pwd=123 
            //如果是一个对象的话这样是不行的 默认会拼接字符串的形式发送数据
            //一个点没有处理好就是 name[name]=王五&name[pwd]=赵柳&pwd=123
            // Content-Type: application/json; 这个就不能用$.post
            $("#btnPost").click(function () {
                var data = {
                    "name": { "name": "王五", "pwd": "赵柳" },
                    "pwd": "123"
                };

                $.post("ShowDate.aspx", data,
                    function (data) {
                        alert(data);

                    })
            })

            $("#btnAJAX").click(function () {
                var postData = {
                    "name": { "name": "王五", "pwd": "赵柳" },
                    "pwd": "123"
                };
                //发送json数据就需要发json对象序列化一个字符串才可以
                $.ajax({
                    type: "POST",
                    url: "GetDate.ashx",
                    data: JSON.stringify(postData),
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        alert(data);
                    }
                })

            })


            $("#btnSend").click(function() {
                $("#request-process-patent").html("正在提交数据，请勿关闭当前窗口...");
                $.ajax({
                    type: "POST",
                    url: "RequestData.ashx",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify(GetJsonData()),
                    dataType: "json",
                    success: function (message) {
                        if (message > 0) {
                            alert("请求已提交！我们会尽快与您取得联系");
                        }
                    },
                    error: function (message) {
                        $("#request-process-patent").html("提交数据失败！");
                    }
                });
            });

            function GetJsonData() {
                var json = {
                    "classid": 2,
                    "name": $("#tb_name").val(),
                    "zlclass": "测试类型1,测试类型2,测试类型3",
                    "pname": $("#tb_contact_people").val(),
                    "tel": $("#tb_contact_phone").val()
                };
                return json;
            }

        })


    </script>
</head>
<body>

    <%--使用jquery来发送ajax请求--%>
    <form id="form1" runat="server">
        <div>
            <input type="button" name="" value="Get获取数据" id="btnGet" />
            <input type="button" name="" value="POST获取数据" id="btnPost" />
            <input type="button" value="AJAX获取数据" id="btnAJAX" />
        </div>
    </form>
</body>
</html>
