<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet"
	href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/css/oaMobile.css">
<style type="text/css">
textarea[name="projectName"], textarea[name="purpose"], textarea[name="remark"]
	{
	padding-top: 5px;
	text-align: left;
	width: 100%;
	color: gray;
	font-size: 12px;
	height: 30px;
	outline: none;
	border: none;
	/* line-height:30px; */
	margin-left: -5px;
}

textarea {
	resize: none;
	outline: medium;
	width: 100%;
}

.firstSelect {
	float: left;
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
	<!-- Site wrapper -->

	<!-- Content Header (Page header) -->
	<section class="content-header">
		<span style="font-size: 20px; font-weight: bold;">付款申请表</span>
	</section>

	<!-- Main content -->
	<section class="content">
		<!-- Default box -->
		<div class="box box-primary tbspace">
			<form id="form1">
				<input type="hidden" id="id" name="id" value="${finPay.id}">
				<input type="hidden" id="attachments" name="attachments"
					value="${finPay.attachments}"> <input type="hidden"
					id="attachName" name="attachName" value="${finPay.attachName}">
				<input type="hidden" id="deptId" name="deptId" value="${finPay.deptId}">
				<input type="hidden" id="userId" name="userId" value="${finPay.userId}">
				<input type="hidden" id="issubmit" name="issubmit" value="">
				<input type="hidden" id="barginProcessInstanceId" value="${finPay.barginManage.processInstanceId}">
				<input type="hidden" id="barginManageId" name="barginManageId" value="${finPay.barginManageId}">
				<input type="hidden" id="barginProcessInstanceId" value="${finPay.barginManage.processInstanceId}">
					
				<ul class="mForm" id="ulForm">
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">发起人</div>
							<div class="mFormMsg">
								<input type="text" name="name" class="longInput"
									value="${sessionScope.user.name }" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">申请日期</div>
							<div class="mFormMsg">
								<input type="text" id="applyTime" class="longInput"
									name="applyTime"
									value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />"
									style="color: gray;" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">所属单位</div>
							<div class="mFormMsg clearfix">
								<div style="float: right;">
									<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
											<select name="title" class="mSelect firstSelect">
											<custom:dictSelect type="流程所属公司" selectedValue="${finPay.title}"/></select>
											<c:if test="${sessionScope.user.dept.name  ne '总经理'}">
												<input type="text" class="longInput" value="${sessionScope.user.dept.name }" readonly>
											</c:if>
										</c:if>
										<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
											<input  type="text"  class="longInput" value="${sessionScope.user.dept.name }" readonly>
										</c:if>
								</div>
							</div>
						</div>
					</li>
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">收款单位</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" name="collectCompany"
									id="collectCompany" value="${finPay.collectCompany}">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">开户行</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" name="bankAddress"
									id="bankAddress" value="${finPay.bankAddress }">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">账号</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" name="bankAccount"
									id="bankAccount" value="${finPay.bankAccount}">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">付款类型</div>
							<div class="mFormMsg" style="height: 40px">
								<select name="payType" class="mSelect">
											<option></option>
											<custom:dictSelect type="付款类型" selectedValue="${finPay.payType}"/>
								</select>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">用途</div>
							<div class="mFormMsg">
							<textarea name="purpose" id="purpose">${finPay.purpose }</textarea>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">申请金额</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" name="applyMoney"
									id="applyMoney"
									value="<fmt:formatNumber value='${finPay.applyMoney}' pattern='0.00' />"
									onblur="initInputBlur()">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">合同管理</div>
							<div class="mFormMsg" style="height: 40px">
								<div style="float: right; width: auto; height: 39px">
									<div style="float: right;">
										<input type="button" class="longInput" id="viewBarginBtn"
											value="查看合同详细" onclick="viewBargin()" style="display: none;">
									</div>
									<div style="float: right;">
										<input type="button" class="longInput" value="关联合同"
											onclick="openBargin()" style="border: none; display: inline;">
									</div>
								</div>
							</div>
						</div>
					</li>
					<li class="clearfix parentli" name="node">
						<div class="col-xs-12">
							<div class="mFormName">关联合同</div>
							<div class="mFormMsg firstMsg">
								<div class="mFormShow secondMsg" style="height:40px" onclick="changeImage(this)"
									href="#intercityCost" data-toggle="collapse"
									data-parent="#accordion">
									<div class="mFormSeconMsg">
										<span id="sp">${finPay.barginManage.barginName}</span>
									</div>
									<div class="mFormArr current">
										<img src="<%=base%>/static/images/arr.png" alt="">
									</div>
								</div>
								<div class="mFormToggle panel-collapse collapse thirdMsg"
									id="intercityCost">
									<div class="mFormToggleConn">
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">合同编号</div>
											<div class="mFormXSMsg">
												<input type="text" class="longInput" id="barginCode"
													value="${finPay.barginManage.barginCode}" readonly>
											</div>
										</div>
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">合同名称</div>
											<div class="mFormXSMsg">
												<input type="text" class="longInput" id="barginName"
													value="${finPay.barginManage.barginName}" readonly>
											</div>
										</div>
									</div>
									<div class="mFormToggleConn">
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">所属项目</div>
											<div class="mFormXSMsg" style="font-size: 12px; color: gray;">
												<input type="text" class="longInput"
													name="projectManageName" id="projectManageName"
													value="${finPay.projectManage.name }" readonly>
											</div>
										</div>
										<div class="mFormXSToggleConn">
											<div class="mFormXSName">合同总额</div>
											<div class="mFormXSMsg">
												<input type="text" name="totalMoney" class="longInput"   id ="totalMoney" value="<fmt:formatNumber value='${finPay.totalMoney}' pattern='0.00' />" >
												<input type="hidden" name="barginTotalMoney"  id ="barginTotalMoney" value="<fmt:formatNumber value='${finPay.barginManage.totalMoney}' pattern='0.00' />" >
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</li>

					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">申请比例</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" name="applyProportion"  id ="applyProportion" value="${finPay.applyProportion}"  readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">发票收否</div>
							<div class="mFormMsg" style="text-align: right; min-height: 40px !important; line-height: 40px">
								<select name="invoiceCollect" id="invoiceCollect"
									onchange="change(this)" class="mSelect">
										<custom:dictSelect type="发票收取状态" selectedValue="${finPay.invoiceCollect}"/>
								</select>
							</div>
						</div>
					</li>
					<li class="clearfix" id="showOrHidden">
						<div class="col-xs-12">
							<div class="mFormName">发票金额</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" name="invoiceMoney"
									id="invoiceMoney"
									 value="<fmt:formatNumber value='${finPay.invoiceMoney}' pattern='0.00' />">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">备注</div>
							<div class="mFormMsg">
								<textarea id="remark" name="remark">${finPay.remark}</textarea>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">附件</div>
							<div class="mFormMsg">
								<div class="mFormShow">
									<div class="mFormSeconMsg">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${finPay.attachments }" target='_blank'>
											<input type="text" style="text-align: left;" id="showName" name="showName" value="${finPay.attachName }" class="longInput"  readonly>
										</a>
									</div>
									<div class="mFormArr">
										<input type="file" id="file" name="file" style="display: none;">
											<c:if test="${not empty finPay.attachments }">
												<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${finPay.attachments }">删除</a>
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
							<c:if test="${not empty finPay.id }">
							<button type="button" class="btn btn-warning" onclick="del()" >删除</button>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
				</div>
			</form>
		</div>
		<!-- /.box -->
	</section>
	<!-- /.content -->
<div id="barginDialog"></div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="barginDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; height: 80%;">
    	<div class="modal-content" style="height:100%;width:auto">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel">合同详情</h4>
         	</div>
	        <div class="modal-body" style="height:75%;">
	        	<iframe id="barginDetailFrame" name="barginDetailFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
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
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/pay/js/mobileaddoredit.js"></script>
</body>
</html>

