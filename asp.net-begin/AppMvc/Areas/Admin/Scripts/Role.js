$(function () {
    //$("#addDiv").css("display", "none");
    //$("#editDiv").css("display", "none");
    //给搜索按钮加一个单击事件
    //$("#txtBeginTime").datebox({ 'value': '3/4/2010' });

    $("#btnSearch").click(function() {
        //获取用户输入的搜索数据.

       
        var pars = {
            name: $("#txtSearchName").val(),
            beginTime: $("#txtBeginTime").datebox('getValue'),
            endTime: $("#txtEndTime").datebox("getValue"),
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
        url: '/Admin/RoleInfo/GetRoleInfoList',
        title: '角色管理表格',
        width: '95%',
        height: '400px',
        fitColumns: true, //列自适应
        nowrap: false,
        idField: 'ID', //主键列的列明
        loadMsg: '正在加载角色的信息...',
        pagination: true, //是否有分页
        singleSelect: true, //是否单行选择
        pageSize: 10, //页大小，一页多少条数据
        pageNumber: 1, //当前页，默认的
        pageList: [10, 15, 50, 100],
        queryParams: pars, //往后台传递参数
        columns: [
            [//c.UserName, c.UserPass, c.Email, c.RegTime
                //{ field: 'ck', checkbox: true, align: 'left', width: 50 },
                { field: 'ID', title: '编号', width: 30 },
                { field: 'RoleName', title: '角色名称', width: 90 },
                { field: 'RoleType', title: '角色类型', width: 30 },
                { field: 'Remark', title: '备注', width: 100 },
                {
                    field: 'SubTime',
                    title: '修改时间',
                    width: 80,
                    align: 'right',
                    formatter: function (value, row, index) {
                        return moment(value).format("YYYY-MM-DD, h:mm:ss");
                    }
                }
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
            }, {
                id: 'btnSetRoleAction',
                text: '分配权限',
                iconCls: 'icon-edit',
                handler: function() {

                    showRoleAction();
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
            $.post("/Admin/RoleInfo/Delete",
                { "id": strId },
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
    $.post("/Admin/RoleInfo/Detail", { "id": id }, function (res) {
       
        var data = res.data;
        $("#txtRoleName").textbox({ "value": data.RoleName });
        $("#txtRemark").textbox({ "value": data.Remark });
        $('#txtRoleType').combobox('setValue', String(data.RoleType));
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


//为角色分配权限
function showRoleAction() {
    //判断是否选择了一个角色.
    var rows = $('#tt').datagrid('getSelections');//获取所选择的行
    if (rows.length !== 1) {
        $.messager.alert("提示", "请选择要分配权限的角色", "error");
        return;
    }
    //指定iframe的src.
    $("#setActionFrame").attr("src", "/Admin/RoleInfo/ShowRoleAction/?id=" + rows[0].ID);
    $("#setActionDiv").css("display", "block");
    $('#setActionDiv').dialog({
        title: '为角色分配权限',
        width: 720,
        height: 420,
        collapsible: true,
        maximizable: true,
        resizable: true,
        modal: true,
        buttons: [{
            text: 'Ok',
            iconCls: 'icon-ok',
            handler: function () {
                //提交表单
                //调用子窗口的方法.
                var childWindow = $("#setActionFrame")[0].contentWindow;//表示获取了嵌入在iframe中的子窗体的window对象。
                childWindow.subForm();//调用子窗体中的方法，完成表单的提交。
            }
        }, {
            text: 'Cancel',
            handler: function () {
                $('#setActionDiv').dialog('close');
            }
        }]
    });
}
//为角色分配完成权限后调用该方法
function afterSet(data) {
    if (data === "ok") {
        $('#setActionDiv').dialog('close');
    }
}