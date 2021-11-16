<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/css/oaMobile.css">
<style type="text/css">
textarea[name="projectName"],textarea[name="reason"],textarea[name="detail"]{
	padding-top:5px;
	text-align:left;
	width: 100%;
	color:gray;
	font-size: 12px;
	height: 30px;
	outline: none;
	border:none;
	margin-left: -5px;
}
textarea {
	resize: none;
	outline: medium;
	width:100%;
}

.firstSelect{
	float: left;
}
.firstInput{
	float: left;
	}
	
.firstMsg{
position: relative;}
.secondMsg{
	position: relative;
	z-index: 2;
}
.thirdMsg{
position: relative;
top:0px}
.mFormOpe{
position: absolute;
top:0px;
right:8px;
z-index:9;}
.mFormOpe1{
position: absolute;
top:0px;
right:18px;
z-index:9;
}
</style>

</head>
<body class="hold-transition skin-blue sidebar-mini">
	<!-- Site wrapper -->

			<!-- Content Header (Page header) -->
			<section class="content-header">
				<span style="font-size:20px;font-weight: bold;">通用报销单<%--<i class="icon-question-sign" style="cursor:pointer"  onclick="showhelp()"> </i>--%></span>
				<span style="font-size:smaller;font-weight:normal;position:absolute;line-height:2em;">(报销单号：${map.business.orderNo })</span>
										<shiro:hasPermission name="fin:reimburse:encrypt">
											<c:if test="${map.business.encrypted ne 'y' }">
												<i class="icon-eye-close"  style="cursor:pointer"  onclick="lock()"> </i>
											</c:if>
										</shiro:hasPermission>
			</section>

			<!-- Main content -->
			<section class="content">
				<!-- Default box -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<select id="type_hidden" style="display:none;">
							<custom:dictSelect type="通用报销类型"/>
						</select>
					
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
						<input type="hidden" id="taskName" name="taskName" value="${map.task.name}">
						<input type="hidden" id="id" name="id" value="${map.business.id}">
						<input type="hidden" id="cost" name="cost" value="<fmt:formatNumber value='${map.business.cost }' pattern='#.##' />">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments }">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName }">
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="userId" name="userId" value="${map.business.userId }">
						<input type="hidden" id="deptId" name="deptId" value="${map.business.deptId }">
						<input type="hidden" id="encrypted" name=encrypted value="${map.business.encrypted }">
						<input type="hidden" id="assistantStatus" name="assistantStatus" value="${map.business.assistantStatus}">
						<input type="hidden" id="operStatus" value="">
						<c:choose>
							<c:when test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or map.task.name eq '部门经理' or map.task.name eq '经办') }">
								<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
							</c:when>
							<c:otherwise>
								<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
							</c:otherwise>
						</c:choose>
						<ul class="mForm" >
						<c:choose>
							<c:when test="${ ((map.task.name eq '提交申请' or (map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '经办' and map.initiator.isSkip eq '1')) and map.business.userId eq sessionScope.user.id and map.business.assistantStatus ne '1') or
									((map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler)}">
						<li class="clearfix">
						<ul class="mForm" id="ulForm">
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">报销人</div>
									<div class="mFormMsg">
										<input type="text" name="name" class="longInput" value="${map.business.name }" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">申请日期</div>
									<div class="mFormMsg">
										<input type="text" id="applyTime" class="longInput" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName" >单位</div>
									<div class="mFormMsg clearfix">
									<div style="float: right;">
										<select name="title"  class="mSelect firstSelect"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
											<c:choose>
											<c:when test="${empty(map.business.dept.alias)}"> 
											<input  type="text" style="width: 60px !important" class="longInput firstInput" id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
											</c:when>
											<c:otherwise>  
											<input  type="text" style="width: 60px !important" class="longInput firstInput" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
											</c:otherwise>
											</c:choose>
									</div>
									</div>
								</div>
							</li>
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">领款人</div>
									<div class="mFormMsg">
										<input type="text"name="payee" value="${map.business.payee }" class="longInput" >
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">银行卡号</div>
									<div class="mFormMsg">
										<input type="text"  class="longInput" name="bankAccount" value="${map.business.bankAccount }" >
									</div>
								</div>
							</li>
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">开户行名称</div>
									<div class="mFormMsg">
										<input type="text" class="longInput" name="bankAddress"  value="${map.business.bankAddress }" >
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">实报金额</div>
									<div class="mFormMsg">
											<p class="longInput" style="margin: 0;padding: 0">
													<span>¥</span>
													<span id="actReimburseTotal"></span>
													(<span id="costcn"></span>) 
											</p>
									</div>
								</div>
							</li>
							<c:forEach items="${map.business.reimburseAttachList }" var="business" varStatus="varStatus">
								<li class="clearfix parentli" name="node">
									<div class="col-xs-12">
										<div class="mFormName">报销条目</div>
										<div class="mFormMsg firstMsg">
											<div class="mFormShow secondMsg" onclick="changeImage(this)" href="#intercityCost${varStatus.index }" data-toggle="collapse" data-parent="#accordion">
												<div class="mFormSeconMsg">
													<span><fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" /></span>
													<input type="hidden" name="reimburseAttachId" value="${business.id }">
												</div>
												<div class="mFormSeconMsg">
													${business.place }
												</div>
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
											</div>
												<c:if test="${(map.task.name eq '提交申请' or (map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '经办' and map.initiator.isSkip eq '1')) and map.business.userId eq sessionScope.user.id}">
													<c:if test="${varStatus.last }">
														<div class="mFormOpe" onclick="node('add',this)">
															<img src="<%=base%>/static/images/add.png" alt="添加">
														</div>
													</c:if>
													<c:if test="${!varStatus.last }">
														<div class="mFormOpe" onclick="node('del',this)">
															<img src="<%=base%>/static/images/del.png" alt="删除">
														</div>
													</c:if>
												</c:if>
											<div class="mFormToggle panel-collapse collapse thirdMsg" id="intercityCost${varStatus.index }">
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">地点</div>
														<div class="mFormXSMsg">
															<input type="text" name="place" class="longInput" value="${business.place }"  onchange="changeText(this,value)">
														</div>
													</div>
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">项目</div>
														<div class="mFormXSMsg">
															<textarea name="projectName" onclick="openProject(this)" readonly>${business.project.name }</textarea>
															<input type="hidden" name="projectId" value="${business.project.id }">
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">日期</div>
														<div class="mFormXSMsg" style="font-size:12px;color: gray;">
															<input type="text" name="date" class="date longInput" onchange="changeText1(this,value)"  value="<fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" />" readonly>
														</div>
													</div>
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">类别</div>
														<div class="mFormXSMsg">
															<select name="type" class="mSelect"  value="${business.type }">
																<custom:dictSelect type="通用报销类型" selectedValue="${business.type }" />
															</select>
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">金额</div>
														<div class="mFormXSMsg" style="font-size:12px;color: gray;">
															<input type="text" id="budget" name="money" class="longInput"  value="<fmt:formatNumber value='${business.money }' pattern='#.##' />" onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)">
														</div>
													</div>
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">实报</div>
														<div class="mFormXSMsg">
															<input type="text"  name="actReimburse" class="longInput"  value="<fmt:formatNumber value='${business.actReimburse }' pattern='#.##' />" onkeyup="actReimburseCount()" onfocus="this.select()">
														</div>
													</div>
												</div>
												<div class="mFormToggleConn" >
													<div class="mFormXSToggleConn" >
														<div class="mFormXSName" >明细</div>
														<div class="mFormMsg" style="border-bottom: none">
														<textarea name="detail"  autocomplete="off"  >${business.detail }</textarea>
														</div>
													</div>
													<div class="mFormXSToggleConn">
													<c:if test="${((map.task.name eq '经办' or map.task.name eq '部门经理' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) }">
														<div class="mFormXSName">费用归属</div>
													</c:if>
														<div class="mFormXSMsg" style="border-bottom: none;">
														<c:if test="${((map.task.name eq '经办' or map.task.name eq '部门经理' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) }">
															<select class="mSelect" style="width: 100%;" name="investId" value="${business.investId }"></select> 
														</c:if>
														</div>
													</div>
												</div>
												<div class="mFormToggleConn" style="position: relative;" >
													<div class="mFormXSToggleConn" style="position: absolute;top: 0;left:5px">
                                          			  <div class="mFormXSName">事由</div>
                                            		  <div class="mFormXSMsg">
                                                		<textarea name="reason">${business.reason }</textarea>
                                            		  </div>
                                                 	</div>
												</div>
											</div>
										</div>
									</div>
								</li>
							</c:forEach>	
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">附件</div>
									<div class="mFormMsg">
										<div class="mFormShow">
											<div class="mFormSeconMsg">
													 <a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
													 <input type="text" id="showName" name="showName" class="longInput" value="${map.business.attachName }" readonly></a>
											</div>
											<div class="mFormArr">
												<c:if test="${(map.task.name eq '提交申请' or (map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '经办' and map.initiator.isSkip eq '1')) and map.business.userId eq sessionScope.user.id }">
												<input type="file" id="file" name="file" style="border:none;display:none;">
												<img src="<%=base %>/static/images/upload.png" alt="" onclick="$('#file').click()">
												</c:if>
												<c:if test="${((map.business.status eq '6' or map.business.status eq '7' or map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '2' or map.business.status eq '11')) or((map.business.status eq '1') and (map.business.userId eq sessionScope.user.id))}">
													<c:if test="${not empty(map.business.attachments)}">
													<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
													</c:if>
												</c:if>
										</div>
										</div>
									</div>
								</div>
							</li>
						</ul>
					</li>
						</c:when>
							
						<c:otherwise>
						<li class="clearfix">
							<ul class="mForm">
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">报销人</div>
									<div class="mFormMsg">
										<input type="text" name="name" class="longInput" value="${map.business.name }" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">申请日期</div>
									<div class="mFormMsg">
										<input type="text" id="applyTime" class="longInput" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName" >单位</div>
									<div class="mFormMsg clearfix">
										<div style="float: right;">
										<select name="title" class="mSelect firstSelect"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
											<c:choose>
											<c:when test="${empty(map.business.dept.alias)}"> 
											<input  type="text" style="width: 60px !important" class="longInput firstInput" id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
											</c:when>
											<c:otherwise>  
											<input  type="text" style="width: 60px !important " class="longInput firstInput" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
											</c:otherwise>
											</c:choose>
										</div>
									</div>
								</div>
							</li>
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">领款人</div>
									<div class="mFormMsg">
										<input type="text"name="payee" value="${map.business.payee }" class="longInput" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">银行卡号</div>
									<div class="mFormMsg">
										<input type="text"  class="longInput" name="bankAccount" value="${map.business.bankAccount }" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">开户行名称</div>
									<div class="mFormMsg">
										<input type="text" class="longInput" name="bankAddress"  value="${map.business.bankAddress }" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">实报金额</div>
									<div class="mFormMsg">
											<p class="longInput" style="margin: 0;padding: 0">
													<span>¥</span>
													<span id="actReimburseTotal"></span>
													(<span id="costcn"></span>) 
											</p>
									</div>
								</div>
							</li>
							<c:forEach items="${map.business.reimburseAttachList }" var="business" varStatus="varStatus">
								<li class="clearfix parentli" name="node">
									<div class="col-xs-12">
										<div class="mFormName">报销条目</div>
										<div class="mFormMsg">
											<div class="mFormShow" onclick="changeImage(this)" href="#intercityCost${varStatus.index }" data-toggle="collapse" data-parent="#accordion">
												<div class="mFormSeconMsg">
													<span><fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" /></span>
													<input type="hidden" name="reimburseAttachId" value="${business.id }">
												</div>
												<div class="mFormSeconMsg">
													${business.place }
												</div>
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '提交申请' or (map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '经办' and map.initiator.isSkip eq '1')) and map.business.userId eq sessionScope.user.id}">
													<c:if test="${varStatus.last }">
														<div class="mFormOpe" onclick="node('add',this)">
															<img src="<%=base%>/static/images/add.png" alt="添加">
														</div>
													</c:if>
													<c:if test="${!varStatus.last }">
														<div class="mFormOpe" onclick="node('del',this)">
															<img src="<%=base%>/static/images/del.png" alt="删除">
														</div>
													</c:if>
												</c:if>
											</div>
											<div class="mFormToggle panel-collapse collapse" id="intercityCost${varStatus.index }">
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">地点</div>
														<div class="mFormXSMsg">
															<input type="text" name="place" class="longInput" value="${business.place }"  onchange="changeText(this,value)" readonly>
														</div>
													</div>
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">项目</div>
														<div class="mFormXSMsg">
															<textarea name="projectName" readonly>${business.project.name }</textarea>
															<input type="hidden" name="projectId" value="${business.project.id }">
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">日期</div>
														<div class="mFormXSMsg" style="font-size:12px;color: gray;">
															<input type="text" name="date" class="longInput"   value="<fmt:formatDate value="${business.date }" pattern="yyyy-MM-dd" />" readonly>
														</div>
													</div>
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">类别</div>
														<div class="mFormXSMsg">
															<input type="text" class="input longInput" value="<custom:getDictKey type="通用报销类型" value="${business.type}" />"   readonly>
															<input type="hidden" name="typevalue" value="${business.type }">
															<input type="hidden" name="type" value="${business.type }">
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">金额</div>
														<div class="mFormXSMsg" style="font-size:12px;color: gray;">
															<input type="text" id="budget" name="money" class="longInput" readonly  value="<fmt:formatNumber value='${business.money }' pattern='#.##' />" onkeyup="moneyCount()" onfocus="this.select()" onblur="moneyBlur(this)">
														</div>
													</div>
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">实报</div>
														<div class="mFormXSMsg">
															<input type="text"  name="actReimburse" class="longInput" readonly  value="<fmt:formatNumber value='${business.actReimburse }' pattern='#.##' />" onkeyup="actReimburseCount()" onfocus="this.select()">
														</div>
													</div>
												</div>
												<div class="mFormToggleConn" >
													<div class="mFormXSToggleConn" style="border-bottom: none">
														<div class="mFormXSName" >明细</div>
														<div class="mFormMsg" style="border-bottom: none">
														<textarea name="detail"  autocomplete="off"  readonly>${business.detail }</textarea>
														</div>
													</div>
													<div class="mFormXSToggleConn">
													<shiro:hasPermission name="fin:reimburse:seeall">
														<div class="mFormXSName">费用归属</div>
														</shiro:hasPermission>
														<div class="mFormXSMsg" style="border-bottom: none;">
														<shiro:hasPermission name="fin:reimburse:seeall">
															<select style="width:100%;" class="mSelect" name="investId" value="${business.investId }"></select> 
														</shiro:hasPermission>
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn" style="width:100% !important;margin-top:-8px">
                                          			  <div class="mFormXSName">事由</div>
                                            		  <div class="mFormXSMsg">
                                                		<textarea name="reason" readonly style="margin-left:1px">${business.reason }</textarea>
                                            		  </div>
                                                 	</div>
												</div>
											</div>
										</div>
									</div>
								</li>
							</c:forEach>	
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">附件</div>
									<div class="mFormMsg">
										<div class="mFormShow">
											<div class="mFormSeconMsg">
													 <a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
													 <input type="text" id="showName" name="showName"  class="longInput" value="${map.business.attachName }" readonly></a>
											</div>
											<div class="mFormArr">
												<c:if test="${(map.business.status eq '6' or map.business.status eq '7')}">
													<c:if test="${not empty(map.business.attachments)}">
														<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
													</c:if>
												</c:if>
											</div>
										</div>
									</div>
								</div>
							</li>
						</ul>
						</li>
						</c:otherwise>
						</c:choose>
						<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">批注</div>
									<div class="mFormMsg">
										<c:if test="${map.task.name ne '提交申请' and map.isHandler }">
												<textarea id="comment" name="comment" rows="2"  placeholder="请填写批注" style="float: left; width: 100%; height: 100%;"></textarea>
										</c:if>
									</div>
								</div>
							</li>
						</ul>
						<div class="mformBtnBox">
							<c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '经办' and map.initiator.isSkip eq '1') }">
											<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve(1)">提交</button>
											<button type="button" class="btn btn-primary" onclick="approve(5)">取消申请</button>
										</c:if>
										<c:if test="${map.isHandler and map.task.name ne '提交申请' and map.task.name ne '部门经理' }">
											<button type="button" class="btn btn-primary" onclick="save()">保存修改</button>
										</c:if>
										
										<c:if test="${((map.initiator.dept.id ne '3' and map.initiator.dept.id ne '20' and map.initiator.dept.id ne '35' and map.initiator.dept.id ne '36' and map.initiator.dept.id ne '37' and map.initiator.dept.id ne '38' and map.initiator.dept.id ne '39') 
									 or (map.initiator.dept.id eq '3' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '20' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '35' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '36' and map.task.name ne '部门经理') 
									 or (map.initiator.dept.id eq '37' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '38' and map.task.name ne '部门经理' ) or (map.initiator.dept.id eq '39' and map.task.name ne '部门经理'))
									 and map.isHandler and map.task.name ne '提交申请' }">
											<button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
											<button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
										</c:if>
										<c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id  eq '20' ) and map.task.name eq '部门经理' and sessionScope.user.id ne '103'  and map.isHandler  and map.business.assistantStatus eq '1'}">
											<button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
											<button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
										</c:if>
										
										
										<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
											<button id="svaeBtn" type="button" class="btn btn-primary" onclick="save()">保存修改</button>
											<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(4)">重新申请</button>
											<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">取消申请</button>
										</c:if>
										<c:if test="${map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11' }">
											<button type="button" class="btn btn-primary" onclick="print(${map.business.processInstanceId })">打印</button>
										</c:if>
										<c:if test="${(map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11') and sessionScope.user.id eq '5'}">
											<button type="button" class="btn btn-primary" onclick="exportpdf(${map.business.processInstanceId })">导出PDF</button>
										</c:if>
										<c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id eq '20' or map.initiator.dept.id eq '35'
									or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39'
									) && map.task.name eq '部门经理' && map.business.assistantStatus ne '1'}">
											<shiro:hasPermission name="fin:reimburse:assistantAffirm">
												<button type="button" class="btn btn-warning" onclick="assistantAffirm()">助手确认</button>
											</shiro:hasPermission>
										</c:if>
										<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
									</div>
					</form>
				</div>
				<!-- /.box -->
			</section>
			<!-- /.content -->
			<section class="content-header">
				<h1>处理流程</h1>
			</section>

			<section class="content">
				<div class="box box-primary tbspace">
					<ul class="mForm" id="mForm">
					</ul>
				</div>
			</section>
		</div>
		<!-- /.content-wrapper -->

<div id="deptDialog"></div>
<div id="projectDialog"></div>
<!-- 帮助文本模态框（Modal） -->
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:92%; height: 80%;">
    	<div class="modal-content" style="height:100%;width:100%;overflow: auto;">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel" style="font-weight:bold;text-align: center;">通用报销填写规范</h4>
         	</div>
	        <div class="modal-body">
					<p>
						<span style="font-family: 宋体, SimSun"><span
							style="font-size: 12px;">1</span><span style="font-size: 12px;">、</span><span
							style="font-size: 19px;">外勤的费用同一天在同一个城市产生的公交地铁打的可写在一起</span><span
							style="font-size: 19px">,</span><span style="font-size: 19px;">在明细写清楚路线金额（</span><span
							style="font-size: 19px">XX</span><span style="font-size: 19px;">地方</span><span
							style="font-size: 19px; color: rgb(51, 51, 51);">→</span><span
							style="font-size: 19px">XX</span><span style="font-size: 19px;">地方</span><span
							style="font-size: 19px">+</span><span style="font-size: 19px;">交通工具</span><span
							style="font-size: 19px">+</span><span style="font-size: 19px;">某公司某客户）</span><span
							style="font-size: 19px">, </span><span style="font-size: 19px;">大家选择滴滴出行的，报销时请提供纸质的滴滴发票与行程单，行程单的金额必须与发票金额一致，行程单上须显示具体的起点与终点地址，不同时间、不同城市的分开填写路线金额。城际交通是同一天的写在一起，地点用双箭头标示，不是同一天的分开填写，地点之间用单箭头标示。</span></span>
					</p>
					<p>
						<span style="font-family: 宋体, SimSun"><span
							style="font-size: 19px;"><img
								src="http://www.reyzar.com/images/upload/20171011/1507707545581.png"
								_src="http://www.reyzar.com/images/upload/20171011/1507707545581.png" /></span></span>
					</p>
					<p>
						<span style="font-family: 宋体, SimSun"><span
							style="font-size: 19px;"><br /></span></span>
					</p>
					<p>
						<br />
					</p>
				</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

	<!-- ./wrapper -->
<%@ include file="../../common/footer.jsp"%>

<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<%-- <script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script> --%>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/reimburs/js/mobileProcess.js"></script>
<!-- 全局变量 -->
<script>
base = "<%=base%>";
</script>
<script>
var hasDecryptPermission = false;
<shiro:hasPermission name="fin:reimburse:decrypt">
	hasDecryptPermission = true;
</shiro:hasPermission>

var seeall;
<shiro:hasPermission name="fin:reimburse:seeall">
seeall = true;
</shiro:hasPermission>
var variables = ${map.jsonMap.variables};
// 操作表单
var formElement = false;
var disableElement = null;
var editInvest = false;
<c:if test="${(map.task.name eq '提交申请' or (map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '经办' and map.initiator.isSkip eq '1')) and map.business.userId eq sessionScope.user.id }">
formElement = true;
</c:if>
<c:if test="${((map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id) or ((map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '部门经理'  or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) }">
editInvest = true;
</c:if>

var submitPhase = ""; // 提交阶段，用于判断是重新提交申请、财务修改还是没有表单操作
<c:if test="${(map.task.name eq '提交申请' or (map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '经办' and map.initiator.isSkip eq '1')) and map.business.userId eq sessionScope.user.id }">
	submitPhase = "resubmit";
</c:if>
<c:if test="${(map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler }">
	submitPhase = "othersubmit";
</c:if>
</script>
</body>
</html>

