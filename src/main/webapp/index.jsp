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
                        </div>
                    </div>
                    <!-- 员工邮箱 -->
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@qq.com">
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
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
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

    //模态框绑定按钮事件
    $("#emp_and_model_btn").click(function(){
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

    $("#emp_save_btn").click(function () {
        //1、模态框填写的表单数据提交给服务器进行保存
        //2、发送ajax请求保存员工
        // alert($("#empAddModel form").serialize());
        $.ajax({
            url:"${APP_PATH}/emp",
            method:"POST",
            data:$("#empAddModel form").serialize(),
            success:function(result){
                //员工保存成功
                //1、关闭模态框
                $("#empAddModel").modal("hide");
                //2、来到最后一页显示刚保存的数据
                to_page(totalrecord);
            }
        });
    })


</script>
</body>
</html>