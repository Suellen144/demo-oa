<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/header.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=base%>/static/mobile/css/m_user.css"/>
    
</head>
<body>
	<header>		
		<section id="userInfo">
			<div id="userImg">
				<c:if test="${not empty sessionScope.user.photo }">
					<img src="<%=base%>${sessionScope.user.photo}" />
				</c:if> 
				<c:if test="${empty sessionScope.user.photo }">
					<img src="<%=base%>/static/AdminLTE/img/avatar04.png" />
				</c:if> 

			</div>
			<p id="username">${sessionScope.user.name }</p>
			<p><span>${sessionScope.user.positionList[0].name }</span></p>
		</section>
		<section id="cumulative">
			<a href="javscript:void(0)">
				<span>0</span>
				<p>累计事假&nbsp;(h)</p>
			</a>
			<a href="javscript:void(0)">
				<span>0</span>
				<p>累计病假&nbsp;(h)</p>
			</a>
			<a href="javscript:void(0)">
				<span>0</span>
				<p>累计调休&nbsp;(h)</p>
			</a>
		</section>
	</header>
	<div id="main">	
		<ul>
			<li>
				<a href="javascript:void(0)">通讯录</a>
				<i class="iconfont icon-right-line"></i>
			</li>	
			<li>
				<a href="javascript:void(0)">我的申请</a>
				<i class="iconfont icon-right-line"></i>
			</li>
			<li>
				<a href="javascript:void(0)">我的待办</a>
				<i class="iconfont icon-right-line"></i>
			</li>			
			<li>
				<a href="javascript:void(0)">会议纪要</a>
				<i class="iconfont icon-right-line"></i>
			</li>				
			<li>
				<a href="javascript:void(0)">我的资料</a>
				<i class="iconfont icon-right-line"></i>
			</li>
			<li>
				<a href="javascript:void(0)">修改密码</a>
				<i class="iconfont icon-right-line"></i>
			</li>

		</ul>	
		<div id="exit">
			<a href="javascript:void(0)" onclick="logout()">退出</a>
		</div>
		
	</div>
	<%@ include file="../../common/footer.jsp"%>
</body>
</html>
<c:set var="userId" value="${sessionScope.user.id }"/>
<script src="<%=base%>/static/jquery/jquery-1.11.1/jquery.min.js"></script>
<script>
$(function(){
	getLeave();
});

function getLeave(){
	var userId  = "${userId}";
    $.ajax({
    	url: base+"/manage/ad/leave/getLeaveByUserId?userId="+userId,
        dataType: "json",
        success: function(data) {
        	$("#cumulative a").eq(0).find('span').text(data.casualLeave)
        	$("#cumulative a").eq(1).find('span').text(data.sickLeave)
        	$("#cumulative a").eq(2).find('span').text(data.vacation)
        }, 
        error: function(data) {
        }
    });
}
function logout() {
	localStorage.setItem( 'reyzar_datatables', "" ); // 清除datatables的分页数据
	window.location.href = "logout";
}
$("footer ul li").eq(2).addClass('active') 
</script>

