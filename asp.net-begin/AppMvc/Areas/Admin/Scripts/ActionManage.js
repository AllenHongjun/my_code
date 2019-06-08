$(function () {
    //$("#addDiv").css("display", "none");
    //$("#editDiv").css("display", "none");
    //给搜索按钮加一个单击事件
    $("#btnSearch").click(function () {
        //获取用户输入的搜索数据.
        var pars = {
            name: $("#txtSearchName").val(),
            remark: $("#txtSearchRemark").val(),
            beginTime: $("#txtBeginTime").datebox('getValue'),
            endTime: $("#txtEndTime").datebox("getValue"),
            isMenu: $("#searchIsMenu").combobox("getValue")
        };
        console.log(pars);
        //return;
        //将获取的搜索的数据发送到服务端。
        loadData(pars);
    });
    loadData();


});

//加载数据的方法
function loadData(pars) {
    $('#tt').datagrid({
        url: '/Admin/ActionInfo/GetActionList',
        title: '用户数据表格',
        width: '95%',
        height: '400px',
        fitColumns: true, //列自适应
        nowrap: false,
        idField: 'ID', //主键列的列明
        loadMsg: '正在加载用户的信息...',
        pagination: true, //是否有分页
        singleSelect: false, //是否单行选择
        pageSize: 10, //页大小，一页多少条数据
        pageNumber: 1, //当前页，默认的
        pageList: [10, 15, 50, 100],
        queryParams: pars, //往后台传递参数
        columns: [
            [//c.UserName, c.UserPass, c.Email, c.RegTime
                //{ field: 'ck', checkbox: true, align: 'left', width: 50 },
                { field: 'ID', title: '编号', width: 30 },
                { field: 'ActionInfoName', title: '权限名称', width: 90 },
                { field: 'Menu', title: '菜单权限', width: 30 },
                { field: 'Url', title: '权限地址', width: 140 },
                { field: 'HttpMethod', title: '请求方式', width: 50 },
                {
                    field: 'SubTime',
                    title: '时间',
                    width: 80,
                    align: 'right',
                    formatter: function (value, row, index) {
                        return moment(value).format("YYYY-MM-DD, h:mm:ss");
                    }
                },
                //{
                //    field: 'operation',
                //    title: '操作',
                //    width: 80,
                //    align: 'right',
                //    formatter: function (value, row, index) {
                //        console.log(123);
                //        var htmlGourp =
                //            "<a onclick= EditInfo(" + value + ")  class='easyui-linkbutton icon-edit' data-options='plain: true',  iconCls='icon-edit' plain='true'>   </a>" +
                //            "<a class='easyui-linkbutton icon-delete' iconCls='icon-delete' plain='true'></a>";
                //        console.log(htmlGourp);
                //        return htmlGourp;
                //    }
                //}
            ]
        ],
        toolbar: [
            {
                id: 'btnDelete',
                text: '删除',
                iconCls: 'icon-remove',
                handler: function () {
                    //点击删除按钮要执行的操作
                    //前后端分离
                    //如果做 手机版 要做的前后端分离 是要用到的技术 合适的技术 使用合适的地方
                    deleteInfo();
                }
            },
            {
                id: 'btnAdd',
                text: '添加',
                iconCls: 'icon-add',
                handler: function () {

                    addInfo();
                }
            },
            {
                id: 'btnEidt',
                text: '编辑',
                iconCls: 'icon-edit',
                handler: function () {

                    showEditInfo();
                }
            }
        ]
    });
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
            
            var rowsLength = rows.length;
            var strId = "";
            for (var i = 0; i < rowsLength; i++) {
                strId += rows[i].ID + ",";
            }
            strId = strId.substr(0, strId.length - 1);
            $.post("/Admin/ActionInfo/Delete",
                { "ids": strId },
                function (data) {
                    console.log(data);
                    if (data.code === 1) {
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
    if (data.code === 1) {
        $('#addDiv').dialog('close');
        $('#tt').datagrid('reload');//加载表格不会跳到第一页。
        $("#addForm input").val("");
    }
    if (data.code === -1) {
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
    $.post("/Admin/ActionInfo/Detail", { "id": id }, function (res) {
       
        var data = res.data;
        $("#txtActionInfoName").textbox({ "value": data.ActionInfoName });
        $("#txtUrl").textbox({ "value": data.Url });
        $("#txtRemark").textbox({ "value": data.Remark });
        $("#txtHttpMethod").textbox({ "value": data.HttpMethod });

        $('#txtHttpMethod').combobox('setValue', data.HttpMethod);
        $('#txtHttpMethod').combobox('setValue', data.HttpMethod);
        console.log(data.IsMenu);
        $('#txtIsMenu').combobox('setValue', String(data.IsMenu));
        //$("#txtRegTime").val(ChangeDateFormat(data.RegTime));
        $("#txtID").val(data.ID);
    });
    $("#editDiv").css("display", "block");
    $('#editDiv').dialog({
        title: '编辑权限数据',
        width: 430,
        height: 400,
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

//更新以后调用该方法.
function afterEdit(data) {
    if (data.code === 1) {
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
