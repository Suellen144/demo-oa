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
</style>
</head>
<body style="min-width:1100px;overflow:auto;font-size:small;">
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">流水号管理</li>
			<li class="active">添加合同编号</li>
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
						<input type="hidden" id="id" name="id" value="${saleBarginManage.id}">
						<input type="hidden" id="attachments" name="attachments" value="${saleBarginManage.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${saleBarginManage.attachName}">
						<input type="hidden" id="deptId" name="deptId" value="${saleBarginManage.deptId}">
						<input type="hidden" id="userId" name="userId" value="${saleBarginManage.userId}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<input type="hidden" id="createBy" name="createBy" value="${saleBarginManage.createBy}">
						<input type="hidden" id="createDate" name="createDate" value='<fmt:formatDate value="${saleBarginManage.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>'>
						<input type="hidden" id="currStatus" name="currStatus" value="${saleBarginManage.status}">
						<input type="hidden"  id ="currUserId" value="${sessionScope.user.id }"readonly>
						
						<table id="table1">
							<thead>
								<tr><th colspan="12">合同申请表</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width: 10%"><span>发起人</span></td>
									<td style="width: 15%"><input type="text"  id ="name" value="${saleBarginManage.sysUser.name }"readonly></td>
									<td style="width: 10%" ><span>发起时间</span></td>
									<td style="width: 15%"><input type="text" name="applyTime"  id ="applyTime" value='<fmt:formatDate value="${saleBarginManage.applyTime }" pattern="yyyy-MM-dd" />' readonly></td>
									<td ><span>所属单位</span></td>
									<td colspan="8" style="line-height:inherit;text-align:left;">
											<custom:getDictKey type="流程所属公司" value="${saleBarginManage.title}"/>
											<c:if test="${saleBarginManage.dept.name  ne '总经理'}">
												<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${saleBarginManage.dept.name }" readonly>
											</c:if>
									</td>
								</tr>
								<tr>
									<td style="width: 10%" ><span>合同名称</span></td>
									<td ><input type="text" name="barginName"  id ="barginName" value="${saleBarginManage.barginName}" readonly></td>
									<td  style="width: 10%"><span>合同类型</span></td>
									<td><custom:getDictKey type="合同类型" value="${saleBarginManage.barginType}"/></td>
									<td   style="width: 10%"><span>所属项目</span></td>
									<td  colspan="8"><input type="text" name="projectManageId"  id ="projectManageId" value="${saleBarginManage.projectManageId }" style="display: none;"  readonly>
										<input style="text-align: left;"  type="text" name="projectManageName"  id ="projectManageName" value="${saleBarginManage.projectManage.name }"  readonly></td>
									
								</tr>
								<tr>
									<td   style="width: 10%"><span>合同描述</span></td>
									<td colspan="12"><textarea type="text" name="barginDescribe"  id ="barginDescribe" value="" readonly >${saleBarginManage.barginDescribe}</textarea></td>
								</tr>
								<tr>
									<td   style="width: 10%"><span>合同编号</span></td>
									<td ><input type="text" name="barginCode"  id ="barginCode" value="${saleBarginManage.barginCode}" readonly></td>
										<td   style="width: 6%"><span>签订单位</span></td>
									<td style="width: 16%" colspan="7"><input type="text" name="company"  id ="company" value="${saleBarginManage.company}" style="text-align: left;" readonly></td>
									<td   style="width: 10%"><span>合同期限</span></td>
									<td colspan="2"><input id="startTime" name="startTime" value='<fmt:formatDate value="${saleBarginManage.startTime }" pattern="yyyy-MM-dd" />' type="text" class="startTime" style="width: 43%; text-align: center;" readonly> 
											至
										 <input  id="endTime" name="endTime" value='<fmt:formatDate value="${saleBarginManage.endTime }" pattern="yyyy-MM-dd"/>' type="text" class="endTime" style="width: 43%; text-align: center;" readonly>
									</td>
								<tr>
										<td   style="width: 7%"><span>合同总金额</span></td>
										<td colspan="11"><input type="text" name="totalMoney"  id ="totalMoney" value="<fmt:formatNumber value='${saleBarginManage.totalMoney}' pattern='0.00' />" style="text-align: right;" readonly></td>
									</tr>
									
								</tr>
								<tr>
									<td   style="width: 7%"><span>附件</span></td>
									<td colspan="12" >
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${saleBarginManage.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${saleBarginManage.attachName }" style="text-align: left;" readonly>
										</a>
									</td>
								</tr>
				
							</tbody>
						</table>
						<div style="width: 52%; text-align: center;margin:auto;margin-top:5px;">
							<button  type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>
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

<script type="text/javascript" src="<%=base%>/views/manage/sale/barginManage/js/view.js"></script>
</body>
</html>