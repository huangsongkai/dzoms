<%--
  Created by IntelliJ IDEA.
  User: huang
  Date: 2017/6/15
  Time: 下午11:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>任务列表</title>
    <link rel="stylesheet" href="/DZOMS/ky/css/style.css"/>
</head>
<body>
<div class="container">
    <div id="header">
        <h2>任务列表</h2>
    </div>
    <div id="taskList"></div>
</div>

<script type="text/javascript">
    var pageUrls ={
        taskListUrl:"/DZOMS/ky/runtime/tasks",   //get    ?assignee=
        executeUrl:"/DZOMS/ky/activity/task/execute/" //执行跳转时的url
    }
</script>
</body>
    <script src="/DZOMS/ky/js/commonV3.js"></script>
    <script src="/DZOMS/ky/js/processAll-bundle.js"></script>
</html>
