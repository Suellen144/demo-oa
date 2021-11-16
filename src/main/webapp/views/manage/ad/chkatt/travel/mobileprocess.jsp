<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/css/oaMobile.css">
	<style>
		textarea {
			resize: none;
			border: none;
			outline: medium;
		}
		.modal-dialog{
			vertical-align: middle;
		}
		.beginDate{
			width: 25% !important;
		}
		.endDate{
			width: 25% !important;
		}
	</style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
		<div class="content-wrapper">
			<section class="content-header" style="text-align: center;">
				<h1>出差申请表</h1>
			</section>

			<section class="content">
				<div class="box box-primary tbspace">
					<form id="form1">
						<select id="vehicle_hidden" style="display:none;">
							<custom:dictSelect type="出差管理交通工具"/>
						</select>

						<input type="hidden" id="id" name="id" value="${map.business.id}">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments }"> 
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName }"> 
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}"> 
						<input type="hidden" id="taskName" value="${map.task.name }">
					    <input type="hidden" id="processInstanceId" value="${map.business.processInstanceId }">
						<input type="hidden" id="operStatus" value="">

						<c:if test="${map.business.userId eq sessionScope.user.id and ((map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) or fn:length(map.activityTaskList) > 1) }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.userId ne sessionScope.user.id or map.task.name ne '提交申请' }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:if>
						<input type="hidden" name="travelAttachId" value="${business.id}">
						<ul class="mForm">
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">出差人员</div>
									<div class="mFormMsg">
										<input type="text" name="userName" class="longInput" value="${map.business.applicant.name }" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">申请日期</div>
									<div class="mFormMsg">
										<input type="text" id="applyTime" class="longInput" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />"readonly>
									</div>
								</div>
							</li>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">单位</div>
									<div class="mFormMsg clearfix">
										<c:choose>
											<c:when
												test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) }">
												<c:if test="${map.business.applicant.dept.name ne '东北办事处' and map.business.applicant.dept.name ne '沈阳办事处'}">
													<select name="title"  class="mSelect">
													<custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }" />
													</select>
													<c:if test="${map.business.applicant.dept.name ne '总经理'}">
														<input type="text" class="longInput" style="margin-left: -5px;  width: auto;" value="${map.business.applicant.dept.name}" readonly>
													</c:if>
												</c:if>
												<c:if test="${map.business.applicant.dept.name eq '东北办事处' or map.business.applicant.dept.name eq '沈阳办事处'}">
													<input name="title" value="10" type="hidden">
													<custom:getDictKey type="流程所属公司" value="10" />
													${map.business.applicant.dept.name}
												</c:if>
											</c:when>
											<c:otherwise>
												<c:if test="${map.business.applicant.dept.name ne '东北办事处' and map.business.applicant.dept.name ne '沈阳办事处'}">
													<custom:getDictKey type="流程所属公司" value="${map.business.title }" />
													<c:if test="${map.business.applicant.dept.name ne '总经理'}">
														${map.business.applicant.dept.name}
													</c:if>
												</c:if>
												<c:if test="${map.business.applicant.dept.name eq '东北办事处' or map.business.applicant.dept.name eq '沈阳办事处'}">
													<input name="title" value="10" type="hidden">
													<custom:getDictKey type="流程所属公司" value="10" />
													${map.business.applicant.dept.name}
												</c:if>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">费用预算</div>
									<div class="mFormMsg">
										<input type="text" id="budget" class="longInput" name="budget" value="<fmt:formatNumber  value="${map.business.budget }" pattern="#.##" />" readonly>
									</div>
								</div>
							</li>
							<c:forEach items="${map.business.travelAttachList }" var="business" varStatus="varStatus">
								<li class="clearfix parentli" name="node">
									<div class="col-xs-12">
										<div class="mFormName">出差申请</div>
										<div class="mFormMsg">
											<div class="mFormShow" href="#intercityCost${varStatus.index}" data-toggle="collapse" data-parent="#accordion">
												<div class="mFormSeconMsg">
													<span><fmt:formatDate value="${business.beginDate }" pattern="yyyy-MM-dd" /></span> 至 <span><fmt:formatDate value="${business.endDate }" pattern="yyyy-MM-dd" /></span>
												</div>
												<div class="mFormSeconMsg">
													${business.place }
												</div>
												<div class="mFormArr">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) and map.business.userId eq sessionScope.user.id}">
													<c:if test="${varStatus.last }">
														<div class="mFormOpe" onclick="node('add',this)">
															<img src="<%=base%>/static/images/add.png" alt="">
														</div>
													</c:if>
													<c:if test="${!varStatus.last }">
														<div class="mFormOpe" onclick="node('del',this)">
															<img src="<%=base%>/static/images/del.png" alt="">
														</div>
													</c:if>
												</c:if>
											</div>
											<div class="mFormToggle panel-collapse collapse" id="intercityCost${varStatus.index}">
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">出差地点</div>
														<div class="mFormXSMsg">
															<input type="text" name="place" class="longInput" value="${business.place }" readonly onchange="changeText(this,value)">
														</div>
													</div>
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">交通工具</div>
														<div class="mFormXSMsg">
															<c:choose>
																<c:when test="${(map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) and map.business.userId eq sessionScope.user.id}">
																	<select name="vehicle" class="mSelect">
																		<custom:dictSelect type="出差管理交通工具" selectedValue="${business.vehicle }" />
																	</select>
																</c:when>
																<c:otherwise>
																	<input type="text" class="longInput" value="<custom:getDictKey type="出差管理交通工具" value="${business.vehicle }"/>" readonly />
																</c:otherwise>
															</c:choose>
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSName">出差日期</div>
													<div class="mFormXSMsg" style="font-size:12px;color: gray;">
														<input name="beginDate" type="text"  class="beginDate longInput" style="width:20%;text-align: center;" value="<fmt:formatDate value="${business.beginDate }" pattern="yyyy-MM-dd" />" readonly readonly onchange="changeText1(this,value,1)"/> 至
														<input name="endDate" type="text"  class="endDate longInput" style="width:20%;text-align: center;" value="<fmt:formatDate value="${business.endDate }" pattern="yyyy-MM-dd" />" readonly readonly onchange="changeText1(this,value,2)"/>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSName">出差事由</div>
													<div class="mFormXSMsg">
														<input type="text" class="longInput" name="task" value="${business.task }" readonly>
													</div>
												</div>
											</div>
										</div>
									</div>
								</li>
							</c:forEach>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">备注</div>
									<div class="mFormMsg">
										<textarea id="comment"  name="comment" rows="2" style="width: 100%;" readonly>${map.business.comment }</textarea>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">附件</div>
									<div class="mFormMsg">
										<div class="mFormShow">
											<div class="mFormSeconMsg">
												<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
													 <input  type="text" id="showName" class="longInput" name="showName" value="${map.business.attachName }" readonly></a>
											</div>
											<c:if test="${(map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) and map.business.userId eq sessionScope.user.id}">
											<div class="mFormArr">
												<input type="file" id="file" name="file" style="display: none;">
												<img src="<%=base %>/static/images/upload.png" alt="" onclick="$('#file').click()">
											</div>
											</c:if>
										</div>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">批注</div>
									<div class="mFormMsg">
										<c:if test="${map.task.name ne '提交申请' and map.isHandler }">
												<textarea id="comments" name="comments" rows="2"  placeholder="请填写批注" style="float: left; width: 100%; height: 100%;"></textarea>
										</c:if>
									</div>
								</div>
							</li>
						</ul>
						<div class="mformBtnBox">
							<c:if test="${map.business.userId eq  sessionScope.user.id and fn:length(map.activityTaskList) > 1 }">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve(1)">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">取消申请</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name ne '提交申请' }">
								<button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
								<button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
							</c:if>
							<c:if
								test="${map.business.userId eq  sessionScope.user.id and map.task.name eq '提交申请' }">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(4)">重新申请</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">取消申请</button>
							</c:if>
							<button type="button" id="cancel" class="btn btn-default"
								onclick="javascript:window.history.back(-1)">返 回</button>
						</div>
					</form>
				</div>
				<!-- /.box -->
			</section>
			<!-- /.content -->

			<section class="content-header" style="text-align: ">
				<h1>处理流程</h1>
			</section>

			<section class="content">
				<div class="box box-primary tbspace">
					<ul class="mForm" id="mForm">
					</ul>
				</div>
			</section>
		</div>
	</div>
	<%@ include file="../../../common/footer.jsp"%>
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
<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/travel/js/mobileprocess.js"></script>
<!-- 全局变量 -->
<script>
base = "<%=base%>";
var variables = ${map.jsonMap.variables};
//操作表单
var formElement = null;
var disableElement = null;
<c:if test="${(map.task.name eq '提交申请' or fn:length(map.activityTaskList) > 1) and map.business.userId eq sessionScope.user.id }">

formElement = 
{
	"budget": "input",	
	"reason": "input",
	"place": "select",
	"task": "input",
	"comment": "textarea"
};
disableElement = {
	"applyTime": "input",
	"userName": "input",
	"deptName": "input"
};
</c:if>
</script>
</body>
</html>

