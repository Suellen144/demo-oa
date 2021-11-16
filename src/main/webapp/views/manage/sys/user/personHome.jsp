<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="../../common/header.jsp"%>
    <link rel="stylesheet" href="<%=base%>/static/css/index.css">

   	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
  		<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  	<![endif]-->
  	
  	<style>
  		.modal-dialog{width:730px;}
  		.modal-dialog .modal-content{border-radius: 10px;overflow: hidden;}
  		.modal-dialog .modal-body{padding:15px 50px;}
  		#table1{width:100%;}
  		#table1 #title{margin: 0;text-align: center;font-size: 18px; font-weight: bold;padding-top:10px;padding-bottom:45px;} 		
  		.modal-dialog .noticeCont p{font-size:14px;color:#333;}
  		.modal-dialog .noticeDate{border-bottom:1px solid #d7d7d7;padding-bottom: 30px;}
  		#dept,#updateDate{text-align: right;color:#999;}
  		#dept span{display:inline-block;width:150px;}
  		#updateDate{padding-top:5px}
  		#updateDate span:first-child{padding-right:25px;}
  		.modal-dialog .noticeCC ul{list-style: none;margin:0;padding:0;}
  		.noticeEnclosure{margin-bottom:20px;padding-top:10px;color:#4289FF;}
  		.noticeEnclosure:before{content: '附件：';font-size:14px;color:#999;position: relative;left: 0;top: 0;}
  		.noticeEnclosure:hover{color:#4289FF;}
  		.modal-dialog .noticeCC ul li{line-height:20px;font-size:12px;}
  		.modal-dialog .noticeCC ul li:first-child{margin-bottom:10px;margin-top:30px;}
  		.modal-dialog .noticeCC ul li span{line-height:20px;color:#999;}
  		.modal-dialog .noticeCC ul li div p{line-height:25px;color:#999;}
  		.box.box-primary{border-top:1px solid #d7d7d7;margin-top:20px;}
  		#approver{display:none;margin-bottom:10px}
  		
  		#performance{cursor: default}
  	</style>
</head>
<body>

<!-- 第一块 -->
<section class="main-1 clearfix">
    <div id="myCarousel" class="main-1-carousel carousel slide" data-ride="carousel" data-interval="3000">
   <!--      <ol class="carousel-indicators">
            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#myCarousel" data-slide-to="1"></li>
            <li data-target="#myCarousel" data-slide-to="2"></li>
        </ol>   --> 
        <!-- 轮播（Carousel）项目 -->
        <div class="carousel-inner">
            <div class="item active">
                <div class="time-con">
                    <p class="date"></p>
                    <p class="date-day"></p>
                    <p class="date-tiem"></p>
                </div>
            </div>
            <div class="item">
            	<a href="javascript:void(0)" id="performance"><img alt="" src="<%=base%>/static/images/performance/performance_ranking4.jpg"></a>
            </div>
            <!-- <div class="item">
                无
            </div> -->
        </div>
         <ol class="carousel-indicators">
	        <li data-target="#myCarousel" data-slide-to="0" 
	            class="active"></li>
	        <li data-target="#myCarousel" data-slide-to="1"></li>
	        
	    </ol> 
    </div>
    <div class="main-1-ad pannel-main">
        <div class="pan-top">
            公告栏
            <a class="more" href="<%=base%>/manage/office/noitce/findNoticeToList">
                <i></i>
            </a>
        </div>
        <div class="pan-con">
        </div>
    </div>
    <div class="main-1-tz">
    	<a id="pendflow" href="<%=base%>/manage/office/pendflow/toList"> 
    		<div class="tz-task tz-con">
	            <i class="icon"></i>
	            <p class="number" id="taskQuantity">0</p>
	            <p class="text-su">待办任务</p>
	        </div>
    	</a>
    	<a href="<%=base%>/manage/office/noitce/findNoticeToList">
    		<div class="tz-notice tz-con">
	           <i class="icon tz-icon"></i>
	           <p class="number" id="noticeQuantity">0</p>
	           <p class="text-su">待阅通知</p>
	       </div>
    	</a> 
    </div>
</section>

<section class="main-2">
    <div class="pannel-main">
        <div class="pan-top">
            常用功能
            <a class="more dn" href="">
                <i></i>
            </a>
        </div>
        <div class="pan-con use-fn" style="min-height: 450px;">
        	<c:forEach items="${user.roleList }" var="role">
        		<c:if test="${role.name eq '普通员工' or  role.name eq '总经理' or  role.deptId eq 2}">
        			<a href="<%=base%>/manage/ad/workReport/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-1">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">工作汇报</p>
		                </div>
		            </a>
		            <a href="<%=base%>/static/images/main/qingshi.png">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-2">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">请示管理</p>
		                </div>
		            </a>
		            <a href="<%=base%>/static/images/main/gongwen.png">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-3">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">公文管理</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/ad/travel/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-4">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">出差管理</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/finance/management/toShow">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-5">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">报销申请</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/office/noitce/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-6">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">信息发布</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/ad/overtime/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-7">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">加班管理</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/ad/legwork/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-8">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">外勤登记</p>
		                </div>
		            </a>
		
		            <a href="<%=base%>/manage/ad/kpi/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-11">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">绩效考核</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/ad/leave/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-12">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">请假管理</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/ad/seal/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-13">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">印章管理</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/ad/car/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-14">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">用车管理</p>
		                </div>
		            </a>
		            <a href="<%=base%>/manage/ad/meeting/toList">
		                <div class="fn-box">
		                    <div class="fn-url fn-icon-15">
		                        <i class="fn-icon"></i>
		                    </div>
		                    <p class="fn_txt">会议纪要</p>
		                </div>
		            </a>
	        		<!-- 市场、 总经理-->
	        		<shiro:hasAnyRoles name="boss,market,generalAssistance">
	        			<a href="<%=base%>/manage/ad/workmanage/toList">
			                <div class="fn-box">
			                    <div class="fn-url fn-icon-9">
			                        <i class="fn-icon"></i>
			                    </div>
			                    <p class="fn_txt">市场管理</p>
			                </div>
			            </a>
					</shiro:hasAnyRoles>
					<c:if test="${sessionScope.user.id eq '27' or sessionScope.user.id eq '225'}">
						<a href="<%=base%>/manage/finance/statisticspay/toList">
			                <div class="fn-box">
			                    <div class="fn-url fn-icon-19">
			                        <i class="fn-icon"></i>
			                    </div>
			                    <p class="fn_txt">财务统计</p>
			                </div>
			            </a>
					</c:if>
					<c:if test="${sessionScope.user.id eq 2}">
						<a href="<%=base%>/manage/ad/filemanage/toList">
			                <div class="fn-box">
			                    <div class="fn-url fn-icon-10">
			                        <i class="fn-icon"></i>
			                    </div>
			                    <p class="fn_txt">文件管理</p>
			                </div>
			            </a>
					</c:if>
					<c:if test="${sessionScope.user.id ne 2 and sessionScope.user.id ne 36 and sessionScope.user.id ne 50}">
						<a href="<%=base%>/manage/ad/rulesRegulation/toPage">
			                <div class="fn-box">
			                    <div class="fn-url fn-icon-16">
			                        <i class="fn-icon"></i>
			                    </div>
			                    <p class="fn_txt">规章制度</p>
			                </div>
			            </a>
					</c:if>
					<shiro:hasAnyRoles name="qtwy">
					<a href="<%=base%>/manage/sale/barginManage/toList">
						<div class="fn-box">
							<div class="fn-url fn-icon-17">
								<i class="fn-icon"></i>
							</div>
							<p class="fn_txt">合同管理</p>
						</div>
					</a>
					</shiro:hasAnyRoles>
					<c:if test="${sessionScope.user.id == 523}">
					<a href="<%=base%>/manage/sale/barginManage/toList">
						<div class="fn-box">
							<div class="fn-url fn-icon-17">
								<i class="fn-icon"></i>
							</div>
							<p class="fn_txt">合同管理</p>
						</div>
					</a>
					 <a href="<%=base%>/manage/sale/projectManage/toListNew">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-18">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">项目管理</p>
				                </div>
				            </a>
					</c:if>
					<!-- 行政主管、市场、财务、 总经理-->
					<shiro:hasAnyRoles name="xzzg,market,finance,boss,generalAssistance">
						<a href="<%=base%>/manage/sale/barginManage/toList">
			                <div class="fn-box">
			                    <div class="fn-url fn-icon-17">
			                        <i class="fn-icon"></i>
			                    </div>
			                    <p class="fn_txt">合同管理</p>
			                </div>
			            </a>
			             <a href="<%=base%>/manage/sale/projectManage/toListNew">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-18">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">项目管理</p>
				                </div>
				            </a>
			            <a href="<%=base%>/manage/finance/pay/toList">
			                <div class="fn-box">
			                    <div class="fn-url fn-icon-21">
			                        <i class="fn-icon"></i>
			                    </div>
			                    <p class="fn_txt">付款管理</p>
			                </div>
			            </a>
			            <a href="<%=base%>/manage/finance/collection/toList">
			                <div class="fn-box">
			                    <div class="fn-url fn-icon-22">
			                        <i class="fn-icon"></i>
			                    </div>
			                    <p class="fn_txt">收款管理</p>
			                </div>
			            </a>
					</shiro:hasAnyRoles>
					<shiro:hasAnyRoles name="officer,finance,boss">
						<!-- 总经理、财务、前台文员    查看 -->
						<shiro:hasAnyRoles name="finance,boss,qtwy">
							<a href="<%=base%>/manage/ad/record/toList">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-23">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">人事管理</p>
				                </div>
				            </a>
						</shiro:hasAnyRoles>
						<!-- 用户id为6、83    查看 -->
						<c:if test="${sessionScope.user.id eq 6 or sessionScope.user.id eq 83}">
							<a href="<%=base%>/manage/ad/record/toList">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-23">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">人事管理</p>
				                </div>
				            </a>
						</c:if>
						<!-- 总经理、行政    查看 -->
						<shiro:hasAnyRoles name="officer,boss">
							<a href="<%=base%>/manage/organization/toList">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-24">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">组织架构</p>
				                </div>
				            </a>
						</shiro:hasAnyRoles>
						<!-- 总经理、财务    查看 -->
						<shiro:hasAnyRoles name="finance,boss">
							<a href="<%=base%>/manage/finance/management/toList">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-25">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">报销管理</p>
				                </div>
				            </a>
				            <a href="<%=base%>/manage/finance/statisticspay/toList">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-19">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">财务统计</p>
				                </div>
				            </a>
				            <a href="<%=base%>/manage/finance/invest/toList">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-20">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">费用归属</p>
				                </div>
				            </a>
						</shiro:hasAnyRoles>
						<!-- 总经理    查看 -->
						<shiro:hasAnyRoles name="boss">
							<a href="<%=base%>/manage/ad/rulesRegulation/toPage">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-16">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">规章制度</p>
				                </div>
				            </a>
						</shiro:hasAnyRoles>
					</shiro:hasAnyRoles>
					<shiro:hasAnyRoles name="generalAssistance">
							<a href="<%=base%>/manage/finance/management/toList">
				                <div class="fn-box">
				                    <div class="fn-url fn-icon-25">
				                        <i class="fn-icon"></i>
				                    </div>
				                    <p class="fn_txt">报销管理</p>
				                </div>
				            </a>
		            </shiro:hasAnyRoles>
        		</c:if>
			</c:forEach>
        </div>
    </div>
</section>

<select id="noticeType" style="display:none;">
	<custom:dictSelect type="公告类型"/>
</select>


<div id="deptDialog"></div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="noticeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:730px;">
    	<div class="modal-content">
        	<div class="modal-header">
        		<span class='modal-headerT'></span>
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
										<tr><th colspan="8" id="title" style="padding:20px 0px 30px 0px;"></th></tr>
									</thead>
									<tbody>
										<tr><td colspan="8"><div id="content"></div></td></tr>
										<tr>
											<td colspan="20">
												<a href="javascript:void(0)" class='noticeEnclosure' id="attachName"></a>
											</td>
										</tr>
										<tr>
											<td><span></span></td>
											<td colspan="20">
												<p id="dept"><span></span></p>
											</td>
										</tr>
										<tr>
											<td><span></span></td>
											<td colspan="20" >
												<p id="updateDate"><span></span><span></span><p>
											</td>
										</tr>
										<tr>
											<td colspan="20">
												<div id="details_div" class="box box-primary collapsed-box" style="box-shadow:none;">
										            <div class="box-body" style="display:block;">
										            	<div class="noticeCC">
										            		<ul>
											            		<li id="createBy"><span>拟稿人：</span><span></span></li>
											            		<li id="approver"><span>签发人：</span><span></span></li>
																<li id="deptName"><span>抄送：</span><div></div></li>
															</ul>
														</div>
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
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->
<!-- 模态框（Modal） -->
<div class="modal fade" id="noticeModal1" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
<div class="modal-dialog" style="width:65%;">
    	<div class="modal-content">
        	<div class="modal-header">
        		<span class='modal-headerT'></span>
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel"></h4>
         	</div>
	        <div class="modal-body" style="overflow:auto; padding-top:0px;">
			<img src="<%=base%>/static/images/performance/performance_ranking1.png" style="width:100%">
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->
<input id="userId" name="userId" type="hidden" value="${sessionScope.user.id}">
<c:set var="deptId" value="${user.deptId}"/>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script src="<%=base%>/static/js/jQuery-2.2.0.min.js"></script>
<script src="<%=base%>/static/bootstrap/js/bootstrap.min.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sys/user/js/personHome.js"></script>

<script type="text/javascript">
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
    
    $(".pannel-main .pan-con").find('a').click(function(){
    	parent.$(".main-header").addClass('wheader100')
		parent.$("#content").addClass('content100')
    })
</script>
</body>
</html>