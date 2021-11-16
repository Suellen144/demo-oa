<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1, #table2 , #table3{
	width: 90%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table1 td, #table2 td , #table3 td {
	border: solid #999 1px;
	padding: 5px;
}
#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	text-align:center;
	outline: medium;
}
#table1 td span, #table2 td span , #table3 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th, #table2 th  {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
#table3 th{
	text-align: center;
	font-size: 1.5em;
}

#table1 thead th {
	border: none;
}

textarea {
	width: 100%;
	resize: none;
	border: none;
	outline: medium;
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


</style>
</head>
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
					
					<form id="form1" >
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">	
						<input type="hidden" id="operStatus" value="">
						<c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.userId ne sessionScope.user.id or (map.task.name ne '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:if>		
						
						<input type="hidden" id="id" name="id" value="${map.business.id}">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName}">
						<input type="hidden" id="deptId" name="deptId" value="${map.business.deptId}">
						<input type="hidden" id="userId" name="userId" value="${map.business.userId}">
						<input type="hidden"  id ="currUserId" value="${sessionScope.user.id }"readonly>
						<input type="hidden" id="createBy" name="createBy" value="${map.business.createBy}">
						<input type="hidden" id="createDate" name="createDate" value='<fmt:formatDate value="${map.business.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>'>
						
						<input type="hidden" id="issubmit" name="issubmit" value="">
						
						<div style="text-align: center;font-weight: bolder;font-size: 1.5em;">
							<thead>
								<tr><th colspan="20">合同申请表</th></tr>
							</thead>
						</div>
						<table id="table1" style="text-align: center;">
							<tbody>
							<tr>
									<td  class="td_weight" style="width: 10%"><span>发起人</span></td>
									<td colspan="1"><input type="text"  id ="name" value="${map.business.sysUser.name }" style="text-align: center;" readonly></td>
									<td  class="td_weight" style="width: 10%"><span>发起时间</span></td>
									<td  colspan="1" style="width: 10%"><input type="text" name="applyTime"  id ="applyTime" style="text-align: center;" value='<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />' readonly></td>
									<td  class="td_weight" style="width: 10%"><span>所属单位</span></td>
									<td colspan="3" style="line-height:inherit;text-align:left;">
											<custom:getDictKey type="流程所属公司" value="${map.business.title }"/>
											<c:if test="${map.business.dept.name  ne '总经理'}">
												<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${map.business.dept.name }" readonly>
											</c:if>
									</td>
								</tr>
								<tr>
									<td class="td_weight"><span>合同名称</span></td>
									<td style="width: 15%"><input type="text" name="barginName"  id ="barginName" value="${map.business.barginName}" style="text-align: center;" readonly></td>
									<td class="td_weight"><span>合同类型</span></td>
									<td><input type="hidden"  id="barginType" name="barginType" value="${map.business.barginType}">
										<custom:getDictKey type="合同类型" value="${map.business.barginType}"/>
									</td>
									<td  class="td_weight"><span>所属项目</span></td>
									<td colspan="8"><input type="text" name="projectManageId"  id ="projectManageId" value="${map.business.projectManageId }" style="display: none;"  readonly>
										<input type="text"  name="projectManageName"  id ="projectManageName" style="text-align: left;" value="${map.business.projectManage.name }"  readonly></td>
								</tr>
								<tr>
									<td  class="td_weight"><span>合同描述</span></td>
									<td colspan="10"><textarea type="text" name="barginDescribe" readonly  id ="barginDescribe"  value="" >${map.business.barginDescribe}</textarea></td>
								</tr>
								<tr>
									<td  class="td_weight"><span>合同编号</span></td>
									<td><input type="text"  id ="barginCode" value="${map.business.barginCode}" readonly></td>
									<td  class="td_weight"><span>签订单位</span></td>
									<td colspan="2"><input type="text" name="company"  id ="company" value="${map.business.company}" style="text-align: left;"  readonly></td>
									<td  class="td_weight" style="width: 10%"><span>合同期限</span></td>
									<td colspan="2" style="width: 15%">
										<input value='<fmt:formatDate value="${map.business.startTime }" pattern="yyyy-MM-dd" />' type="text"  style="width: 43%; text-align: center;" readonly> 
											至
										 <input  value='<fmt:formatDate value="${map.business.endTime }" pattern="yyyy-MM-dd"/>' type="text" style="width: 43%; text-align: center;" readonly>
									</td>
									<%-- <td  class="td_weight"><span>已收金额</span></td>
									<td ><input type="text" name="receivedMoney"  id ="receivedMoney" value="${map.business.receivedMoney}" style="text-align: center;" readonly></td>
									<td  class="td_weight" width="8%"><span>未收金额</span></td>
									<td colspan="4"><input type="text" name="unreceivedMoney"  id ="unreceivedMoney" value="${map.business.unreceivedMoney}"  readonly></td>
									 --%>
								</tr>
								<tr>
									<td  class="td_weight" colspan="1"><span>合同总金额</span></td>
									<td colspan="12"><input type="text" name="totalMoney"  id ="totalMoney" value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />" style="text-align: right;" readonly></td>
								</tr>
								<tr>
									<td  class="td_weight"><span>附件</span></td>
									<td colspan="12" >
										<c:if test="${not empty map.business.id}">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" style="text-align: left;" readonly>
											</a>
										</c:if>
									</td>
								</tr>
							</tbody>
						</table>
						<div id="pay" style="margin-top: 30px"></div>	
					</form>
				</div>
			</div>
		</div>
	</section>
		<section class="content rlspace">
		<div class="row">
			<div class="col-md-12">
				<div class="box box-primary tbspace">
					<table id="table2" style="width:90%;text-align: center;">
						<thead>
							<tr><th colspan="20">处 理 流 程</th></tr>
							<tr style="text-align: center;font-weight: bold;">
								<td class="td_weight" style="width:10%;">环节</td>
								<td class="td_weight" style="width:9%">操作人</td>
								<td class="td_weight" style="width:15%">操作时间</td>
								<td class="td_weight" style="width:10%">操作结果</td>
								<td class="td_weight" style="width:56%">操作备注</td>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</section>
</div>
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
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sale/barginManage/js/viewDetail.js"></script>
<script type="text/javascript">
	var variables = ${map.jsonMap.variables};
</script>
</body>
</html>