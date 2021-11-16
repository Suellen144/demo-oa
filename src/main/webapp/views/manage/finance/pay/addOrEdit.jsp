<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/header.jsp"%>
	<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
	<style>
		#table1 {
			width: 90%;
			table-collapse: collapse;
			border: none;
			margin: auto;
			background-color: white;
		}
		#table1 td {
			border: solid #999 1px;
			padding: 5px;
		}
		#table1 thead th {
			border: none;
		}

		select{
			appearance:none;
			-moz-appearance:none;
			-webkit-appearance:none;
			border: none;
		}

		/* IE10以上生效 */
		select::-ms-expand {
			display: none;
		}

		#table1 td input[type="text"] {
			width: 100%;
			height: 100%;
			border: none;
			text-align:center;
			outline: medium;
		}
		#table1 td span {
			width: 100%;
			text-align: center;
			display: block;
			font-weight: bold;
			padding: 0px 5px;
		}
		#table1 th {
			border: solid #999 1px;
			text-align: center;
			font-size: 1.5em;
		}
		textarea {
			width: 100%;
			resize: none;
			border: none;
			outline: medium;
		}
		.td {
			width: 120px;
		}
	</style>
</head>
<body style="min-width:1100px;overflow:auto;font-size:small;">
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">付款管理</li>
			<li class="active">添加付款申请表</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace">

					<form id="form1" style="vertical-align: middle;text-align: center">
						<input type="hidden" id="id" name="id" value="${finPay.id}">
						<input type="hidden" id="attachments" name="attachments" value="${finPay.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${finPay.attachName}">
						<input type="hidden" id="deptId" name="deptId" value="${finPay.deptId}">
						<input type="hidden" id="userId" name="userId" value="${finPay.userId}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<input type="hidden" id="barginProcessInstanceId" value="${finPay.barginManage.processInstanceId}">
						<input type="hidden" id="barginManageId" name="barginManageId" value="${finPay.barginManageId}">

						<table id="table1">
							<thead>
							<tr><th colspan="13">付款申请表</th></tr>
							</thead>
							<tbody>
							<tr>
								<td class="td"><span>发起人</span></td>
								<td style="width: 23%"><input type="text"  id ="name" value="${sessionScope.user.name }"readonly></td>
								<td class="td"><span>所属单位</span></td>
								<td colspan="3" style="line-height:inherit;text-align:left;">
									<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
										<select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" selectedValue="${finPay.title}"/></select>
										<c:if test="${sessionScope.user.dept.name  ne '总经理'}">
											<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${sessionScope.user.dept.name }" readonly>
										</c:if>
									</c:if>
									<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
										<input name="title" value="10" type="hidden">
										<custom:getDictKey type="流程所属公司" value="10"/>
										<input  type="text"  style="height:20px;width:auto;text-align:left;" value="${sessionScope.user.dept.name }" readonly>
									</c:if>
								</td>
								<td class="td"><span>发起时间</span></td>
								<td  colspan="7" style="width: 25%"><input type="text" name="applyTime"  id ="applyTime" value='<fmt:formatDate value="${finPay.applyTime }" pattern="yyyy-MM-dd" />' readonly></td>
							</tr>
							<tr>
								<td><span>合同编号</span></td>
								<td><input type="text"  id ="barginCode" value="${finPay.barginManage.barginCode}" readonly>
								</td>
								<td><span>合同名称</span></td>
								<td colspan="3"><input type="text"  id ="barginName" value="${finPay.barginManage.barginName}" readonly></td>
								<td><span>所属项目</span></td>
								<td  colspan="7"><input type="hidden" name="projectManageId"  id ="projectManageId" value="${finPay.projectManageId }"  readonly>
									<input type="text" name="projectManageName"  id ="projectManageName" value="${finPay.projectManage.name }" readonly onclick="openProject()"></td>
							</tr>


							<tr>
								<td><span>收款单位</span></td>
								<td><input type="text" name="collectCompany"  id ="collectCompany" value="${finPay.collectCompany}"></td>
								<td><span>开户行</span></td>
								<td  colspan="3"><input type="text" name="bankAddress"  id ="bankAddress" value="${finPay.bankAddress }">
								<td><span>账号</span></td>
								<td colspan="7"><input type="text" name="bankAccount"  id ="bankAccount" value="${finPay.bankAccount}"></td>
							</tr>
							<tr>
								<td><span>付款类型</span></td>
								<td>
									<select name="payType" style="height:100%;width:100%;text-align-last:center;">
										<option></option>
										<custom:dictSelect type="付款类型" selectedValue="${finPay.payType}"/>
									</select>
								</td>
								<td><span>用途</span></td>
								<td colspan="3"><input type="text" name="purpose"  id ="purpose" value="${finPay.purpose }" >
								<td><span>发票是否已收</span></td>
								<td colspan="4">
									<select name="invoiceCollect" id="invoiceCollect" onchange="change(this)"   style="height:100%;width:100%;text-align-last:center;">
										<option></option>
										<custom:dictSelect type="发票收取状态" selectedValue="${finPay.invoiceCollect}"/>
									</select>
								</td>
								<td id="invoice" style="display: none;"><span>发票金额</span></td>
								<td id="money" style="display: none;"><input type="text" style="text-align:right;" name="invoiceMoney"  id ="invoiceMoney" value="<fmt:formatNumber value='${finPay.invoiceMoney}' pattern='0.00' />"></td>
							</tr>

							<tr>
								<td><span>合同总金额</span></td>
								<td><input type="text" name="totalMoney"  id ="totalMoney" value="<fmt:formatNumber value='${finPay.totalMoney}' pattern='0.00' />" >
									<input type="hidden" name="barginTotalMoney"  id ="barginTotalMoney" value="<fmt:formatNumber value='${finPay.barginManage.totalMoney}' pattern='0.00' />" >
								</td>
								<td><span>申请金额</span></td>
								<td colspan="3"><input type="text" name="applyMoney"  id ="applyMoney" value="<fmt:formatNumber value='${finPay.applyMoney}' pattern='0.00' />" onblur="initInputBlur()"></td>
								<td><span>申请比例</span></td>
								<td colspan="7"><input type="text" name="applyProportion"  id ="applyProportion" value="${finPay.applyProportion}"  readonly></td>
							</tr>
							<tr>
								<td><span>费用类型</span></td>
								<td>
									<select id="reimburseType" name="reimburseType" style="height:100%;width:100%;text-align-last:center;">
										<option></option>
										<custom:dictSelect type="通用报销类型" selectedValue="${finPay.reimburseType}"/>
									</select>
								</td>
								<td><span>合同管理</span></td>
								<td colspan="12" style="text-align:left;">
									<input type="button" value="关联合同" onclick="openBargin()" style="border:none;">
									<input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="display:none;">
								</td>
							</tr>
							<tr>
								<td><span>付款事由</span></td>
								<td colspan="20"><textarea id="cause" name="cause" rows="2" style="width: 100%;">${finPay.cause}</textarea></td>
							</tr>
							<tr>
								<td><span>备注</span></td>
								<td colspan="20"><textarea id="remark" name="remark" rows="2" style="width: 100%;">${finPay.remark}</textarea></td>
							</tr>
							<tr>
								<td><span>附件</span></td>
								<td colspan="9" style="border-right-style:hidden;">
									<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${finPay.attachments }" target='_blank'>
										<input type="text" id="showName" name="showName" value="${finPay.attachName }" style="text-align: left;" readonly>
									</a>
								<td colspan="5">
									<input type="file" id="file" name="file" style="display: none;">
									<c:if test="${not empty finPay.attachments }">
										<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${finPay.attachments }">删除</a>
									</c:if>
									<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;">
								</td>
								</td>
							</tr>

							</tbody>
						</table>
						<div style="width: 100%; text-align: center;margin-top: 10px" class="form-group">
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
							<button type="button" class="btn btn-primary" onclick="submitInfo()" >提交</button>
							<c:if test="${not empty finPay.id }">
								<button type="button" class="btn btn-warning" onclick="del()" >删除</button>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="barginDialog"></div>
<div id="projectDialog"></div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="barginDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; height: 80%;">
		<div class="modal-content" style="height:100%;">
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

<script type="text/javascript" src="<%=base%>/views/manage/finance/pay/js/addOrEdit.js"></script>
</body>
</html>