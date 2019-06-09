;(function() {
    


}) ();

//代码
$(function () {
    //给搜索按钮加一个单击事件
    $("#btnSearch").click(function () {
        //获取用户输入的搜索数据.
        //var pars = {
        //    name: $("#txtSearchName").val()
        //};

        $('#tt').datagrid('load', {
            name: $("#txtSearchName").val()
        });
        console.log(pars);
        //return;
        //将获取的搜索的数据发送到服务端。
        //loadData(pars);
    });
    //loadData();

    $("#btnAdd").click(function () {
        addInfo();
    });

    $("#btnEdit").click(function () {
        showEditInfo();
    });
    $("#btnRemove").click(function () {
        deleteInfo();
    });


});




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
                strId += rows[i].Id + ",";
            }
            strId = strId.substr(0, strId.length - 1);
            $.post("/Admin/Category/Delete",
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
    var id = rows[0].Id;
    $.post("/Admin/Category/Detail", { "id": id }, function (res) {
       
        var data = res.data;
        $("#txtCategoryName").textbox({ "value": data.Name });
       
        //$("#txtRegTime").val(ChangeDateFormat(data.RegTime));
        $("#txtID").val(data.Id);
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
