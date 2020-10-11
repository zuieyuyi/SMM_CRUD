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
<!-- 引入bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- 引入Jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-2.1.3.js"></script>
<body>
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
            <button class="btn btn-primary">新增</button>
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
<%--                <c:forEach items="${pageInfo.list}" var="emp">--%>
<%--                    <tr>--%>
<%--                        <td>${emp.empId}</td>--%>
<%--                        <td>${emp.empName}</td>--%>
<%--                        <td>${emp.gender=="M"?"男":"女"}</td>--%>
<%--                        <td>${emp.email}</td>--%>
<%--                        <td>${emp.department.deptName}</td>--%>
<%--                        <td>--%>
<%--                            <button class="btn btn-primary btn-sm">--%>
<%--                                <!-- 按钮中图标 -->--%>
<%--                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>--%>
<%--                                编辑--%>
<%--                            </button>--%>
<%--                            <button class="btn btn-danger btn-sm">--%>
<%--                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>--%>
<%--                                删除--%>
<%--                            </button>--%>
<%--                        </td>--%>
<%--                    </tr>--%>
<%--                </c:forEach>--%>
            </table>
        </div>
    </div>
    <!-- 显示分页栏 -->
    <div class="row">
        <!-- 分页信息 -->
        <div class="col-md-6">
            当前第 页，总共 页,总共 条记录
        </div>
        <!-- 分页条信息 -->
        <div class="col-md-6">
<%--            <nav aria-label="Page navigation">--%>
<%--                <ul class="pagination">--%>
<%--                    <li><a href="${APP_PATH}/emps?pn=1">首页</a></li>--%>
<%--                    <!-- 如果没有上一页则不显示 -->--%>
<%--                    <c:if test="${pageInfo.hasPreviousPage}">--%>
<%--                        <li >--%>
<%--                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">--%>
<%--                                <span aria-hidden="true">&laquo;</span>--%>
<%--                            </a>--%>
<%--                        </li>--%>
<%--                    </c:if>--%>

<%--                    <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">--%>
<%--                        <!-- 如果page_Num等于当前页码则高亮即： class="active" -->--%>
<%--                        <c:if test="${page_Num == pageInfo.pageNum}">--%>
<%--                            <li class="active"><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>--%>
<%--                        </c:if>--%>
<%--                        <c:if test="${page_Num != pageInfo.pageNum}">--%>
<%--                            <li><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>--%>
<%--                        </c:if>--%>
<%--                    </c:forEach>--%>
<%--                    <!-- 如果没有下一页则不显示 -->--%>
<%--                    <c:if test="${pageInfo.hasNextPage}">--%>
<%--                        <li>--%>
<%--                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1}" aria-label="Previous">--%>
<%--                                <span aria-hidden="true">&raquo;</span>--%>
<%--                            </a>--%>
<%--                        </li>--%>
<%--                    </c:if>--%>
<%--                    <li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a></li>--%>
<%--                </ul>--%>
<%--            </nav>--%>
        </div>
    </div>
</div>
<script>
    //1、页面加载完成以后，直接去发送ajax请求，要到分页数据
    $(function(){
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn=1",
            type:"GET",
            success:function (result) {
                // console.log(result);
                //1、解析并显示员工数据
                build_emps_table(result);
                //2、解析并显示分页数据
            }
        });
    });

    function build_emps_table(result){
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
    function build_page_nav(){

    }
</script>
</body>
</html>