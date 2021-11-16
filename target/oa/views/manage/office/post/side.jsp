<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!-- 已登录 -->
    <div class="panel panel-default" id="sidebar2" style="width: 20%;margin:1% 2% 1% 0%;float: right">
        <div class="panel-heading" style="background-color: white;text-align: center">
        </div>
        <ul class="list-group" style="width: 100%">
            <li class="list-group-item"><a href="${pageContext.request.contextPath }/new">创作新主题</a></li>
            <li class="list-group-item"><a href="">0条未读提醒</a></li>
            <li class="list-group-item"><a href="">积分:</a></li>
        </ul>
    </div>


<div class="panel panel-default" id="sidebar1" style="width: 20%;margin:1% 2% 1% 0%;float: right">
    <div class="panel-heading" style="background-color: white;text-align: center">
        热议主题
    </div>
    <ul class="list-group" style="width: 100%">
        <%-- <c:forEach items="${hotestTopics}" var="hotestTopic">
            <li class="list-group-item"><a href="${pageContext.request.contextPath }/t/${hotestTopic.id}">${hotestTopic.title}</a></li>
        </c:forEach> --%>
    </ul>
</div>


