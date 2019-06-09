
$(function () {
    //$("#addDiv").css("display", "none");
    //$("#editDiv").css("display", "none");
    //给搜索按钮加一个单击事件
    $("#btnSearch").click(function () {
        //获取用户输入的搜索数据.
        var pars = {
            name: $("#txtSearchName").val(),
            remark: $("#txtSearchRemark").val()
        };
        //将获取的搜索的数据发送到服务端。
        loadData(pars)
    });
    loadData();

    $('.easyui-combobox').combobox({
        url: '/Admin/UserInfo/GetRoleInfo',
        valueField: 'ID',
        textField: 'RoleName'
    });

});

//加载数据的方法
function loadData(pars) {
    $('#tt').datagrid({
        url: '/Admin/UserInfo/GetUserInfoList',
        title: '用户数据表格',
        width: '95%',
        height: '400px',
        fitColumns: true, //列自适应
        nowrap: false,
        idField: 'ID',//主键列的列明
        loadMsg: '正在加载用户的信息...',
        pagination: true,//是否有分页
        singleSelect: true,//是否单行选择
        pageSize: 10,//页大小，一页多少条数据
        pageNumber: 1,//当前页，默认的
        pageList: [10, 15, 50, 100],
        queryParams: pars,//往后台传递参数
        columns: [[//c.UserName, c.UserPass, c.Email, c.RegTime
            //{ field: 'ck', checkbox: true, align: 'left', width: 50 },
            { field: 'ID', title: '编号', width: 80 },
            { field: 'UName', title: '姓名', width: 120 },
            { field: 'UPwd', title: '密码', width: 120 },
            { field: 'Remark', title: '备注', width: 120 },
            {
                field: 'SubTime', title: '时间', width: 80, align: 'right',
                formatter: function (value, row, index) {
                    //return (eval(value.replace(/\/Date\((\d+)\)\//gi, "new Date($1)"))).pattern("yyyy-M-d");
                }
            }
        ]],
        toolbar: [{
            id: 'btnDelete',
            text: '删除',
            iconCls: 'icon-remove',
            handler: function () {
                //点击删除按钮要执行的操作
                //前后端分离
                //如果做 手机版 要做的前后端分离 是要用到的技术 合适的技术 使用合适的地方
                deleteInfo();
            }
        }
            ,
        {
            id: 'btnAdd',
            text: '添加',
            iconCls: 'icon-add',
            handler: function () {

                addInfo();
            }
        }
            ,
        {
            id: 'btnEidt',
            text: '编辑',
            iconCls: 'icon-edit',
            handler: function () {

                showEditInfo();
            },
        }
            ,
        {
            id: 'btnSetUserRole',
            text: '分配角色',
            iconCls: 'icon-edit',
            handler: function () {

                showSetUserRoleInfo();
            }
        }
            ,
        {
            id: 'btnSetUserAction',
            text: '分配权限',
            iconCls: 'icon-edit',
            handler: function () {

                showSetUserActionInfo();
            }
        }
        ],
    });
}


//为用户分配权限
function showSetUserActionInfo() {
    //判断一下用户是否选择了要修改的数据
    var rows = $('#tt').datagrid('getSelections');//获取所选择的行
    if (rows.length !== 1) {
        $.messager.alert("提示", "请选择要分配权限的用户", "error");
        return;
    }
    $("#setUserActionFrame").attr("src", "/Admin/UserInfo/ShowUserAction/?userId=" + rows[0].ID);
    $("#setUsrActionDiv").css("display", "block");
    $('#setUsrActionDiv').dialog({
        title: '分配权限',
        width: 650,
        height: 500,
        collapsible: true,
        maximizable: true,
        resizable: true,
        modal: true,
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function () {
                //点击确定也是关闭窗口
                $('#setUsrActionDiv').dialog('close');
            }
        }, {
            text: '取消',
            handler: function () {
                $('#setUsrActionDiv').dialog('close');
            }
        }]
    });
}


//为用户配置角色.
function showSetUserRoleInfo() {
    //判断一下用户是否选择了要修改的数据
    var rows = $('#tt').datagrid('getSelections');//获取所选择的行
    if (rows.length !== 1) {
        $.messager.alert("提示", "请选择要分配角色的用户", "error");
        return;
    }
    $("#setUserRoleFrame").attr("src", "/Admin/UserInfo/ShowUserRoleInfo/?id=" + rows[0].ID);
    $("#setUsrRoleDiv").css("display", "block");
    $('#setUsrRoleDiv').dialog({
        title: '分配角色',
        width: 450,
        height: 480,
        collapsible: true,
        maximizable: true,
        resizable: true,
        modal: true,
        buttons: [{
            text: 'Ok',
            iconCls: 'icon-ok',
            handler: function () {
                console.log(3);
                var childWindow = $("#setUserRoleFrame")[0].contentWindow;
                childWindow.subForm();
            }
        }, {
            text: 'Cancel',
            handler: function () {
                $('#setUsrRoleDiv').dialog('close');
            }
        }]
    });
}
//为用户分配完成角色以后调用的方法。

//准备这个项目重构改版。。jquery easy ui的文档。。一些组件的文档 查阅 资料
function afterSetUserRole(data) {
    if (data.code === 1) {
        $('#setUsrRoleDiv').dialog('close');
    }

}
//客户端的业务逻辑判断 EasyUI的组件的使用 非常适合后台开发
//UI组件 一套已经全部都是有了 批量删除用户信息 一套的每一个点都是要知道 有一个点不知道就会卡组
//js程序的作用于 程序的运行 执行顺序 问题
function deleteInfo() {
    //获取选中了哪一行 可以去查看手册 查看官方文档 测试一
    var rows = $("#tt").datagrid("getSelections");

    if (!rows || rows.length === 0) {
        $.messager.alert("提醒", "请选择要删除的记录！", "error");
        return false;
    }
    //判断是否选中了那一行 选中了几行


    //弹出提示提示框是否要删除数据
    $.messager.confirm("提示", "确定要删除数据吗?", function (r) {

        //r是提示框的返回
        if (r) {
            //将要删除的数据
            //拼接 1，2，3，4，5，6 字符串拼接 处理数据
            //不是你想想的那么简单的 做一遍
            var rowsLength = rows.length;
            var strId = "";
            for (var i = 0; i < rowsLength; i++) {
                strId += rows[i].ID + ",";
            }
            console.log(strId);
            //一个函数的用户就要查一下手册了又是一个点这么多的函数使用
            //其实是很好理解的 就是讲最后一个字符串截取掉
            //不要纠结于哪个语言  那种技术
            console.log(strId.length);

            strId = strId.substr(0, strId.length - 1);
            console.log(strId.length);

            //application/x-www-form-urlencod 默认的表单提交的方式
            //有些东西 就是都已经帮你处理好了

            //这个还是比较基础的版本 你要做的比较完善的话 肯定还是有一些效果 东西可以做可以添加的
            //挺不错的列表 增加 修改 批量删除  基本上代码 都是一行一行 有敲过的。这个感觉确实是不太一样。
            $.post("/Admin/UserInfo/DeleteUserInfo",
                { "strId": strId },
                function (data) {
                    if (data === "ok") {
                        //表格重新加载
                        //就还可以继续封装
                        $("#tt").datagrid("reload");
                        $("#tt").datagrid("clearSelections");
                    } else {
                        $.messager.alert("提示", "删除记录失败！！", "error");
                    }
                });


        }


    });

    //发送请求 要删除

    //删除成功提示 删除失败提示

    //其他更加新的前端框架的使用

    //多表的复杂的业务逻辑的使用


}


//添加数据
function addInfo() {
    $("#addDiv").css("display", "block");
    $('#addDiv').dialog({
        title: '添加用户数据',
        width: 400,
        height: 320,
        collapsible: true,
        maximizable: true,
        resizable: true,
        modal: true,
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function () {
                //表单校验  这里表单验证如果不通过就会返回结束方法继续往下执行
                //如果
                //validateInfo($("#addForm"));

                //unobtrusive-ajax 使用了这个插件来帮助我们ajax提交表单 z
                //可以结合asp.net  mvc 帮助我们更加容易的完成任务
                //前端校验

                //此处修改使用EASY ui自带的表单验证 不然的话使用 easy的控件的时候 会修改input 无法使用表单验证插件
                var isValidate = $("#addForm").form('validate');
                if (isValidate) {
                    $("#addForm").submit();//提交表单
                }

            }
        }, {
            text: '取消',
            handler: function () {
                $('#addDiv').dialog('close');
            }
        }]
    });

}




//完成添加后调用该方法
function afterAdd(data) {
    if (data === "ok") {
        $('#addDiv').dialog('close');
        $('#tt').datagrid('reload');//加载表格不会跳到第一页。
        $("#addForm input").val("");
    }
    if (data === "fail") {
        //使用一个好看点样式框 弹出服务端给出的错误提示
        alert("数据添加失败");
    }
}


//表单校验
//function validateInfo(control) {
//    console.log("Begin-Validate");
//    control.validate({//表示对哪个form表单进行校验，获取form标签的id属性的值
//        rules: {//表示验证规则
//            UName: "required",//表示对哪个表单元素进行校验，要写具体的表单元素的name属性的值
//            Remark: {
//                required: true
//            },
//            UPwd: {
//                required: true,
//                minlength: 5
//            },
//            Sort: {
//                required: true
//            }
//        },
//        messages: {
//            UName: "请输入用户名",
//            Remark: {
//                required: "请输入备注"
//            },
//            UPwd: {
//                required: "请输入密码",
//                minlength: "密码不能小于{0}个字 符"
//            },
//            Sort: {
//                required: "请输入排序"
//            }
//        }
//    });
//}


//

//展示一下要修改的数据.


function showEditInfo() {
    //判断一下用户是否选择了要修改的数据
    var rows = $('#tt').datagrid('getSelections');//获取所选择的行
    if (rows.length !== 1) {
        $.messager.alert("提示", "请选择一条要修改的数据", "error");
        return;
    }
    //将要修改的数据查询出来，显示到文本框中。

    //有些东西是没有办法 必须一步一步的走一点一点的做的
    var id = rows[0].ID;
    $.post("/Admin/UserInfo/ShowEditInfo", { "id": id }, function (data) {
        console.log(data);
        $("#txtUserName").textbox({ "value": data.UserName });
        $("#txtUserPass").textbox({ "value": data.UserPass });
        $("#txtEmail").textbox({ "value": data.Email });
        $("#txtSort").textbox({ "value": 99 });
        $("#txtRegTime").val(ChangeDateFormat(data.RegTime));
        $("#txtId").val(data.ID);
    });
    $("#editDiv").css("display", "block");
    $('#editDiv').dialog({
        title: '编辑用户数据',
        width: 430,
        height: 600,
        collapsible: true,
        maximizable: true,
        resizable: true,
        modal: true,
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function () {
                //表单校验
                //validateInfo($("#editForm"));
                var isValidate = $("#editForm").form("validate");
                if (isValidate) {
                    $("#editForm").submit();//提交表单
                }
            }
        }, {
            text: '取消',
            handler: function () {
                $('#editDiv').dialog('close');
            }
        }]
    });
}

function beforeEdit() {
    //$('#editDiv').dialog('close');
}

//更新以后调用该方法.
function afterEdit(data) {
    if (data === "ok") {
        $('#editDiv').dialog('close');
        $('#tt').datagrid('reload');//加载表格不会跳到第一页。
    } else {
        $.messager.alert("提示", "修改的数据失败", "error");
    }
}
//将序列化成json格式后日期(毫秒数)转成日期格式
function ChangeDateFormat(cellval) {
    var date = new Date(parseInt(cellval.replace("/Date(", "").replace(")/", ""), 10));
    var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
    var currentDate = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
    return date.getFullYear() + "-" + month + "-" + currentDate;
}



