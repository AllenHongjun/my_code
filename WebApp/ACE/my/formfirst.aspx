<%@ Page Title="" Language="C#" MasterPageFile="~/ACE/my/master/MasterAdmin.Master" AutoEventWireup="true" CodeBehind="formfirst.aspx.cs" Inherits="WebApp.ACE.my.formfirst" %>



<asp:Content ID="Content11" ContentPlaceHolderID="PageSpecificStylesPlugin" runat="server">
    <!-- page specific plugin styles -->
	<link rel="stylesheet" href="../components/_mod/jquery-ui/jquery-ui.css" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="InlineStyles" runat="server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="server">
    <form class="form-horizontal" role="form">

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1">发票性质 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1" placeholder="Username" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">发票抬头 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-1" placeholder="Text Field" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <!-- /section:elements.form -->
        <div class="space-4"></div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-2">发票内容 </label>

            <div class="col-sm-9">
                <input type="password" id="form-field-2" placeholder="Password" class="col-xs-10 col-sm-5" />
                <span class="help-inline col-xs-12 col-sm-7">
                    <span class="middle">Inline help text</span>
                </span>
            </div>
        </div>

        <div class="space-4"></div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-input-readonly">公司抬头 </label>

            <div class="col-sm-9">
                <input readonly="" type="text" class="col-xs-10 col-sm-5" id="form-input-readonly" value="This text field is readonly!" />
                <span class="help-inline col-xs-12 col-sm-7">
                    <label class="middle">
                        <input class="ace" type="checkbox" id="id-disable-check" />
                        <span class="lbl">禁用按钮</span>
                    </label>
                </span>
            </div>
        </div>

        <div class="space-4"></div>


        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right">注入日期带有图标</label>

            <div class="col-sm-9">
                <!-- #section:elements.form.input-icon -->
                <span class="input-icon">
                    <input type="text" id="form-field-icon-1" />
                    <i class="ace-icon fa fa-leaf blue"></i>
                </span>

                <span class="input-icon input-icon-right">
                    <input type="text" id="form-field-icon-2" />
                    <i class="ace-icon fa fa-leaf green"></i>
                </span>

                <!-- /section:elements.form.input-icon -->
            </div>
        </div>

        <div class="space-4"></div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-6">注入地址带有帮助图标</label>

            <div class="col-sm-9">
                <input data-rel="tooltip" type="text" id="form-field-6" placeholder="Tooltip on hover" title="Hello Tooltip!" data-placement="bottom" class="col-xs-10 col-sm-5"/>
                <span class="help-button" data-rel="popover" data-trigger="hover" data-placement="left" data-content="More details." title="Popover on hover">?</span>
            </div>
        </div>

        <div class="space-4"></div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-tags">输入生成标签</label>

            <div class="col-sm-9">
                <!-- #section:plugins/input.tag-input -->
                <div>
                    <input type="text" name="tags" id="form-field-tags" value="Tag Input Control" placeholder="Enter tags ..." class="col-xs-10 col-sm-5"　/>
                </div>

                <!-- /section:plugins/input.tag-input -->
            </div>
        </div>
        <div class="hr hr-24"></div>
        <%--注册信息开始--%>
        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">注册地址 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-2" placeholder="注册地址" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">注册电话 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-3" placeholder="注册地址" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">注册银行 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-４" placeholder="注册地址" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">银行账号 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-４" placeholder="注册地址" class="col-xs-10 col-sm-5" />
            </div>
        </div>
         <%--注册信息结束--%>

        <%--联系信息开始--%>
        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">联系地址 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-2" placeholder="注册地址" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">联系电话 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-3" placeholder="注册地址" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">联系银行 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-４" placeholder="注册地址" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1-1">联系账号 </label>

            <div class="col-sm-9">
                <input type="text" id="form-field-1-４" placeholder="注册地址" class="col-xs-10 col-sm-5" />
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1">财务备注</label>

            <div class="col-sm-9">
                <div class="clearfix">
                    <textarea id="txRemarks" cols="20" rows="2" runat="server" class="col-xs-10 col-sm-5" style="height:200px;"></textarea>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1">合计</label>

            <div class="col-sm-9">
                <div class="clearfix">
                    <textarea id="txTotal" cols="20" rows="2" runat="server" class="col-xs-10 col-sm-5" style="height:200px;"></textarea>
                </div>
            </div>
        </div>

        <div class="form-group example">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1">基本示例</label>

            <div class="col-sm-9">
                <div class="clearfix" id="basic-example">
                    <input  type="text" placeholder="请输入省份" class="col-xs-10 col-sm-5 typeahead">
                </div>
            </div>
        </div>


        <div class="form-group example">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1">基本示例</label>

            <div class="col-sm-9">
                <div class="clearfix" id="ajax-remote-example">
                     <input  type="text" placeholder="请输入城市" class="col-xs-10 col-sm-5 typeahead">
                </div>
            </div>
        </div>


        

        <%--UI组件的使用　一个一个有空闲玩一下　那个组件　
            有空再回头研究下 
            
            要复制那些东西--%>
        <%--<div class="form-group">
            <label class="col-sm-3 control-label no-padding-right" for="form-field-1">发票图片 </label>

            <div class="col-xs-9 col-sm-11">
                <div id="wrap">
                    <div id="container">
                        <!--头部，相册选择和格式选择-->
                        <div id="uploader" class="uploader">
                            <input type="hidden" name="name" value="" />
                            <div class="queueList">
                                <div class="dndArea placeholder">
                                    <div class="filePicker"></div>
                                    <p>或将照片拖到这里，单次最多可选300张</p>
                                </div>
                            </div>
                            <div class="statusBar" style="display: none;">
                                <div class="progress">
                                    <span class="text">0%</span>
                                    <span class="percentage"></span>
                                </div>
                                <div class="info"></div>
                                <div class="btns">
                                    <div class="filePicker2"></div>
                                    <div class="uploadBtn">开始上传</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>--%>

         <%--联系信息结束--%>
        <div class="clearfix form-actions">
            <div class="col-md-offset-3 col-md-9">
                <button class="btn btn-info" type="button">
                    <i class="ace-icon fa fa-check bigger-110"></i>
                    提交按钮
                </button>

                &nbsp; &nbsp; &nbsp;
                <button class="btn" type="reset">
                    <i class="ace-icon fa fa-undo bigger-110"></i>
                    重置按钮
                </button>
            </div>
        </div>


    </form>
    <div class="hr hr-24"></div>



</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageSpecificPlugin" runat="server">
    <script src="../../Scripts/typeahead.jquery.js"></script>
    <script src="../../Scripts/typeahead.bundle.min.js"></script>
</asp:Content>   


<asp:Content ID="Content3" ContentPlaceHolderID="InlineScripts" runat="server">


    <script>
        //自动不全  

        jQuery(function () {
            /*** 1.基本示例 ***/
            var provinces = ["广东省", "海南省", "山西省", "山东省","湖北省", "湖南省", "陕西省", "上海市", "北京市", "广西省"];

            var substringMatcher = function (strs) {
                return function findMatches(q, cb) {
                    var matches, substrRegex;
                    matches = [];//定义字符串数组
                    substrRegex = new RegExp(q, 'i');
                    //用正则表达式来确定哪些字符串包含子串的'q'
                    $.each(strs, function (i, str) {
                    //遍历字符串池中的任何字符串
                        if (substrRegex.test(str)) {
                            matches.push({ value: str });
                        }
                    //包含子串的'q',将它添加到'match'
                    });
                    cb(matches);
                };
            };

            $('#basic-example .typeahead').typeahead({
                highlight: true,
                minLength: 1
            },
            {
                name: 'provinces',
                displayKey: 'value',
                source: substringMatcher(provinces)
            });



                /*** 3.Ajax及时获取数据示例 点击才会触发事件 ***/
                //远程数据源
                var remote_cities = new Bloodhound({
                    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('CityName'),
                    queryTokenizer: Bloodhound.tokenizers.whitespace,
                    // 在文本框输入字符时才发起请求
                    remote: 'GetCities.aspx?q=%QUERY'
                });
                remote_cities.initialize();
                $('#ajax-remote-example .typeahead').typeahead({
                    hint: true,
                    highlight: true,
                    minLength: 1
                }, 
                {
                    name: 'cities',
                    displayKey: 'CityName',
                    source: remote_cities.ttAdapter(),
                });

         });
        
        /*
            接口：
            name —— 数据集的名字。
            source —— 规定包含查询时要显示的值的数据源。值的类型是 array，默认值是 [ ]。
            items —— 规定查询时要显示的条目的最大值。数据类型是 number，默认值是 8。
            highlighter —— 用于自动高亮突出显示结果。带有一个单一的参数，即具有 typeahead 实例范围的条目。数据类型是 function。默认情况下是高亮突出显示所有默认的匹配项。
            minLength —— 推荐引擎开始渲染所需要的最小字符。默认为 1 。
            hint —— 默认为 true,会自动补全第一个匹配的元素，设置为 false 时，typeahead 将不会补全 .
            display - 对于推荐对象，决定用何种字符串表示，并将会在某个输入控件选择后使用。其值可以是关键字符串，或者是将推荐对象转换为string的函数。默认为 value.
            $('.typeahead').typeahead('destroy');移除typeahead功能，并将 input 元素的状态重置为原始状态。
            $('.typeahead').typeahead('open');打开typeahead下拉菜单。 
            $('.typeahead').typeahead('close');关闭typeahead的下拉菜单。
            var myVal = $('.typeahead').typeahead('val'); 返回typeahead的当前值，该值为用户输入到 input 元素中的文本
            $('.typeahead').typeahead('val', myVal);设置typeahead的值，要来替代 jQuery#val 函数。

        */
    </script>
</asp:Content>
