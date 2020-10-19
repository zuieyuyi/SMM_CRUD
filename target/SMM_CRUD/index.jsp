<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/10/11
  Time: 22:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Employee Page</title>
</head>
<%
    pageContext.setAttribute("APP_PATH",request.getContextPath());
%>
<!-- web路径：
    不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
    以/开始的相对路径，找资源，以服务器路径为标准（http://localhost:3306）需要加上项目名

-->
<!-- 引入Jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-2.1.3.js"></script>
<!-- 引入bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<body>
<!-- 员工添加模态框 -->
<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
            </div>
            <div class="modal-body">
                <!-- 模态框内容 -->
                <form class="form-horizontal">
                    <!-- 员工姓名 -->
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <!-- 员工邮箱 -->
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <!-- 员工性别 -->
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <!-- 员工部门
                        部门提交部门ID即可
                     -->
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" id="emp_save_close_btn" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 搭建显示页面 -->
<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h2>SSM_CURD</h2>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="row">
        <!-- 列偏移 -->
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_and_model_btn">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <!-- 显示表格数据 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <!-- 显示分页栏 -->
    <div class="row">
        <!-- 分页信息 -->
        <div class="col-md-6" id="page_info_area">

        </div>
        <!-- 分页条信息 -->
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>
<script>
    var totalrecord;
    //1、页面加载完成以后，直接去发送ajax请求，要到分页数据
    $(function(){
        //去首页
        to_page(1);
    });

    //发送ajax请求获取那一页数据
    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"GET",
            success:function (result) {
                // console.log(result);
                //1、解析并显示员工数据
                build_emps_table(result);
                //2、解析并显示分页数据
                build_page_info(result);
                //3、解析并显示分页条数据
                build_page_nav(result);
            }
        });
    }

    function build_emps_table(result){
        //清空数据
        $("#emps_table tbody").empty();

        var emps = result.map.pageInfo.list;
        $.each(emps,function(index,item){
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == "M"?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editButTd = $("<button></button>").addClass("btn btn-primary btn-sm").attr("aria-hidden","true")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            var delButTd = $("<button></button>").addClass("btn btn-danger btn-sm").attr("aria-hidden","true")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");

            var butsTd = $("<td></td>").append(editButTd).append(" ").append(delButTd);

            $("<tr></tr>").append(empIdTd).append(empNameTd)
                                .append(genderTd).append(emailTd).append(deptNameTd)
                                .append(butsTd)
                                .appendTo("#emps_table tbody");
        });
    }
    //解析分页条数据
    function build_page_info(result){
        //清空数据
        $("#page_info_area").empty();
        // 当前第 页，总共 页,总共 条记录
        $("#page_info_area").append("当前第"+result.map.pageInfo.pageNum+
                                    "页，总共"+result.map.pageInfo.pages+
                                    "页,总共"+result.map.pageInfo.total+"条记录");
        //记录数全局变量
        totalrecord = result.map.pageInfo.total;
    }
    //解析分页信息数据
    function build_page_nav(result){
        //清空数据
        $("#page_nav_area").empty();
        //列表父元素
        var ulTag = $("<ul></ul>").addClass("pagination");
        //首页
        var firstPage = $("<li></li>").append($("<a></a>").append("首页"));

        //末页
        var lastPage = $("<li></li>").append($("<a></a>").append("末页"));

        //上一页
        var prePage = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&laquo;").attr("aria-hidden","true")));

        if(result.map.pageInfo.hasPreviousPage == false){
            prePage.addClass("disabled");
        }else{
            //点击翻页
            prePage.click(function(){
                to_page(result.map.pageInfo.pageNum-1)
            });
            //点击回首页
            firstPage.click(function(){
                to_page(1);
            });
        }

        //下一页
        var nextPage = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&raquo;").attr("aria-hidden","true")));

        if(result.map.pageInfo.hasNextPage == false){
            nextPage.addClass("disabled");
        }else{
            //点击翻页
            nextPage.click(function(){
                to_page(result.map.pageInfo.pageNum+1)
            });
            //点击回末页
            lastPage.click(function(){
                to_page(result.map.pageInfo.pages);
            });
        }

        ulTag.append(firstPage).append(prePage);

        //中间页
        $.each(result.map.pageInfo.navigatepageNums,function(index,item){
            var numPage = $("<li></li>").append($("<a></a>").append(item));
            if(result.map.pageInfo.pageNum == item){
                numPage.addClass("active");
            }else{
                //点击发送ajax请求获取数据
                numPage.click(function(){
                    to_page(item);
                });
            }
            ulTag.append(numPage);
        })

        ulTag.append(nextPage).append(lastPage);

        var navTag = $("<nav></nav>").attr("aria-label","Page navigation");

        navTag.append(ulTag).appendTo("#page_nav_area");
    }

    //清空表单内容遗迹样式
    function clear_form(ele){
        //清空表单内容
        // reset是dom对象的方法
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        //清空提示信息
        $(ele).find(".help-block").text("");
    }

    //点击按钮显示模态框
    $("#emp_and_model_btn").click(function(){
        //清空表单数据（表单重置(清空内容及样式)）
        clear_form("#empAddModel form");
        // $("#empAddModel form")[0].reset();
        //发送ajax请求,查出部门，显示再下拉列表中
        getDepts();
        //弹出模态框
        $("#empAddModel").modal({
            backdrop:"static"
        });
    });

    //获取全部部门
    function getDepts() {
        $.ajax({
            url:"${APP_PATH}/depts",
            type: "GET",
            success:function (result) {
                // console.log(result)
                //显示部门信息再下拉列表中
                $.each(result.map.depts,function(){
                   var optionTag = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                   $("#empAddModel select").append(optionTag);
                });
            }
        })
    }

    //校验表单数据
    function validate_add_form(){
        //1、拿到校验的数据，使用正则表达式校验
        //姓名校验
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if(!regName.test(empName)){
            // alert("用户名可以是2-5位中文或者是6-16位字母数字组合");
            //都要清空样式
            show_validate("#empName_add_input","error","用户名必须是2-5位中文或者是6-16位字母数字组合");
            // $("#empName_add_input").parent().addClass("has-error");
            // $("#empName_add_input").next("span").text("用户名可以是2-5位中文或者是6-16位字母数字组合");
            return false;
        }else{
            show_validate("#empName_add_input","success","");
            // $("#empName_add_input").parent().addClass("has-success");
            // $("#empName_add_input").next("span").text();
        }

        //邮箱校验
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
        if(!regEmail.test(email)){
            // alert("邮箱格式不正确");
            show_validate("#email_add_input","error","邮箱格式不正确");
            // $("#email_add_input").parent().addClass("has-error");
            // $("#email_add_input").next("span").text("邮箱格式不正确");
            return false;
        }else{
            show_validate("#email_add_input","success","");
            // $("#email_add_input").parent().addClass("has-success");
            // $("#email_add_input").next("span").text("");
        }
        return true;
    }

    //添加校验样式
    function show_validate(ele,status,msg){
        //清空样式
        $(ele).parent().removeClass("has-success has-error");
        if("success" == status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //ajax员工名查重，输入框值变化触发
    $("#empName_add_input").change(function () {
        //1、获取输入名
        var empName = this.value
        //2、发送ajax请求查询数据库中是否存在名字一样的员工
        $.ajax({
            url: "${APP_PATH}/checkemp",
            type: "POST",
            data: "empName="+empName,
            success:function(result){
                if(result.code == 100){
                    show_validate("#empName_add_input","success","用户名可用");
                    $("#emp_save_btn").attr("ajax-va","success");
                }else{
                    show_validate("#empName_add_input","error",result.map.va_msg);
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        })
    });

    //点击保存员工数据
    $("#emp_save_btn").click(function () {
        //1、模态框填写的表单数据提交给服务器进行保存
        //1、校验表单发送的数据
        // if(!validate_add_form()){
        //     return false;
        // }
        //2、判断之前的ajax员工名校验是否成功了
        // if($(this).attr("ajax-va") == "error"){
        //     show_validate("#empName_add_input","error","用户名不可用");
        //     return false;
        // }
        //3、发送ajax请求保存员工
        // alert($("#empAddModel form").serialize());
        $.ajax({
            url:"${APP_PATH}/emp",
            method:"POST",
            data:$("#empAddModel form").serialize(),
            success:function(result){
                if (result.code == 100){
                    //员工保存成功
                    //1、关闭模态框
                    $("#empAddModel").modal("hide");
                    //2、来到最后一页显示刚保存的数据
                    to_page(totalrecord);
                }else {
                    // console.log(result);
                    //如果是未定义就表示没有错误，反之则有错
                    if(undefined != result.map.errorField.email){
                        show_validate("#email_add_input","error",result.map.errorField.email);
                    }
                    if(undefined != result.map.errorField.empName){
                        show_validate("#empName_add_input","error",result.map.errorField.empName);
                    }
                }
            }
        });
    });

</script>
</body>
</html>