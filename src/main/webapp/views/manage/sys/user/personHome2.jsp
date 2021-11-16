<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/header.jsp"%>
	<link href="<%=base%>/static/plugins/permanent-calendar/permanentCalendar.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="<%=base%>/static/css/oaMain.css">
	<style>
		#table1 {
			table-collapse: collapse;
			border: none;
			margin: 5px 20px;
			width: 98%;
		}

		#table1 td {
			/* border: solid #999 1px; */
			padding: 10px 5px;
		}

		#table1 td input[type="text"] {
			width: 100%;
			height: 100%;
			border: none;
			outline: medium;
		}

		#table1 td span {
			padding: 0px;
		}

		#table1 th {
			/* border: solid #999 1px; */
			text-align: center;
			font-size: 1.5em;
		}

		.text-right {
			text-align: right;
		}

		#deptName {
			width: 69%;
			height: 100%;
			overflow: visible;
			position: absolute;
			top: 72%;
			outline: none;
			resize: none;
			border: none;
		}

		#dept, #updateDate {
			width: auto !important;
			min-width: 18em;
			text-align: center;
			float: right;
		}

		/* CSS Document */
		.leftBorder, .leftBorderB, .leftBorderG {
			border-top: 0;
			border-left: 3px solid #3c8dbc;
		}

		.leftBorderB {
			border-left: 3px solid #00c0ef;
		}

		.leftBorderG {
			border-left: 3px solid #39cccc;
		}

		.adminBox, .tipsBox {
			width: 100%;
			height: 125px;
			padding: 18px 0;
			padding-left: 6%;
		}

		.adminBoxPic {
			width: 89px;
			height: 89px;
			float: left;
		}

		.adminBoxPic img {
			width: 100%;
		}

		.adminMsg {
			max-width: 120px;
			padding-left: 20px;
			height: 89px;
			float: left;
			padding: 20px 0;
			padding-left: 15px;
		}

		.adminMsgTit {
			width: 100%;
			height: 20px;
			line-height: 20px;
			margin-bottom: 10px;
			font-size: 20px;
			font-weight: bold;
		}

		.adminMsgIn {
			width: 100%;
			height: 16px;
			line-height: 16px;
			font-size: 16px;
		}

		.tipsBox {
			padding: 37px 0;
			padding-left: 6%;
		}

		.tipsBoxInB, .tipsBoxInG {
			width: 50px;
			height: 50px;
			line-height: 50px;
			text-align: center;
			border-radius: 50%;
			background-color: #00c0ef;
			float: left
		}

		.tipsBoxInB span {
			color: #fff;
			font-size: 46px;
			font-weight: bold;
		}

		.tipsBoxInG {
			line-height: 68px;
			background-color: #39cccc;
		}

		.tipsBoxInG i {
			color: #fff;
			font-size: 32px;
			font-weight: bold;
		}

		.tipsMsg {
			width: auto;
			height: 54px;
			padding: 3px 0;
			padding-left: 10px;
			float: left;
		}

		.tipsMsgNum {
			width: auto;
			height: 28px;
			line-height: 28px;
			font-size: 34px;
			color: #999;
			margin-bottom: 2px;
		}

		.tipsMsgName {
			width: auto;
			height: 18px;
			line-height: 18px;
			font-size: 18px;
			color: #999;
		}

		.timeBox {
			width: 100%;
			height: 90px;
			padding: 10px 0;
		}

		.timeBox ul {
			padding: 0;
			margin: 0;
		}

		.timeBox li {
			width: 25%;
			height: 90px;
			border-right: 1px solid #e6e9ee;
			float: left;
			list-style: none;
		}

		.timeBox li:last-of-type {
			border-right: 0;
		}

		.timeBoxTit {
			width: 100%;
			height: 30px;
			line-height: 30px;
			text-align: center;
			font-size: 20px;
			color: #999;
			margin-bottom: 10px;
		}

		.timeBoxTit i {
			font-size: 24px;
		}

		.timeBox .orange {
			color: #f39c12;
		}

		.timeBox .Green {
			color: #00a65a;
		}

		.timeBox .Blue {
			color: #00c0ef;
		}

		.timeBox .Cyan {
			color: #39cccc;
		}

		.timeBoxNum {
			width: 100%;
			height: 40px;
			line-height: 40px;
			text-align: center;
			font-size: 36px;
		}

		.noticeBox {
			padding: 0;
			margin: 0;
		}

		.noticeBox li {
			width: 100%;
			height: 40px;
			line-height: 40px;
			color: #444;
			border-bottom: 1px solid #e6e9ee;
			padding: 0 5px;
			font-size: 14px;
			list-style: none;
		}

		.noticeBox li:last-of-type {
			border: 0;
		}

		.noticeBox li:hover {
			cursor: pointer;
			background-color: #f3f3f3;
		}

		.noticeBox li span {
			float: right;
			color: #999;
			font-size: 12px;
		}



		/*主页*/
		.indexMenuBox {
			width: 100%;
			height: auto;
			border-radius: 5px;
			border: 1px solid #e6e9ee;
			background-color: #fff;
			padding: 20px;
			margin-bottom: 20px;
		}

		.indexMenuBoxTit {
			width: 100%;
			line-height: 24px;
			margin-bottom: 10px;
			font-size: 18px;
			font-weight:bold;
			color:#3c8dbc;
		}

		.indexMenuBoxIn {
			width: 100%;
			height: auto;
		}

		.indexMenuBoxInL {
			width: 80px;
			height: auto;
			float: left;
		}

		.indexMenuBoxPic {
			width: 80px;
			line-height: 80px;
			height: 80px;
			border-radius: 5px;
			font-size: 36px;
			text-align: center;
			color: #fff;
		}

		.indexMenuBoxPic.orange {
			background-color: #f39c12;
		}

		.indexMenuBoxPic.Green {
			background-color: #00a65a;
		}

		.indexMenuBoxPic.Blue {
			background-color: #00c0ef;
		}

		.indexMenuBoxPic.Cyan {
			background-color: #39cccc;
		}

		.indexMenuBoxInR {
			width: 100%;
			height: auto;
		}

		.indexMenuBoxInR ul {
			padding: 0;
			margin: 0;
		}

		.indexMenuBoxInR li {
			width: 100%;
			line-height: 24px;
			padding-left: 2px;
			padding-top: 12px;
			font-size: 16px;
			padding-bottom: 12px;
		}

		:before {
			display: block !important;
			margin-bottom: 5px;
		}

		.content{
			min-height:100px;
		}
		.newBox .shortcutBox a{float:right;padding-right:20px;text-decoration:underline;}
		.newBody{padding:20px 30px;}
		.newBody a{display:block;width:100%;clear: both;overflow: hidden;height:25px;}
		.newBody a span{color:#333;width: 65%;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;display:inline-block;float:left;}
		.newBody a b{font-weight:400;color:#ccc;float:right;display:inline-block;width:30%;text-align: right;}
		
		.blockBox{height:152px;}
		.newBox{padding:0;}
		.newBox .newblockBox{padding-left:30px;padding-right:0px;}
		.newBox .newblockBox a .blockBox{padding:35px;padding-left:70px;padding-right:70px;}
		
		@media (min-width: 992px){
				.col-md-l-1{width: 12.5%;float: left;}				
		}
		@media (max-width: 768px) {
			.col-xs-l-1{width: 25%;float: left;}
			.col-xs-l-2{width: 50%;float: left;}
		}
		
		@media (min-width: 1100px) and (max-width: 1400px){
			.newBox .newblockBox a .blockBox{padding-left: 30px;padding-right: 30px}
		}
		
		@media (min-width: 320px) and (max-width: 768px){
			.col-xs-l-1{width: 25%;float: left;}
			.col-xs-l-2{width: 50%;float: left;}
			
			.newBox .shortcutBox{padding:0 0.1rem}
			.newBox .shortcutBox a{padding-right:0.2rem}
			
			.blockBoxTit{line-height: 0.18rem;font-size: 0.18rem; margin-bottom: 0.20rem}
			.blockBoxL{height:0.8rem;}
			.blockBoxR{line-height: 0.8rem;height:0.8rem;}
			.blockBoxNum{line-height: 0.42rem;font-size: 0.42rem;}
			.blockBoxR img{height: 0.74rem;}
			
			.iconFConn{width:0.97rem;height:0.97rem;line-height:0.97rem;margin-bottom:0.15rem;}
			.iconFConn img{width:0.53rem;}
			.iconFName{margin-bottom:0.4rem;}
			
			.newBody{padding:0.20rem 0.30rem;}
			.newBox .iconFBox{margin-bottom:0.24rem;}
			.content .newBox .newblockBox{padding-left:0;padding-right:0.12rem;}
			.content .newBox .newblockBox +.newblockBox{padding-left:0.12rem;padding-right:0;}
			.content .newBox .newblockBox a .blockBox{height:1.52rem;padding:0.35rem;padding-left:0.50rem;padding-right:0.50rem;margin-bottom:0.24rem;}
		
			.iconFBox .iconFBody{padding:0.3rem;}
		}

		.col-md-l-1,.col-xs-l-1{
		  	position: relative;
		    min-height: 1px;
		    padding-right: 15px;
		    padding-left: 15px;
		}
		
		
		
	</style>
</head>
<body style="background-color: #ecf0f5;">
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
		</ol>
	</header>
	<section class="content rlspace">
	
		<div class="row">		
			<c:forEach items="${user.roleList }" var="role">
				<c:if test="${role.name eq '东北办事处'}">
					<div class="col-md-6">
						<div class="iconFBox">
							<div class="shortcutBox">
								<div class="shortcutBoxR">常用功能</div>
							</div>
							<div class="iconFBody">
								<div class="row">
									<div class="col-md-3">
										<a id="travel" href="<%=base%>/manage/ad/travel/toList" >
											<div>
												<img src="<%=base%>/static/images/main/functionPic2.png" alt="">
											</div>
											<div class="iconFName">出差管理</div>
										</a>
									</div>
									<div class="col-md-3">
										<a id="finance" href="<%=base%>/manage/finance/management/toShow">
											<div>
												<img src="<%=base%>/static/images/main/functionPic8.png" alt="">
											</div>
											<div class="iconFName">报销申请</div>
										</a>
									</div>
									<div class="col-md-3">
										<div><a  href="<%=base%>/manage/ad/kpi/toList"><img src="<%=base%>/static/images/main/functionPic11.png" alt=""></a></div>
										<div class="iconFName"><a  href="<%=base%>/manage/ad/kpi/toList">绩效考核</a></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</c:if>
			</c:forEach>
			
		</div>
		
		<c:forEach items="${user.roleList }" var="role">
			<c:if test="${role.name eq '普通员工' or  role.name eq '总经理'}">

				<div class="col-md-6 col-xs-12 newBox">
					<div class="iconFBox" >
						<div class="shortcutBox">
							<div class="shortcutBoxR">公告栏</div>
							<a href="<%=base%>/manage/office/noitce/findNoticeToList">More</a>
						</div>
						<div id="noticeBoard" class="iconFBody newBody">
						</div>
					</div>
				</div>
				
				<div class="col-md-6 col-xs-12 newBox"> 
					<div class="col-md-6 col-xs-l-2 newblockBox">
						<a id="pendflow" href="<%=base%>/manage/office/pendflow/toList">
							<div class="blockBox">
								<div class="blockBoxL">
									<div class="blockBoxTit green">待办任务</div>
									<div class="blockBoxNum green" id="taskQuantity"></div>
								</div>
								<div class="blockBoxR"><img src="<%=base%>/static/images/main/icon03.png" alt=""></div>
							</div>
						</a>
					</div>
					
					<div class="col-md-6 col-xs-l-2 newblockBox">
						<a href="<%=base%>/manage/office/noitce/findNoticeToList">
							<div class="blockBox">
								<div class="blockBoxL">
									<div class="blockBoxTit orange">待阅通知</div>
									<div class="blockBoxNum orange" id="noticeQuantity"></div>
								</div>
								<div class="blockBoxR"><img src="<%=base%>/static/images/main/icon01.png" alt=""></div>
							</div>
						</a>
					</div>
				</div>

				<div class="row">
					<div class="col-md-12 col-xs-12">
						<div class="iconFBox" >
							<div class="shortcutBox">
								<div class="shortcutBoxR">常用功能</div>
							</div>
							<div class="iconFBody">
								<div class="row">
									<div class="col-md-l-1 col-xs-l-1" >
										<div><a class="iconFConn" href="<%=base%>/manage/ad/workReport/toList"><img src="<%=base%>/static/images/main/functionPic1.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/ad/workReport/toList">工作汇报</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1" >
										<div><a class="iconFConn" href="javascript:void(0)"><img src="<%=base%>/static/images/main/qingshi.png"></a></div>
										<div class="iconFName"><a href="javascript:void(0)">请示管理</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1" >
										<div><a class="iconFConn" href="javascript:void(0)"><img src="<%=base%>/static/images/main/gongwen.png"></a></div>
										<div class="iconFName"><a href="javascript:void(0)">公文管理</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1" >
										<div><a class="iconFConn" href="<%=base%>/manage/ad/travel/toList"><img src="<%=base%>/static/images/main/functionPic2.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/ad/travel/toList">出差管理</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/finance/management/toShow"><img src="<%=base%>/static/images/main/functionPic8.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/finance/management/toShow">报销申请</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/office/noitce/toList"><img src="<%=base%>/static/images/main/functionPic23.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/office/noitce/findPointToList">信息发布</a></div>
									</div>
									<shiro:hasAnyRoles name="boss,market">
									<!-- 市场、 总经理-->
										<div class="col-md-l-1 col-xs-l-1">
											<div><a class="iconFConn" href="<%=base%>/manage/ad/workmanage/toList"><img src="<%=base%>/static/images/main/functionPic6.png" alt=""></a></div>
											<div class="iconFName"><a href="<%=base%>/manage/ad/workmanage/toList">市场管理</a></div>
										</div>
									</shiro:hasAnyRoles>
									<c:if test="${sessionScope.user.id eq '27' or sessionScope.user.id eq '225'}">
										<div class="col-md-l-1 col-xs-l-1">
											<div><a class="iconFConn" href="<%=base%>/manage/finance/statisticspay/toList"><img src="<%=base%>/static/images/main/collection.png" alt=""></a></div>
											<div class="iconFName"><a href="<%=base%>/manage/finance/statisticspay/toList" class="">财务统计</a></div>
										</div>
									</c:if>
									<c:if test="${sessionScope.user.id eq 2}">
										<div class="col-md-l-1 col-xs-l-1">
											<div><a class="iconFConn" href="<%=base%>/manage/ad/filemanage/toList"><img src="<%=base%>/static/images/main/file.png" alt=""></a></div>
											<div class="iconFName"><a href="<%=base%>/manage/ad/filemanage/toList">文件管理</a></div>
										</div>
									</c:if>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/ad/overtime/toList"><img src="<%=base%>/static/images/main/functionPic7.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/ad/overtime/toList">加班管理</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/ad/legwork/toList"><img src="<%=base%>/static/images/main/functionPic25.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/ad/legwork/toList">外勤登记</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/ad/kpi/toList"><img src="<%=base%>/static/images/main/functionPic11.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/ad/kpi/toList">绩效考核</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/ad/leave/toList"><img src="<%=base%>/static/images/main/functionPic12.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/ad/leave/toList">请假管理</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/ad/seal/toList"><img src="<%=base%>/static/images/main/functionPic3.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/ad/seal/toList">印章管理</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/ad/car/toList"><img src="<%=base%>/static/images/main/functionPic9.png" alt=""></a></div>
										<div class="iconFName"><a  href="<%=base%>/manage/ad/car/toList">用车管理</a></div>
									</div>
									<div class="col-md-l-1 col-xs-l-1">
										<div><a class="iconFConn" href="<%=base%>/manage/ad/meeting/toList"><img src="<%=base%>/static/images/main/functionPic6.png" alt=""></a></div>
										<div class="iconFName"><a href="<%=base%>/manage/ad/car/toList">会议纪要</a></div>
									</div>

									<c:if test="${sessionScope.user.id ne 2 and sessionScope.user.id ne 36 and sessionScope.user.id ne 50}">
										<div class="col-md-l-1 col-xs-l-1">
											<div><a class="iconFConn" href="<%=base%>/manage/ad/rulesRegulation/toPage"><img src="<%=base%>/static/images/main/functionPic10.png" alt=""></a></div>
											<div class="iconFName"><a href="<%=base%>/manage/ad/rulesRegulation/toPage">规章制度</a></div>
										</div>
									</c:if>
									<shiro:hasAnyRoles name="xzzg,market,finance,boss">
									<!-- 行政主管、市场、财务、 总经理-->
										<div class="col-md-l-1 col-xs-l-1">
											<div><a class="iconFConn" href="<%=base%>/manage/sale/barginManage/toList"><img src="<%=base%>/static/images/main/functionPic4.png" alt=""></a></div>
											<div class="iconFName"><a href="<%=base%>/manage/sale/barginManage/toList">合同管理</a></div>
										</div>
										<div class="col-md-l-1 col-xs-l-1">
												<div><a class="iconFConn" href="<%=base%>/manage/sale/projectManage/toListNew"><img src="<%=base%>/static/images/main/functionPic17.png" alt=""></a></div>
												<div class="iconFName"><a href="<%=base%>/manage/sale/projectManage/toListNew" >项目管理</a></div>
											</div>
										<div class="col-md-l-1 col-xs-l-1">
											<div><a class="iconFConn" href="<%=base%>/manage/finance/pay/toList"><img src="<%=base%>/static/images/main/functionPic5.png" alt=""></a></div>
											<div class="iconFName"><a href="<%=base%>/manage/finance/pay/toList">付款管理</a></div>
										</div>
										<div class="col-md-l-1 col-xs-l-1">
											<div><a class="iconFConn" href="<%=base%>/manage/finance/collection/toList"><img src="<%=base%>/static/images/main/collection.png" alt=""></a></div>
											<div class="iconFName"><a href="<%=base%>/manage/finance/collection/toList">收款管理</a></div>
										</div>
									</shiro:hasAnyRoles>
									
									<shiro:hasAnyRoles name="officer,finance,boss">
										<shiro:hasAnyRoles name="finance,boss,qtwy">
										<!-- 总经理、财务、前台文员    查看 -->
											<div class="col-md-l-1 col-xs-l-1">
												<div><a class="iconFConn" href="<%=base%>/manage/ad/record/toList"><img src="<%=base%>/static/images/main/functionPic16.png" alt=""></a></div>
												<div class="iconFName"><a href="<%=base%>/manage/ad/record/toList" >人事管理</a></div>
											</div>
										</shiro:hasAnyRoles>
										<c:if test="${sessionScope.user.id eq 6 or sessionScope.user.id eq 83}">
											<!-- 用户id为6、83    查看 -->
											<div class="col-md-l-1 col-xs-l-1">
												<div><a class="iconFConn" href="<%=base%>/manage/ad/record/toList"><img src="<%=base%>/static/images/main/functionPic16.png" alt=""></a></div>
												<div class="iconFName"><a href="<%=base%>/manage/ad/record/toList" >人事管理</a></div>
											</div>
										</c:if>
										<shiro:hasAnyRoles name="officer,boss">
											<!-- 总经理、行政    查看 -->
											<div class="col-md-l-1 col-xs-l-1">
												<div><a class="iconFConn" href="<%=base%>/manage/organization/toList"><img src="<%=base%>/static/images/main/functionPic15.png" alt=""></a></div>
												<div class="iconFName"><a href="<%=base%>/manage/organization/toList" >组织架构</a></div>
											</div>
										</shiro:hasAnyRoles>
										<shiro:hasAnyRoles name="finance,boss">
											<!-- 总经理、财务    查看 -->
											<div class="col-md-l-1 col-xs-l-1">
												<div><a class="iconFConn" href="<%=base%>/manage/finance/management/toList"><img src="<%=base%>/static/images/main/functionPic13.png" alt=""></a></div>
												<div class="iconFName"><a href="<%=base%>/manage/finance/management/toList" >报销管理</a></div>
											</div>
											<div class="col-md-l-1 col-xs-l-1">
												<div><a class="iconFConn" href="<%=base%>/manage/finance/statisticspay/toList"><img src="<%=base%>/static/images/main/count.png" alt=""></a></div>
												<div class="iconFName"><a href="<%=base%>/manage/finance/statisticspay/toList" >财务统计</a></div>
											</div>
											<div class="col-md-l-1 col-xs-l-1">
												<div><a class="iconFConn" href="<%=base%>/manage/finance/invest/toList"><img src="<%=base%>/static/images/main/functionPic14.png" alt=""></a></div>
												<div class="iconFName"><a href="<%=base%>/manage/finance/invest/toList" >费用归属</a></div>
											</div>
										</shiro:hasAnyRoles>
										<shiro:hasAnyRoles name="boss">
											<!-- 总经理    查看 -->
											<div class="col-md-l-1 col-xs-l-1">
												<div><a class="iconFConn" href="<%=base%>/manage/ad/rulesRegulation/toPage"><img src="<%=base%>/static/images/main/functionPic24.png" alt=""></a></div>
												<div class="iconFName"><a href="<%=base%>/manage/ad/rulesRegulation/toPage" >规章制度</a></div>
											</div>
										</shiro:hasAnyRoles>
									</shiro:hasAnyRoles>
								</div>
							</div>
						</div>
					</div>
				</div>
			</c:if>
		</c:forEach>
	</section>
	<%-- <select id="noticeType" style="display:none;">
		<custom:dictSelect type="公告类型"/>
	</select>
	<section class="col-lg-12 connectedSortable ui-sortable" >
		<div class="box  box-solid" style="display:none;">
			<div class="box-header">
				<a href="<%=base%>/manage/office/noitce/toList" title="点击可跳转到信息发布" style="padding:10px; background:none;">
					<h3 class="box-title" style="width:100%; height:100%;font-weight:bold;">最新公告</h3>
				</a>
			</div>
			<div class="box-body">
				<ul class="noticeBox">
					<c:forEach items="${noticeList }" var="notice">
						<c:if test="${fn:length(notice.title) > 100}">
							<li value="${notice.isRead }" title="${notice.title }" onclick="viewNotice(${notice.id}, this)">
									${fn:substring(notice.title, 0, 100)}...
								<span><fmt:formatDate value="${notice.createDate}" pattern="yyyy-MM-dd" /></span>
							</li>
						</c:if>
						<c:if test="${fn:length(notice.title) <= 100}">
							<li value="${notice.isRead }" onclick="viewNotice(${notice.id}, this)">
									${notice.title }
								<span><fmt:formatDate value="${notice.createDate}" pattern="yyyy-MM-dd" /></span>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</div>
	</section> --%>
</div>
<input id="userId"  name="userId" type="hidden" value="${sessionScope.user.id}">
<div id="deptDialog"></div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="noticeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%;">
    	<div class="modal-content">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel"></h4>
         	</div>
	        <div class="modal-body" style="overflow:auto; padding-top:0px;">
	        	<div class="row">
					<div class="col-md-12">
						<div class="tbspace" style="padding-top:0px !important;">
							<form id="form1">
								<table id="table1">
									<thead>
										<tr><th colspan="8" id="title" style="padding:0.5em 0px;"></th></tr>
									</thead>
									<tbody>
										<tr><td colspan="8"><div id="content"></div></td></tr>
										<tr>
											<td colspan="20">
												<span>附件：</span>
												<a href="javascript:void(0)"><input type="text" id="attachName" name="attachName" style="width:90%;" value="" readonly></a>
											</td>
										</tr>
										<tr>
											<td><span></span></td>
											<td colspan="20"><input type="text" id="dept" name="dept" value="" readonly></td>
										</tr>
										<tr>
											<td><span></span></td>
											<td colspan="20" ><input type="text" id="updateDate" value="" readonly></td>
										</tr>
										<tr>
											<td colspan="20">
												<div id="details_div" class="box box-primary collapsed-box" style="box-shadow:none;">
										            <div class="box-header with-border">
										              <h3 class="box-title"></h3>
										              <div class="box-tools pull-right">
										                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>
										              </div>
										            </div>
										            <div class="box-body">
								            			<table>
											            	<tr>
																<td class="text-right"><span>拟稿人：</span></td>
																<td colspan="1"><input type="text" id="createBy" value="" readonly></td>
																<td class="text-right"><span>签发人：</span></td>
																<td ><input type="text" id="approver" value="" readonly></td>
															</tr>
															<tr>
																<td class="text-right" style="width:9%;"><span>类型：</span></td>
																<td ><input type="text" id="type2" value="" readonly></td>
																<td class="text-right" style="width:11%;"><span>抄送：</span></td>
																<td style="width:70%;"><textarea id="deptName" name="deptName" readonly></textarea></td>
															</tr>
														</table>
										            </div>
									            </div>
											</td>
										</tr>
									</tbody>
								</table>
							</form>
						</div>
					</div>
				</div>
			</div>
	      	<div class="modal-footer"></div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<c:set var="deptId" value="${user.deptId}"/>
<script>
	var deviceWidth = document.documentElement.clientWidth > 768 ? 768 : document.documentElement.clientWidth;
	document.getElementsByTagName('html')[0].style.cssText = 'font-size:' + deviceWidth / 7.68 + 'px !important';

	
	var base = "<%=base%>";
	var deptId  = "${deptId}";
	var approve = '<shiro:hasPermission name="ad:kpi:approve">true</shiro:hasPermission>';
	
    var deptList = JSON.parse('${deptList}');
    var deptMap = {};
    var parentDeptList = [];
    $(deptList).each(function(index, dept) {
        if (dept.level == 1) {
            parentDeptList.push(dept);
        }
        deptMap[dept.id] = dept;
    });
    var noticeObj = null;

    $(function() {
        initNoticeType();
        /* initPoint();
        initDocment(); */
        initTodo();
        initReimburs();
        getTop5Notice();
        initNotice();
    });
    
    function getTop5Notice(){
    	 $.ajax({
             url: base+'/manage/office/noitce/getTop5Notice',
             dataType: 'JSON',
             contentType: 'application/json;charset=utf-8;',
             data:{},
             success: function(data) {
            	 var html = "";
            	 $.each(data,function(i,val){ 
            		 if(i<3){
            			 if(val.isRead){     
                			 html += "<a href='javascript:void(0)' value='"+val.isRead+"' title='"+val.title+"' onclick='viewNotice("+val.id+",this)'><span style=color:#999>"+val.title+"</span><b>"+fmtDate(val.createDate)+"</b></a>"
                		 }else{
                			 html += "<a href='javascript:void(0)' value='"+val.isRead+"' title='"+val.title+"' onclick='viewNotice("+val.id+",this)'><span>"+val.title+"</span><b>"+fmtDate(val.createDate)+"</b></a>"
                		 } 
            		 }
            		
            	 })
            	 $("#noticeBoard").empty();
            	 $("#noticeBoard").append(html);
             }
         });
    }
    
    function initNotice(){
        $.ajax({
            url: base+"/manage/office/noitce/getNoticeCount?timetamp="+new Date().getTime(),
            success: function(data) {
                var url = "javascript:forward('"+web_ctx+"/manage/office/noitce/toList');";
                var count = "";
                if(!isNull(data) && data > 0){
                    count = data;
                }else{
                    count = 0 ;
                }
                $("#noticeQuantity").text(count);
            },
            error: function(data) {
                bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
            }
        });
    }


    function initPoint(){
        $.ajax({
            url: base+"/manage/office/noitce/getUnreadCount?timetamp="+new Date().getTime()+"&type="+"2",
            success: function(data) {
                var url = "javascript:forward('"+web_ctx+"/manage/office/noitce/toList');";
                var count = "";
                if(!isNull(data) && data > 0){
                    count = data;
                }else{
                    count = 0 ;
                }
                $("#noticeQuantity").text(count);
            },
            error: function(data) {
                bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
            }
        });
    }
	
    function fmtDate(obj){
        var date =  new Date(obj);
        var y = 1900+date.getYear();
        var m = "0"+(date.getMonth()+1);
        var d = "0"+date.getDate();
        return y+"-"+m.substring(m.length-2,m.length)+"-"+d.substring(d.length-2,d.length);
    }

    function initDocment(){
        $.ajax({
            url: base+"/manage/office/noitce/getUnreadCount?timetamp="+new Date().getTime()+"&type="+"1",
            success: function(data) {
                var url = "javascript:forward('"+web_ctx+"/manage/office/noitce/toList');";
                var count = "";
                if(!isNull(data) && data > 0){
                    count = data;
                }else{
                    count = 0 ;
                }
                $("#documentQuantity").text(count);
            },
            error: function(data) {
                bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
            }
        });
    }

    //查看当前用户绩效考核状态，当月没有查上月
    function getKpi(){
        var status = "";
        $.ajax({
            url: base+'/manage/ad/kpi/getStatus?timetamp='+new Date().getTime(),
            dataType: 'JSON',
            async: false,
            contentType: 'application/json;charset=utf-8;',
            data:{"deptId":deptId,"time":new Date()},
            success: function(data) {
                status = data;
            }
        });
        return status;
    }

    function initTodo() {
        var userId = $("#userId").val();
        var marketAssistant = false;
        if(userId == '225'){
            marketAssistant = true;//当前用户是市场部部门助手
        }
        $.ajax({
            url: base+"/manage/office/pendflow/getTodoList?timetamp="+new Date().getTime(),
            dataType: "json",
            success: function(data) {
                if(!isNull(data) && data.length > 0) {
                    if(marketAssistant){
                        var count = 0;
                        for (var i = 0; i < data.length; i++) {
                            if(!isNull(data[i].processName) && (data[i].processName == "通用报销流程" ||  data[i].processName == "出差报销流程" ) 
                            		&& data[i].business.assistantStatus != '1'){
                                count = count +1;
                            }
                        }
                        if((getKpi() == "" || getKpi() == null)&&(approve||deptId == 2)){
                            $("#taskQuantity").text(count+1);
                        }else{
                            $("#taskQuantity").text(count);
                        }
                    }else{
                        if((getKpi() == "" || getKpi() == null)&&(approve||deptId == 2)){
                            $("#taskQuantity").text(data.length+1);
                        }else{
                            $("#taskQuantity").text(data.length);
                        }
                    }
                }else {
                    if((getKpi() == "" || getKpi() == null)&&(approve||deptId == 2)){
                        $("#taskQuantity").text(1);
                    }else{
                        $("#taskQuantity").text("0");
                    }
                }
            },
            error: function(data) {
                bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
            }
        });
    }

    function initReimburs(){
        $.ajax({
            url: base+"/manage/finance/management/showSize",
            dataType: "json",
            success: function(data) {
                if(!isNull(data)) {
                    $("#reimbursQuantity").text(data);
                }
            },
            error : function(data) {
                bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
            }
        });
    }

    function save() {
        $.ajax({
            url : "save?isDetail=true",
            type : "post",
            data : $("#form1").serializeJson(),
            dataType : "json",
            success : function(data) {
                if (data.code == 1) {
                    parent.location.replace(location.href);
                } else {
                    bootstrapAlert("提示", data.result, 400, null);
                }
            },
            error : function(data) {
                bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
            }
        });
    }

    var typeMap = {}
    function viewNotice(id, li) {
        $.ajax({
        	url : web_ctx + "/manage/office/noitce/getNotice?id="+ id,
            type : "get",
            dataType : "json",
            success : function(data) {
            	$("#form1")[0].reset();
                $("#attachName").text("");
                $("#attachName").attr("href", "javascript:void(0);");
                $("#attachName").removeAttr("target");
				noticeObj = li;
				if (!$("#details_div").hasClass("collapsed-box")) {
                	$("#details_div").find("button").trigger("click");
                }
                if (!isNull(data)) {
                	// 设置模态框内容
                    $("#title").html(data.title);

                    $("#type2").val(typeMap[data.type]);
                    $("#createBy").val(!isNull(data.user) ? data.user.name: "");
                    $("#updateDate").val(new Date(!isNull(data.actualPublishTime) ? data.actualPublishTime : data.createDate).pattern("yyyy-MM-dd"));
                    $("#content").html(data.content);

                    if (data.type == 1) {
                    	$("#approver").val(!isNull(data.approver) ? data.approver.name : "");
                        $("#approver").parent("td").show();
                        $("#approver").parent("td").prev().show();
                    } else {
                        $("#approver").parent("td").hide();
                        $("#approver").parent("td").prev().hide();
                    }

                    // 附件
                    if (!isNull(data.attachName)) {
                    	$("#attachName").parents("tr").show();
                        $("#attachName").val(data.attachName);
                        $("#attachName").parent("a").attr("href", web_ctx + data.attachments);
                        $("#attachName").parent("a").attr("target", "_blank");
                    } else {
                    	$("#attachName").parents("tr").hide();
                    }

                    // 发布部门
                    var companyName = "";
                    var deptName = "";
                    var dept = deptMap[data.publisherId];
                    if (!isNull(dept)) {
                    	var nodeLinks = dept.nodeLinks.split(",");
                        if (nodeLinks.length > 3) {
                        	companyName = deptMap[nodeLinks[2]].name; // 数组的第3位是公司
                        }
                        deptName = dept.name;
                    }
                    if (data.publishers.name.indexOf("总经理") > -1 || data.publishers.name.indexOf("副总经理") > -1) {
                    	deptName = "";
                    }
                    $("#dept").val(companyName + " " + deptName);

                    // 抄送
                    var deptList = [];
                    if (!isNull(data.deptIds)) {
                    	var deptIds = data.deptIds.split(",");
                        $(deptIds).each(function(index, id) {
                        	deptList.push(deptMap[id]);
                        });
                    } else {
                    	$(parentDeptList).each(
                        	function(index, dept) {
                            	deptList.push(dept);
                        });
                    }
                    var res = sendScope(deptList);
                    $("#deptName").text(res.deptName.join("\r\n"));

                    // 设置模态框高度
                    var bodyHeight = $(window).height();
                    var modalHeight = bodyHeight * 0.7;
                    $("#noticeModal").find(".modal-body").css("max-height", modalHeight);

                    // 设置模态框操作按钮
                    var button = [];
                    var isRead = $(li).attr("value");
                    if (isRead == false || isRead == "false" && data.approveStatus == "1") {
                    	button.push('<button type="button" class="btn btn-primary" onclick="setReadStatus('
                                    + id + ')">已阅</button>');
                    }
                    button.push('<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>');
                    $("#noticeModal").find(".modal-footer").html("");
                    $("#noticeModal").find(".modal-footer").append(button.join(" "));

                    // 显示模态框
                    $("#noticeModal").modal("show");

                 } else {
                 	bootstrapAlert("提示", "抱歉，没有此公告数据！", 400, null);
                 }
             },
             error : function(e) {
                 bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
             }
        });
    }

    function setReadStatus(id) {
        $.ajax({
            url : web_ctx + "/manage/office/noitce/setReadStatus?id=" + id,
            type : "post",
            data : {"noticeId" : id},
            dataType : "json",
            success : function(data) {
                if (!isNull(data) && data.code == 1) {
                    $(noticeObj).attr("value", "true");
                    window.parent.initNotice();
                    $("#noticeModal").modal("hide");
                    /* 	 	bootstrapAlert("提示", "您已阅读该发布信息", 400, null);  */
                } else {
                    bootstrapAlert("提示", data.result, 400, null);
                }
            },
            error : function(e) {
                bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
            }
        });
        getTop3Notice();
    }

    function initNoticeType() {
        $("#noticeType").find("option").each(function(index, option) {
            typeMap[$(option).attr("value") + ""] = $(option).text() + "";
        });
    }

    //计算抄送范围的部门字符串
    function sendScope(deptList) {
        var deptName = [];
        var deptIds = [];
        var deptNameTree = {};

        $(deptList).each(function(index, dept) {
            try {
                deptIds.push(dept.id);

                if (dept.level == 1) { // 树的第一级为公司，只做添加
                    deptNameTree[dept.id] = {
                        "id" : dept.id,
                        "name" : dept.name,
                        "children" : []
                    };
                } else if (dept.level == 2) { // 树的第二级为部门，需要跟公司挂钩
                    var parent = deptMap[dept.parentId];
                    if (isNull(deptNameTree[parent.id])) {
                        deptNameTree[parent.id] = {
                            "id" : parent.id,
                            "name" : parent.name,
                            "children" : [ {
                                "id" : dept.id,
                                "name" : dept.name,
                                "children" : []
                            } ]
                        };
                    } else {
                        var children = deptNameTree[parent.id].children;
                        children.push({
                            "id" : dept.id,
                            "name" : dept.name,
                            "children" : []
                        });
                    }
                } else { // 树的其他级，需要挂钩到部门，最终挂钩到公司
                    var nodeLinks = dept.nodeLinks.split(",");
                    nodeLinks = nodeLinks.slice(2); // 获取从公司到当前选择机构的路径链接

                    var prevDept = null; // 始终保存上一级树
                    $(nodeLinks).each(function(index, link) {
                        if (index == 0) { // 索引为0，则是树的第一级，为公司
                            var parent = deptNameTree[link];
                            if (isNull(parent)) {
                                var tempDept = deptMap[link];
                                var temp = {
                                    "id" : tempDept.id,
                                    "name" : tempDept.name,
                                    "children" : []
                                };
                                deptNameTree[tempDept.id] = temp;
                                prevDept = temp;
                            } else {
                                prevDept = parent;
                            }
                        } else {
                            var isHas = false; // 上一级部门（prevDept）的 children 是否已经存在当前树
                            var children = prevDept.children;
                            var tempDept = deptMap[link];

                            $(children).each(function(index, child) {
                                if (child.id == tempDept.id) {
                                    isHas = true;
                                    prevDept = child;
                                }
                            });
                            if (!isHas) {
                                var temp = {
                                    "id" : tempDept.id,
                                    "name" : tempDept.name,
                                    "children" : []
                                };
                                children.push(temp);
                                prevDept = temp;
                            }
                        }
                    });
                }
            } catch (e) {
                console.error(e);
            }
        });

        // 构建每一个以公司为单位的树的部门名称，比如xxx公司(a部门,b部门), yyy公司(a部门,b部门)
        for ( var key in deptNameTree) {
            var value = deptNameTree[key];
            var tempDeptName = [];
            buildDeptName(tempDeptName, value);
            deptName.push(tempDeptName.join(""));
        }

        return {
            "deptName" : deptName,
            "deptIds" : deptIds
        };
    }

    function buildDeptName(deptName, dept) {
        if (isNull(dept.children)) {
            deptName.push(dept.name);
        } else {
            deptName.push(dept.name);
            deptName.push("(");
            $(dept.children).each(function(index, child) {
                if (index > 0) {
                    deptName.push(",");
                }
                deptName.push(buildDeptName(deptName, child));
            });
            deptName.push(")");
        }
    }
</script>
</body>
</html>