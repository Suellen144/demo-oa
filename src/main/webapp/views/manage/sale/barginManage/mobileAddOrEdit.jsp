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
	top: 0px;
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
				<input type="hidden" id="id" name="id" value="${saleBarginManage.id}">
						<input type="hidden" id="attachments" name="attachments" value="${saleBarginManage.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${saleBarginManage.attachName}">
						<input type="hidden" id="deptId" name="deptId" value="${saleBarginManage.deptId}">
						<input type="hidden" id="userId" name="userId" value="${saleBarginManage.userId}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<input type="hidden" id="createBy" name="createBy" value="${saleBarginManage.createBy}">
						<input type="hidden" id="createDate" name="createDate" value='<fmt:formatDate value="${saleBarginManage.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>'>
						<input type="hidden" id="status" name="status" value="${saleBarginManage.status}">
						<input type="hidden"  id ="currUserId" value="${sessionScope.user.id }" readonly>
					
				<ul class="mForm" id="ulForm">
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">发起人</div>
							<div class="mFormMsg">
										<c:if test="${empty saleBarginManage.id}">
											<input type="text"  id ="name" class="longInput" value="${sessionScope.user.name }"readonly></td>
										</c:if>
										<c:if test="${not empty saleBarginManage.id}">
											<input type="text"  id ="name" class="longInput" value="${saleBarginManage.sysUser.name }"readonly></td>
										</c:if>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">发起时间</div>
							<div class="mFormMsg">
									<input type="text" name="applyTime"  class="longInput" id ="applyTime" value='<fmt:formatDate value="${saleBarginManage.applyTime }" pattern="yyyy-MM-dd" />' readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">所属单位</div>
							<div class="mFormMsg clearfix">
								<div style="float: right;">
										<c:if test="${empty saleBarginManage.id}">
											<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
												<c:if test="${sessionScope.user.dept.name  ne '总经理'}">
													<input type="text" class="longInput" style="width:20%;float:right" value="${sessionScope.user.dept.name }" readonly>
												</c:if>
												<select name="title" class="mSelect firstSelect"><custom:dictSelect type="流程所属公司" selectedValue="${saleBarginManage.title}"/></select>
											</c:if>
											<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
												<input name="title" value="10" type="hidden">
												<custom:getDictKey type="流程所属公司" value="10"/>
												<input  type="text" style="width:20%;float:right"  class="longInput" value="${sessionScope.user.dept.name }" readonly>
											</c:if>
										</c:if>
										<c:if test="${not empty saleBarginManage.id}">
											<c:if test="${sessionScope.user.dept.name  ne '总经理'}">
													<input type="text" class="longInput" style="width:20%;float:right" value="${saleBarginManage.dept.name }" readonly>
											</c:if>
											<select name="title" class="mSelect firstSelect"><custom:dictSelect type="流程所属公司" selectedValue="${saleBarginManage.title}"/></select>
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
												<input type="text" name="barginName"  id ="barginName" class="longInput" value="${saleBarginManage.barginName}">
											</div>
										</div>
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">合同类型</div>
											<div class="mFormXSMsg">
												<select id ="barginType" class="mSelect" name="barginType" value="${saleBarginManage.barginType}">
													<custom:dictSelect type="合同类型" selectedValue="${saleBarginManage.barginType}"/>
												</select>
											</div>
										</div>
									</div>
									<div class="mFormToggleConn">
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">所属项目</div>
											<div class="mFormXSMsg" style="font-size: 12px; color: gray;">
												<input type="text" name="projectManageId"  id ="projectManageId" value="${saleBarginManage.projectManageId }" style="display: none;"  readonly>
												<input class="longInput"  type="text" name="projectManageName"  id ="projectManageName" value="${saleBarginManage.projectManage.name }" onclick="openProject(this)"  readonly>
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
								<textarea type="text" name="barginDescribe"  id ="barginDescribe" value="" >${saleBarginManage.barginDescribe}</textarea>
							</div>
						</div>
					</li>
					<c:if test="${not empty saleBarginManage.id}">
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同编号</div>
							<div class="mFormMsg">
								<input type="text" name="barginCode"  id ="barginCode" class="longInput" value="${saleBarginManage.barginCode}" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同期限</div>
							<div class="mFormMsg">
								<input id="startTime" name="startTime"  value='<fmt:formatDate value="${saleBarginManage.startTime }" pattern="yyyy-MM-dd" />' type="text" class="startTime longInput" style="width:30%;"  readonly> 
								<span style="padding-left:20%;">至</span>
								<input  id="endTime" name="endTime"   value='<fmt:formatDate value="${saleBarginManage.endTime }" pattern="yyyy-MM-dd"/>' type="text" class="endTime longInput" style="width:30%;float:right" readonly>
							</div>
						</div>
					</li>
					</c:if>
					<c:if test="${empty saleBarginManage.id }">
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">签订单位</div>
							<div class="mFormMsg">
								<input type="text" name="company" class="longInput"  id ="company" value="${saleBarginManage.company}">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同总金额</div>
							<div class="mFormMsg">
							<input type="text" name="totalMoney" class="longInput"  id ="totalMoney" value="<fmt:formatNumber value='${saleBarginManage.totalMoney}' pattern='0.00' />">
							</div>
						</div>
					</li>
					</c:if>
					<c:if test="${not empty saleBarginManage.id }">
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">签订单位</div>
							<div class="mFormMsg">
								<input type="text" name="company" class="longInput"  id ="company" value="${saleBarginManage.company}" >
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同总金额</div>
							<div class="mFormMsg" style="height: 40px">
								<input type="text" name="totalMoney" class="longInput"  id ="totalMoney" value="<fmt:formatNumber value='${saleBarginManage.totalMoney}' pattern='0.00' />" >
							</div>
						</div>
					</li>
					</c:if>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">附件</div>
							<div class="mFormMsg">
								<div class="mFormShow">
									<div class="mFormSeconMsg">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${saleBarginManage.attachments }" target='_blank'>
											<input type="text" id="showName" class="longInput" name="showName" value="${saleBarginManage.attachName }" style="text-align: left;" readonly>
										</a>
									</div>
									<div class="mFormArr">
											<input type="file" id="file" name="file" style="display: none;">
											<c:if test="${not empty saleBarginManage.attachments }">
												<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${saleBarginManage.attachments }">删除</a>
											</c:if>
										<img src="<%=base%>/static/images/upload.png" alt=""
											onclick="$('#file').click()">
									</div>
								</div>
							</div>
						</div>
					</li>
				</ul>

				<div class="mformBtnBox">
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
							<button type="button" class="btn btn-primary" onclick="submitInfo()" >提交</button>
							<c:if test="${not empty saleBarginManage.id }">
							<button type="button" class="btn btn-warning" onclick="del()" >删除</button>
							</c:if>
							<button  type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
				</div>
			</form>
		</div>
	</section>
<div id="userDialog"></div>
<div id="projectDialog"></div>
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
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sale/barginManage/js/mobileAddOrEdit.js"></script>
</body>
</html>

