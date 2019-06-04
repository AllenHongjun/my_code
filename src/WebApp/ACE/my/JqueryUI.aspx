<%@ Page Title="" Language="C#" MasterPageFile="~/ACE/my/master/MasterAdmin.Master" AutoEventWireup="true" CodeBehind="JqueryUI.aspx.cs" Inherits="WebApp.ACE.my.JqueryUI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="InlineStyles" runat="server">

   
    <link rel="stylesheet" href="../components/_mod/jquery-ui/jquery-ui.css" />


     <!-- the following scripts are used in demo only for onpage help and you don't need them -->
    <%--<link rel="stylesheet" href="../assets/css/ace.onpage-help.css" />
    <link rel="stylesheet" href="../docs/assets/js/themes/sunburst.css" />--%>
    <!-- page specific plugin styles -->

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="server">
    <h2>jqueryUI  组件的使用如何</h2>

    <%--  先引用进来公共的组件　然后　单个页面部分使用的组件　
    看一下　他的js 组件是如何写　如何使用。的　容纳后　使用控件的　的写法当作一个模板引擎来使用
    点击切换　全部都是提交到服务端来处理。。脚本很多效果都不需要来执行。。　很多地方只是要一个样式。。
    如何来玩耍　如何玩好　

    如果表单内容非常多的时候如何拆分　
    建立一个demo测试一下。--%>

    <%--
       要哪些内容。。如何来玩耍。。 
        数据库　表现层　数据层　业务层　服务层
        
        
    --%>

<div class="row">
	<div class="col-xs-12">
            

            <div class="row">
                <div class="col-sm-6">
                    <h3 class="header blue lighter smaller">
                        <i class="ace-icon fa fa-calendar-o smaller-90"></i>
                        时间
                    </h3>

                    <div class="row">
                        <div class="col-xs-6">
                            <div class="input-group input-group-sm">
                                <input type="text" id="datepicker" class="form-control" />
                                <span class="input-group-addon">
                                    <i class="ace-icon fa fa-calendar"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- ./span -->

                <div class="col-sm-6">
                    <h3 class="header blue lighter smaller">
                        <i class="ace-icon fa fa-list-alt smaller-90"></i>
                        对话框
                    </h3>
                    <a href="#" id="id-btn-dialog2" class="btn btn-info btn-sm">确认对话框</a>
                    <a href="#" id="id-btn-dialog1" class="btn btn-purple btn-sm">普通对话框</a>

                    <div id="dialog-message" class="hide">
                        <p>
                            This is the default dialog which is useful for displaying information. The dialog window can be moved, resized and closed with the 'x' icon.
                        </p>
                        <p>
                            对话框。获取输入框的内容。通过ajax请求发送数据　。添加修改用户
                            那个方便就使用那个。提交一个表单　正常请求　合理使用。

                        </p>

                        <div class="hr hr-12 hr-double"></div>

                        <p>
                            Currently using
					        <b>36% of your storage space</b>.
                        </p>
                        <p>
                            Currently using
					        <b>36% of your storage space</b>.
                        </p>
                        <p>
                            用户名：<input type="text" name="txtName" value="" />
                        </p>
                        <p>
                            密码：<input type="text" name="txtEmail" value="" />
                        </p>
                    </div>
                    <!-- #dialog-message -->

                    <div id="dialog-confirm" class="hide">
                        <div class="alert alert-info bigger-110">
                           删除之后无法撤销
                        </div>

                        <div class="space-6"></div>

                        <p class="bigger-110 bolder center grey">
                            <i class="ace-icon fa fa-hand-o-right blue bigger-120"></i>
                            确定要删除吗?
                        </p>
                    </div>
                    <!-- #dialog-confirm -->
                </div>
                <!-- ./span -->
            </div>
            <!-- ./row -->

            <div class="space-12"></div>

	        <div class="row">
		        <div class="col-sm-6">
			        <h3 class="header blue lighter smaller">
				        <i class="ace-icon fa fa-terminal smaller-90"></i>
				        自动完成
			        </h3>

			        <div class="row">
				        <div class="col-sm-8 col-md-7">
					        <input id="tags" type="text" class="form-control" placeholder="查询编程语言排名"/>
					        <div class="space-4"></div>

					        <input id="search" type="text" class="form-control" placeholder="Type 'a' or 'h'" />
				        </div>
			        </div>

			        <div class="row">
				        <div class="col-xs-12">
					        <h3 class="header blue lighter smaller">
						        <i class="ace-icon fa fa-info smaller-90"></i>
						        提示
					        </h3>

					        <div class="bigger-110">
						        <p>
							        <a class="grey" id="show-option" href="#" title="slide down on show">
								        <i class="ace-icon fa fa-hand-o-right"></i>
								        显示的时候下滑
							        </a>
						        </p>

						        <p>
							        <a class="blue" id="hide-option" href="#" title="explode on hide">
								        <i class="ace-icon fa fa-hand-o-right"></i>
								        消失的时候分裂
							        </a>
						        </p>

						        <p>
							        <a class="pink" id="open-event" href="#" title="move down on show">
								        <i class="ace-icon fa fa-hand-o-right"></i>
								        move down on show
							        </a>
						        </p>
					        </div>
				        </div>
			        </div><!-- ./row -->
		        </div><!-- ./col -->

                <%--如何遍历树生成菜单使用C#  遍历生成菜单的结构--%> 
		        <div class="col-sm-6">
			        <h3 class="header blue lighter smaller">
				        <i class="ace-icon fa fa-bars smaller-90"></i>
				        菜单
			        </h3>

			        <ul id="menu">
				        <li class="ui-state-disabled">Aberdeen</li>
				        <li>Ada</li>
				        <li>Adamsville</li>
				        <li>Addyston</li>

				        <li>
					        Delphi
					        <ul>
						        <li class="ui-state-disabled">Ada</li>
						        <li>Saarland</li>
						        <li>Salzburg</li>
					        </ul>
				        </li>
				        <li>Saarland</li>

				        <li>
					        Salzburg
					        <ul>
						        <li>
							        Delphi
							        <ul>
								        <li>Ada</li>
								        <li>Saarland</li>
								        <li>Salzburg</li>
							        </ul>
						        </li>

						        <li>
							        Delphi
							        <ul>
								        <li>Ada</li>
								        <li>Saarland</li>
								        <li>Salzburg</li>
							        </ul>
						        </li>
						        <li>Perch</li>
					        </ul>
				        </li>
				        <li class="ui-state-disabled">Amesville</li>
			        </ul>
		        </div><!-- ./col -->
	        </div><!-- ./row -->

	        <div class="space-12"></div>

            <div class="space-12"></div>

	        <div class="row">
		        <div class="col-sm-6">
			        <h3 class="header blue lighter smaller">
				        <i class="ace-icon fa fa-retweet smaller-90"></i>
				        微调器
			        </h3>

			        <input id="spinner" name="value" type="text" />


		        </div><!-- ./span -->

		        <div class="col-sm-6">
			        <h3 class="header blue lighter smaller">
				        <i class="ace-icon fa fa-arrows-h smaller-90"></i>
				        滑块
			        </h3>

			        <p>
				        Please see
				        <a href="form-elements.html">form elements page</a>
				        for more slider examples.
			        </p>

			        <div class="space-4"></div>

			        <div id="slider"></div>


		        </div><!-- ./col -->
	        </div><!-- ./row -->

            <div class="row">
                <div class="col-sm-6">
					<h3 class="header blue lighter smaller">
						<i class="ace-icon fa fa-folder-o smaller-90"></i>
						标签  
                        <%--把这个结构的样式结合webform如何来使用  内容修改成功　就直接跳转　如果错误才提示
                            还是各个组合起来如何使用　完整的做一点东西出来　才可以。

                            使用　标签　做个切换的的表单
                            --%>
					</h3>

					<div id="tabs">
						<ul>
							<li>
								<a href="#tabs-1">Nunc tincidunt</a>
							</li>

							<li class="ui-tabs-active ui-state-active">
								<a href="#tabs-2">Proin dolor</a>
							</li>

							<li>
								<a href="#tabs-3">Aenean lacinia</a>
							</li>
						</ul>

						<div id="tabs-1">
							<p>Proin elit arcu, rutrum commodo, vehicula tempus, commodo a, risus. Curabitur nec arcu. Donec sollicitudin mi sit amet mauris. Nam elementum quam ullamcorper ante. Duis orci. Aliquam sodales tortor vitae ipsum. Ut et mauris vel pede varius sollicitudin.</p>
						</div>

						<div id="tabs-2">
							<p>Morbi tincidunt, dui sit amet facilisis feugiat, odio metus gravida ante, ut pharetra massa metus id nunc. Duis scelerisque molestie turpis. Morbi facilisis. Curabitur ornare consequat nunc. Aenean vel metus. Ut posuere viverra nulla..</p>
						</div>

						<div id="tabs-3">
							<p>Mauris eleifend est et turpis. Duis id erat. Suspendisse potenti. Aliquam vulputate, pede vel vehicula accumsan, mi neque rutrum erat, eu congue orci lorem eget lorem. Praesent eu risus hendrerit ligula tempus pretium.</p>
						</div>
					</div>
				</div><!-- ./col -->

            </div>

            <div class="space-12"></div>

			<div class="row">
				<div class="col-sm-6">
					<h3 class="header blue lighter smaller">
						<i class="ace-icon fa fa-spinner"></i>
						进度条
					</h3>

					<div id="progressbar"></div>
				</div><!-- ./col -->

				<div class="col-sm-6">
					<h3 class="header blue lighter smaller">
						<i class="ace-icon fa fa-spinner"></i>
						Selectmenu
					</h3>
					<label for="number" class="block">选择一个数字</label>

					<select name="number" id="number">
						<option>1</option>
						<option selected="selected">2</option>
						<option>3</option>
						<option>4</option>
						<option>5</option>
					</select>
				</div>
			</div><!-- ./row -->

    </div>
</div>
</asp:Content>



<asp:Content   ID="Content4" ContentPlaceHolderID="pageSpecificPlugin" runat="server">
    <!-- page specific plugin scripts -->
		<script src="../components/jquery-ui/jquery-ui.js"></script>
		<script src="../components/jqueryui-touch-punch/jquery.ui.touch-punch.js"></script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="InlineScripts" runat="server">


    <!-- inline scripts related to this page -->
    <script type="text/javascript">
        jQuery(function ($) {


            //这个datepicker浏览器里面看不到value的值　但是jquery是能够获取到的。

            //
            $("#datepicker").datepicker({
                showOtherMonths: true,
                selectOtherMonths: true,
                isRTL:true,


                
                //changeMonth: true,
                changeYear: true,

                //showButtonPanel: true,
                //beforeShow: function() {
                //    //change button colors
                //    var datepicker = $(this).datepicker( "widget" );
                //    setTimeout(function(){
                //        var buttons = datepicker.find('.ui-datepicker-buttonpane')
                //        .find('button');
                //        buttons.eq(0).addClass('btn btn-xs');
                //        buttons.eq(1).addClass('btn btn-xs btn-success');
                //        buttons.wrapInner('<span class="bigger-110" />');
                //    }, 0);
                //}
                
            });


            //override dialog's title function to allow for HTML titles
            $.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
                _title: function (title) {
                    var $title = this.options.title || '&nbsp;'
                    if (("title_html" in this.options) && this.options.title_html == true)
                        title.html($title);
                    else title.text($title);
                }
            }));

            //普通对话框
            $("#id-btn-dialog1").on('click', function (e) {
                e.preventDefault();

                var dialog = $("#dialog-message").removeClass('hide').dialog({
                    modal: true,
                    title: "<div class='widget-header widget-header-small'><h4 class='smaller'><i class='ace-icon fa fa-check'></i> 这里是一个对话框</h4></div>",
                    title_html: true,
                    buttons: [
                        {
                            text: "取消",
                            "class": "btn btn-minier",
                            click: function () {
                                $(this).dialog("close");
                            }
                        },
                        {
                            text: "确定",
                            "class": "btn btn-primary btn-minier",
                            click: function () {
                                $(this).dialog("close");
                            }
                        }
                    ]
                });

                /**
                dialog.data( "uiDialog" )._title = function(title) {
                    title.html( this.options.title );
                };
                **/
            });

            //把这个页面整理一下　变成自己需要的页面　可以直接运行的


            //确认对话框点击的时候
            $("#id-btn-dialog2").on('click', function (e) {
                e.preventDefault();

                $("#dialog-confirm").removeClass('hide').dialog({
                    resizable: false,
                    width: '320',
                    modal: true,
                    title: "<div class='widget-header'><h4 class='smaller'><i class='ace-icon fa fa-exclamation-triangle red'></i> 注意</h4></div>",
                    title_html: true,
                    buttons: [
                        {
                            html: "<i class='ace-icon fa fa-trash-o bigger-110'></i>&nbsp; 删除",
                            "class": "btn btn-danger btn-minier",
                            click: function () {

                                //确认点击事件
                                $(this).dialog("close");
                            }
                        }
                        ,
                        {
                            html: "<i class='ace-icon fa fa-times bigger-110'></i>&nbsp; 取消",
                            "class": "btn btn-minier",
                            click: function () {
                                //取消点击时间
                                $(this).dialog("close");
                            }
                        }
                    ]
                });
            });



            //autocomplete
            var availableTags = [
                "ActionScript",
                "AppleScript",
                "Asp",
                "BASIC",
                "C",
                "C++",
                "Clojure",
                "COBOL",
                "ColdFusion",
                "Erlang",
                "Fortran",
                "Groovy",
                "Haskell",
                "Java",
                "JavaScript",
                "Lisp",
                "Perl",
                "PHP",
                "Python",
                "Ruby",
                "Scala",
                "Scheme"
            ];
            $("#tags").autocomplete({
                source: availableTags
            });

            //custom autocomplete (category selection)
            $.widget("custom.catcomplete", $.ui.autocomplete, {
                _create: function () {
                    this._super();
                    this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                },
                _renderMenu: function (ul, items) {
                    var that = this,
                        currentCategory = "";
                    $.each(items, function (index, item) {

                        //设置渲染分类和列表　或者　只是渲染分类的数据
                        var li;
                        if (item.category != currentCategory) {
                            ul.append("<li class='ui-autocomplete-category'>" + item.category + "</li>");
                            currentCategory = item.category;
                        }
                        li = that._renderItemData(ul, item);
                        if (item.category) {
                            li.attr("aria-label", item.category + " : " + item.label);
                        }
                    });
                }
            });

            var data = [
                { label: "anders", category: "" },
                { label: "andreas", category: "" },
                { label: "antal", category: "" },
                { label: "annhhx10", category: "Products" },
                { label: "annk K12", category: "Products" },
                { label: "annttop C13", category: "Products" },
                { label: "anders andersson", category: "People" },
                { label: "andreas andersson", category: "People" },
                { label: "andreas johnson", category: "People" }
            ];
            $("#search").catcomplete({
                delay: 0,
                source: data
            });


            ////tooltips
            $("#show-option").tooltip({
                show: {
                    effect: "slideDown",
                    delay: 250
                }
            });

            $("#hide-option").tooltip({
                hide: {
                    effect: "explode",
                    delay: 250
                }
            });

            //显示　move-down的效果
            $("#open-event").tooltip({
                show: null,
                position: {
                    my: "left top",
                    at: "left bottom"
                },
                open: function (event, ui) {
                    ui.tooltip.animate({ top: ui.tooltip.position().top + 10 }, "fast");
                }
            });


            ////Menu　　菜单其实是最简单　遍历显示出来就可以了。然后加一个链接来跳转
            //　
            $("#menu").menu();


            //spinner
            var spinner = $("#spinner").spinner({
                create: function (event, ui) {
                    //add custom classes and icons
                    $(this)
                        .next().addClass('btn btn-success').html('<i class="ace-icon fa fa-plus"></i>')
                        .next().addClass('btn btn-danger').html('<i class="ace-icon fa fa-minus"></i>')

                    //larger buttons on touch devices
                    if ('touchstart' in document.documentElement)
                        $(this).closest('.ui-spinner').addClass('ui-spinner-touch');
                }
            });

            //slider example  如何获取这个显示的范围的值　这个用到也比较少
            $("#slider").slider({
                range: true,
                min: 0,
                max: 500,
                values: [75, 300]
            });



            ////jquery accordion
            //$("#accordion").accordion({
            //    collapsible: true,
            //    heightStyle: "content",
            //    animate: 250,
            //    header: ".accordion-header"
            //}).sortable({
            //    axis: "y",
            //    handle: ".accordion-header",
            //    stop: function (event, ui) {
            //        // IE doesn't register the blur when sorting
            //        // so trigger focusout handlers to remove .ui-state-focus
            //        ui.item.children(".accordion-header").triggerHandler("focusout");
            //    }
            //});



            //jquery tabs  标签如何结合表单　请求返回显示对应的 提交表单如果失败了还是回到当前这个tab
            $("#tabs").tabs();


            ////progressbar  请求加载完成精度条效果　　显示一个比例　　jquery UI的文档　这个是基于这个有方法　有事件　查询
            //后台这种表单布局　一般是什么样子的　　一行占满　或者　一行　分成两列　　基本信息　其他信息

            //常用的标签图标。使用。　　那么多的功能　肯定不会所有的功能　都会使用。。。使用到到的功能　用到了会使用就可以了。
            // 后台界面的布局。。jquery 一些组件的使用。　ui界面的功能。。　添加当前选中的样式效果。。

            $("#progressbar").progressbar({
                value: 12,
                create: function (event, ui) {
                    $(this).addClass('progress progress-striped active')
                        .children(0).addClass('progress-bar progress-bar-success');
                }
            });


            ////selectmenu
            $("#number").css('width', '200px')
                .selectmenu({ position: { my: "left bottom", at: "left top" } })

        });
    </script>



    <%--资料　


    http://demo.jeasyui.cn/?from=bdtg
        
    https://www.jqueryui.org.cn/demo/5726.html

    那个是　jqueryUI  jqueryEasyUI 本质还是一回事　
        
        --%>


</asp:Content>
