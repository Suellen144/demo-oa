<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/header.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=base%>/static/mobile/css/m_index.css"/>
</head>
<body>
	<header>
		<h1>睿哲办公系统</h1>
		<section id="notice">
			<h2>通知</h2>
			<ul></ul>
		</section>
		<section id="task">
			<a href="<%=base%>/manage/office/pendflow/toList">
				<span id="taskQuantity">0</span>
				<p>待办任务</p>
			</a>
			<a href="<%=base%>/manage/office/noitce/findNoticeToList">
				<span id="noticeQuantity">0</span>
				<p>待阅通知</p>
			</a>
		</section>
	</header>
	<div id="main">
		<h1>常用功能</h1>
		<ul>
			<c:forEach items="${user.roleList }" var="role">
        		<c:if test="${role.name eq '普通员工' or  role.name eq '总经理'}">
        			<li><a href="<%=base%>/manage/ad/workReport/toList"><i><img src="<%=base%>/static/mobile/images/icon/icon_01.png"/></i><p>工作汇报</p></a></li>
					<li><a href="javascript:void(0)"><i class="color_g"><img src="<%=base%>/static/mobile/images/icon/icon_02.png"/></i><p>请示管理</p></a></li>
					<li><a href="javascript:void(0)"><i class="color_y"><img src="<%=base%>/static/mobile/images/icon/icon_03.png"/></i><p>公文管理</p></a></li>
					<li><a href="<%=base%>/manage/ad/travel/toList"><i class="color_r"><img src="<%=base%>/static/mobile/images/icon/icon_04.png"/></i><p>出差管理</p></a></li>
					<li><a href="<%=base%>/manage/finance/management/toShow"><i class="color_o"><img src="<%=base%>/static/mobile/images/icon/icon_05.png"/></i><p>报销申请</p></a></li>
					<li><a href="<%=base%>/manage/office/noitce/toList"><i class="color_p"><img src="<%=base%>/static/mobile/images/icon/icon_06.png"/></i><p>信息发布</p></a></li>
					<li><a href="<%=base%>/manage/ad/overtime/toList"><i class="color_g"><img src="<%=base%>/static/mobile/images/icon/icon_07.png"/></i><p>加班管理</p></a></li>
					<li><a href="<%=base%>/manage/ad/legwork/toList"><i><img src="<%=base%>/static/mobile/images/icon/icon_08.png"/></i><p>外勤登记</p></a></li>
					<li><a href="<%=base%>/manage/ad/kpi/toList"><i class="color_g"><img src="<%=base%>/static/mobile/images/icon/icon_11.png"/></i><p>绩效考核</p></a></li>
					<li><a href="<%=base%>/manage/ad/leave/toList"><i class="color_r"><img src="<%=base%>/static/mobile/images/icon/icon_12.png"/></i><p>请假管理</p></a></li>
					<li><a href="<%=base%>/manage/ad/seal/toList"><i><img src="<%=base%>/static/mobile/images/icon/icon_13.png"/></i><p>印章管理</p></a></li>
					<li><a href="<%=base%>/manage/ad/car/toList"><i class="color_y"><img src="<%=base%>/static/mobile/images/icon/icon_14.png"/></i><p>用车管理</p></a></li>
					<li><a href="<%=base%>/manage/ad/meeting/toList"><i class="color_p"><img src="<%=base%>/static/mobile/images/icon/icon_15.png"/></i><p>会议纪要</p></a></li>
					
					<!-- 市场、 总经理-->
	        		<shiro:hasAnyRoles name="boss,market">
	        			<li><a href="<%=base%>/manage/ad/workmanage/toList"><i class="color_o"><img src="<%=base%>/static/mobile/images/icon/icon_09.png"/></i><p>市场管理</p></a></li>
	        		</shiro:hasAnyRoles>
	        		
	        		<c:if test="${sessionScope.user.id eq '27' or sessionScope.user.id eq '225'}">
	        			<li><a href="<%=base%>/manage/finance/statisticspay/toList"><i ><img src="<%=base%>/static/mobile/images/icon/icon_19.png"/></i><p>财务统计</p></a></li>
	        		</c:if>
	        		
	        		<c:if test="${sessionScope.user.id eq 2}">
	        			<li><a href="<%=base%>/manage/ad/filemanage/toList"><i class="color_y"><img src="<%=base%>/static/mobile/images/icon/icon_10.png"/></i><p>文件管理</p></a></li>
	        		</c:if>

	        		<!-- 行政主管、市场、财务、 总经理-->
					<shiro:hasAnyRoles name="xzzg,market,finance,boss">
						<li><a href="<%=base%>/manage/sale/barginManage/toList"><i ><img src="<%=base%>/static/mobile/images/icon/icon_17.png"/></i><p>合同管理</p></a></li>
						<li><a href="<%=base%>/manage/sale/projectManage/toListNew"><i class="color_o"><img src="<%=base%>/static/mobile/images/icon/icon_18.png"/></i><p>项目管理</p></a></li>
						<li><a href="<%=base%>/manage/finance/pay/toList"><i class="color_r"><img src="<%=base%>/static/mobile/images/icon/icon_21.png"/></i><p>付款管理</p></a></li>
						<li><a href="<%=base%>/manage/finance/collection/toList"><i><img src="<%=base%>/static/mobile/images/icon/icon_22.png"/></i><p>收款管理</p></a></li>
					</shiro:hasAnyRoles>
					
					<shiro:hasAnyRoles name="officer,finance,boss">
						<!-- 总经理、财务、前台文员    查看 -->
						<shiro:hasAnyRoles name="finance,boss,qtwy">
							<li><a href="<%=base%>/manage/ad/record/toList"><i class="color_p"><img src="<%=base%>/static/mobile/images/icon/icon_23.png"/></i><p>人事管理</p></a></li>
						</shiro:hasAnyRoles>
						<!-- 用户id为6、83    查看 -->
						<c:if test="${sessionScope.user.id eq 6 or sessionScope.user.id eq 83}">
							<li><a href="<%=base%>/manage/ad/record/toList"><i class="color_p"><img src="<%=base%>/static/mobile/images/icon/icon_23.png"/></i><p>人事管理</p></a></li>
						</c:if>
						<!-- 总经理、行政    查看 -->
						<shiro:hasAnyRoles name="officer,boss">
							<li><a href="<%=base%>/manage/organization/toList"><i class="color_g"><img src="<%=base%>/static/mobile/images/icon/icon_24.png"/></i><p>组织架构</p></a></li>
						</shiro:hasAnyRoles>
						<!-- 总经理、财务    查看 -->
						<shiro:hasAnyRoles name="finance,boss">
							<li><a href="<%=base%>/manage/finance/management/toList"><i class="color_y"><img src="<%=base%>/static/mobile/images/icon/icon_25.png"/></i><p>报销管理</p></a></li>
							<li><a href="<%=base%>/manage/finance/statisticspay/toList"><i ><img src="<%=base%>/static/mobile/images/icon/icon_19.png"/></i><p>财务统计</p></a></li>
							<li><a href="<%=base%>/manage/finance/invest/toList"><i class="color_r"><img src="<%=base%>/static/mobile/images/icon/icon_20.png"/></i><p>费用归宿</p></a></li>
						</shiro:hasAnyRoles>
						<!-- 总经理    查看 -->
						<shiro:hasAnyRoles name="boss">
							<li><a href="<%=base%>/manage/ad/rulesRegulation/toPage"><i><img src="<%=base%>/static/mobile/images/icon/icon_16.png"/></i><p>规章制度</p></a></li>
						</shiro:hasAnyRoles>
					</shiro:hasAnyRoles>
					
					<c:if test="${sessionScope.user.id ne 2 and sessionScope.user.id ne 36 and sessionScope.user.id ne 50}">
	        			<li><a href="<%=base%>/manage/ad/rulesRegulation/toPage"><i><img src="<%=base%>/static/mobile/images/icon/icon_16.png"/></i><p>规章制度</p></a></li>
	        		</c:if>
        		</c:if>
        	</c:forEach>
		</ul>
	</div>
	<c:set var="deptId" value="${user.deptId}"/>
	<%@ include file="../common/footer.jsp"%>
</body>
</html>
<script type="text/javascript" src="<%=base%>/static/mobile/js/index/index.js" ></script>
<script type="text/javascript">
	var deptId  = "${deptId}";
	var approve = '<shiro:hasPermission name="ad:kpi:approve">true</shiro:hasPermission>';

	$(function(){
		$("footer ul li").eq(0).addClass('active') 
	})
</script>
<script>

</script>