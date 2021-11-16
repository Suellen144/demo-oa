<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet"
	href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/css/oaMobile.css">
<style type="text/css">
textarea[name="barginDescribe"]
	{
	padding-top: 8px;
	text-align: left;
	width: 100%;
	color: gray;
	font-size: 14px;
	height: 30px;
	outline: none;
	border: none;
	/* line-height:30px; */
}

textarea {
	resize: none;
	outline: medium;
	width: 100%;
}

.firstSelect {
	float: right;
}

.firstInput {
	float: left;
}

.firstMsg {
	position: relative;
}

.secondMsg {
	position: relative;
	z-index: 2;
}

.thirdMsg {
	position: relative;
	top: 0px
}

.mFormOpe {
	position: absolute;
	top: -10px;
	right: 8px;
	z-index: 9;
}
</style>

</head>
<body class="hold-transition skin-blue sidebar-mini">

	<section class="content-header">
		<span style="font-size: 20px; font-weight: bold;">合同申请表</span>
	</section>

	<section class="content">
		<div class="box box-primary tbspace">
			<form id="form1">
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">	
						<input type="hidden" id="operStatus" value="">
						<c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.userId ne sessionScope.user.id or (map.task.name ne '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:if>		
						<input type="hidden" id="isHandler" name="isHandler" value="${map.isHandler}">
						<input type="hidden" id="taskName" name="taskName" value="${map.task.name}">
						<input type="hidden" id="id" name="id" value="${map.business.id}">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName}">
						<input type="hidden" id="deptId" name="deptId" value="${map.business.deptId}">
						<input type="hidden" id="userId" name="userId" value="${map.business.userId}">
						<input type="hidden"  id ="currUserId" value="${sessionScope.user.id }"readonly>
						<input type="hidden" id="createBy" name="createBy" value="${map.business.createBy}">
						<input type="hidden" id="createDate" name="createDate" value='<fmt:formatDate value="${map.business.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>'>
						<input type="hidden" id="payMoney" name="payMoney" value="${map.business.payMoney}">
						<input type="hidden" id="unpayMoney" name="unpayMoney" value="${map.business.unpayMoney}">
						<input type="hidden" id="payReceivedInvoice" name="payReceivedInvoice" value="${map.business.payReceivedInvoice}">
						<input type="hidden" id="payUnreceivedInvoice" name="payUnreceivedInvoice" value="${map.business.payUnreceivedInvoice}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
			<c:choose>
			  <c:when test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
				<ul class="mForm" id="ulForm">
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">发起人</div>
							<div class="mFormMsg">
								<input type="text"  id ="name" class="longInput" value="${map.business.sysUser.name }"readonly></td>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">发起时间</div>
							<div class="mFormMsg">
									<input type="text" name="applyTime"  class="longInput" id ="applyTime" value='<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />' readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">所属单位</div>
							<div class="mFormMsg clearfix">
								<div style="float: right;">
											<c:if test="${map.business.dept.name ne '东北办事处' and map.business.dept.name ne '沈阳办事处'}">
												<select name="title" class="mSelect">
												<custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/>
												</select>
												<c:if test="${sessionScope.user.dept.name  ne '总经理'}">
													${map.business.dept.name}
												</c:if>
											</c:if>
											<c:if test="${map.business.dept.name eq '东北办事处' or map.business.dept.name eq '沈阳办事处'}">
												<input name="title" value="10" type="hidden">
												<select name="title" class="mSelect">
												<custom:getDictKey type="流程所属公司" value="10"/>
												</select>
												<input  type="text" style="width:20%;float:right"  class="longInput" value="${map.business.dept.name}" readonly>
											</c:if>
								</div>
							</div>
						</div>
					</li>
					
					<li class="clearfix parentli" name="node">
						<div class="col-xs-12">
							<div class="mFormName">合同详情</div>
							<div class="mFormMsg firstMsg">
								<div class="mFormShow secondMsg" style="height:40px" onclick="changeImage(this)"
									href="#intercityCost" data-toggle="collapse"
									data-parent="#accordion">
									<div class="mFormArr current">
										<img src="<%=base%>/static/images/arr.png" alt="">
									</div>
								</div>
								<div class="mFormToggle panel-collapse collapse thirdMsg"
									id="intercityCost">
									<div class="mFormToggleConn">
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">合同名称</div>
											<div class="mFormXSMsg">
												<input type="text" name="barginName"  id ="barginName" class="longInput" value="${map.business.barginName}">
											</div>
										</div>
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">合同类型</div>
											<div class="mFormXSMsg">
												<select id ="barginType" class="mSelect" name="barginType" value="${map.business.barginType}">
													<custom:dictSelect type="合同类型" selectedValue="${map.business.barginType}"/>
												</select>
											</div>
										</div>
									</div>
									<div class="mFormToggleConn">
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">所属项目</div>
											<div class="mFormXSMsg" style="font-size: 12px; color: gray;">
												<input type="text" name="projectManageId"  id ="projectManageId" value="${map.business.projectManageId }" style="display: none;"  readonly>
												<input class="longInput"  type="text" name="projectManageName"  id ="projectManageName" value="${map.business.projectManage.name }" onclick="openProject(this)"  readonly>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</li>
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">合同描述</div>
							<div class="mFormMsg">
								<textarea type="text" name="barginDescribe"  id ="barginDescribe" value="" >${map.business.barginDescribe}</textarea>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同编号</div>
							<div class="mFormMsg">
								<input type="text" name="barginCode"  id ="barginCode" class="longInput" value="${map.business.barginCode}" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同期限</div>
							<div class="mFormMsg">
								<input id="startTime" name="startTime"  value='<fmt:formatDate value="${map.business.startTime }" pattern="yyyy-MM-dd" />' type="text" class="startTime longInput" style="width:30%;"  readonly> 
								<span style="padding-left:20%;">至</span>
								<input  id="endTime" name="endTime"   value='<fmt:formatDate value="${map.business.endTime }" pattern="yyyy-MM-dd"/>' type="text" class="endTime longInput" style="width:30%;float:right" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">签订单位</div>
							<div class="mFormMsg">
								<input type="text" name="company" class="longInput"  id ="company" value="${map.business.company}">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同总金额</div>
							<div class="mFormMsg">
							<input type="text" name="totalMoney" class="longInput"  id ="totalMoney" value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">附件</div>
							<div class="mFormMsg">
								<div class="mFormShow">
									<div class="mFormSeconMsg">
										<c:if test="${empty map.business.id}">
											<input type="text" id="showName" class="longInput" name="showName" value="" readonly >
										</c:if>
										
										<c:if test="${not empty map.business.id}">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" class="longInput" name="showName" value="${map.business.attachName }" readonly >
											</a>
										</c:if>
									</div>
									<div class="mFormArr">
											<input type="file" id="file" name="file" style="display: none;">
											<c:if test="${not empty map.business.attachments }">
												<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
											</c:if>
										<img src="<%=base%>/static/images/upload.png" alt=""
											onclick="$('#file').click()">
									</div>
								</div>
							</div>
						</div>
					</li>
					<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">批注</div>
							<div class="mFormMsg">
								<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:70%;height:100%;"></textarea>
							</div>
						</div>
					</li>
					</c:if>
				</ul>
			  </c:when>
			  
			  <c:otherwise>
			  		<ul class="mForm" id="ulForm">
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">发起人</div>
							<div class="mFormMsg">
								<input type="text"  id ="name" class="longInput" value="${map.business.sysUser.name }"readonly></td>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">发起时间</div>
							<div class="mFormMsg">
									<input type="text" name="applyTime"  class="longInput" id ="applyTime" value='<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />' readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">所属单位</div>
							<div class="mFormMsg clearfix">
								<div style="float: right; height:40px;line-height:40px;width:auto">
										<c:if test="${map.business.dept.name ne '东北办事处' and map	.business.dept.name ne '沈阳办事处'}">
										<custom:getDictKey type="流程所属公司" value="${map.business.title }"/>
										<c:if test="${map.business.dept.name ne '总经理'}">
											${map.business.dept.name}
										</c:if>
										</c:if>
										<c:if test="${map.business.dept.name eq '东北办事处' or map.business.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey  type="流程所属公司" value="10"/>
											<input  type="text"   class="longInput" style="float: right;width:auto" value="${map.business.dept.name}" readonly>
										</c:if>
								</div>
							</div>
						</div>
					</li>
					
					<li class="clearfix parentli" name="node">
						<div class="col-xs-12">
							<div class="mFormName">合同详情</div>
							<div class="mFormMsg firstMsg">
								<div class="mFormShow secondMsg" style="height:40px" onclick="changeImage(this)"
									href="#intercityCost" data-toggle="collapse"
									data-parent="#accordion">
									<div class="mFormArr current">
										<img src="<%=base%>/static/images/arr.png" alt="">
									</div>
								</div>
								<div class="mFormToggle panel-collapse collapse thirdMsg"
									id="intercityCost">
									<div class="mFormToggleConn">
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">合同名称</div>
											<div class="mFormXSMsg">
												<input type="text" name="barginName"  id ="barginName" class="longInput" value="${map.business.barginName}" readonly>
											</div>
										</div>
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">合同类型</div>
											<div class="mFormXSMsg" style="height:30px;line-height:30px;font-size:13px;">
												<input type="hidden"  id="barginType" name="barginType" value="${map.business.barginType}">
												<custom:getDictKey type="合同类型" value="${map.business.barginType}"/>
											</div>
										</div>
									</div>
									<div class="mFormToggleConn">
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">所属项目</div>
											<div class="mFormXSMsg" style="font-size: 12px; color: gray;">
												<input type="text" name="projectManageId"  id ="projectManageId" value="${map.business.projectManageId }" style="display: none;"  readonly>
												<input class="longInput"  type="text" name="projectManageName"  id ="projectManageName" value="${map.business.projectManage.name }"   readonly>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</li>
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">合同描述</div>
							<div class="mFormMsg">
								<textarea type="text" name="barginDescribe"  id ="barginDescribe" readonly >${map.business.barginDescribe}</textarea>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同编号</div>
							<div class="mFormMsg">
								<input type="text" name="barginCode"  id ="barginCode" class="longInput" value="${map.business.barginCode}" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同期限</div>
							<div class="mFormMsg">
								<input id="startTime" name="startTime"  value='<fmt:formatDate value="${map.business.startTime }" pattern="yyyy-MM-dd" />' type="text" class="startTime longInput" style="width:30%;"  readonly> 
								<span style="padding-left:20%;">至</span>
								<input  id="endTime" name="endTime"   value='<fmt:formatDate value="${map.business.endTime }" pattern="yyyy-MM-dd"/>' type="text" class="endTime longInput" style="width:30%;float:right" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">签订单位</div>
							<div class="mFormMsg">
								<input type="text" name="company" class="longInput"  id ="company" value="${map.business.company}" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12" id="showOrHidden">
							<div class="mFormName">合同总金额</div>
							<div class="mFormMsg">
							<input type="text" name="totalMoney" class="longInput"  id ="totalMoney" value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />" readonly>
							</div>
						</div>
						<div class="col-xs-12" id="showOrhidden" style="display: none;">
						<div class="mFormToggleConn" style="border-bottom: 1px solid #e9e9e9; height:40px" >
												<div class="mFormXSToggleConn" style="height:40px;line-height:40px;">
													<div class="mFormXSName" style="height:40px;line-height:40px;width:20%;font-size:14px">合同总金额</div>
													<div class="mFormXSMsg" style="width:80%;margin-left:9%;">
														<input type="text" name="totalMoney" style="font-size:13px" class="longInput totalMoney"  id ="totalMoney" value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />" readonly>
													</div>
												</div>
												<div class="mFormXSToggleConn" style="height:40px;line-height:40px;">
													<div class="mFormXSName" style="height:40px;line-height:40px;width:20%;font-size:14px">已付金额</div>
													<div class="mFormXSMsg" style="height:40px;line-height:40px;width:80%;margin-left:9%;">
														<input type="text" style="width: auto;font-size:13px"  class="longInput"  value="">
													</div>
												</div>
											</div>
							<div class="mFormName">签订单位</div>
							<div class="mFormMsg">
								<input type="text" name="company" class="longInput"  id ="company" value="${map.business.company}" readonly>
							</div>
							<div class="mFormName">签订单位</div>
							<div class="mFormMsg">
								<input type="text" name="company" class="longInput"  id ="company" value="${map.business.company}" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">附件</div>
							<div class="mFormMsg">
								<div class="mFormShow">
									<div class="mFormSeconMsg">
										<c:if test="${not empty map.business.id}">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" class="longInput" name="showName" value="${map.business.attachName }"  readonly>
											</a>
										</c:if>
									</div>
								</div>
							</div>
						</div>
					</li>
					<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">批注</div>
							<div class="mFormMsg">
								<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:70%;height:100%;"></textarea>
							</div>
						</div>
					</li>
					</c:if>
				</ul>
			  </c:otherwise>
			</c:choose>
				<div class="mformBtnBox">
							<%-- <c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '部门经理')}">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve('提交')">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name ne '提交申请' and map.task.name ne '出纳'}">
								<button type="button" class="btn btn-primary" onclick="approve('同意')">同意</button>
								<button type="button" class="btn btn-warning" onclick="approve('不同意')">不同意</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name eq '出纳' }">
								<button type="button" class="btn btn-primary" onclick="approve('同意')">确认</button>
								<button type="button" class="btn btn-warning" onclick="approve('不同意')">退回</button>
							</c:if>
							<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve('重新申请')">保存并提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if> --%>
							<c:if test="${map.business.status eq '5' && map.business.status ne '11'}">
								<shiro:hasPermission name="sale:bargin:invalid">
									<button type="button" id='invalid' class="btn btn-warning" onclick="approve('作废')">作废</button>
								</shiro:hasPermission>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
				</div>
				<div id="pay"></div>
				<div id="collection"></div>
			</form>
		</div>
	</section>
	<section class="content-header">
		<h1>处理流程</h1>
	</section>
			<section class="content">
				<div class="box box-primary tbspace">
					<ul class="mForm" id="mForm">
					</ul>
				</div>
			</section>
<div id="projectDialog"></div>

<!-- 模态框（Modal） -->
		<div class="modal fade" id="collectionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog" style="width:80%; height: 80%;">
				<div class="modal-content" style="height:100%;">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">收款详细</h4>
					</div>
					<div class="modal-body" style="height:75%;">
						<iframe id="collectionFrame" name="collectionFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal -->
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sale/barginManage/js/mobileprocess.js"></script>
<script type="text/javascript">
	var base = "<%=base%>";
	var variables = ${map.jsonMap.variables};
</script>
</body>
</html>

