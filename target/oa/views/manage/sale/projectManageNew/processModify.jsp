<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<style>
#table1, #table2, #table3 {
	width: 90%;
	text-align:center;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table1 td, #table2 td, #table3 td {
	border: solid #999 1px;
	padding: 5px;
}
#table1 td input[type="text"],#table3 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	text-align:center;
	outline: medium;
}
#table1 td span, #table2 td span, #table3 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th, #table2 th, #table3 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
#table1 thead th,#table3 thead th {
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
<body style="min-width:1100px;overflow:auto;font-size:small;">
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">付款管理</li>
			<li class="active">付款流程审批</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.statusNew }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
						<input type="hidden" id="operStatus" value="">
						<c:if test="${map.business.applicantP.id eq sessionScope.user.id and (map.task.name eq '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.applicantP.id ne sessionScope.user.id or (map.task.name ne '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:if>

						<input type="hidden" id="isHandler" value="${map.isHandler}">
						<input type="hidden" id="id" name="id" value="${map.business.id}">
						<input type="hidden" id ="currUserId" value="${sessionScope.user.id }"readonly>
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<input type="hidden" id="projectId" name="projectId" value="${map.business.projectId }">

						<div style="text-align: center;font-weight: bolder;font-size: 1.5em;">
							<thead>
								<c:choose>
									<c:when test="${map.business.statusNew eq '5' }">
										<tr><th colspan="12">项目变更详情表</th></tr>
									</c:when>
									<c:otherwise>
										<tr><th colspan="12">项目变更申请表</th></tr>
									</c:otherwise>
								</c:choose>
							</thead>							
						</div>
						<table id="table1">
							<tbody>
								<tr><td colspan="12">项目详情</td></tr>
								<tr>
									<td colspan="3">项目名称</td>
									<td colspan="3">
										<input type="text" id="name" name="name" value="${map.business.name }" readonly>
									</td>
									<td colspan="3">负责人</td>
									<td colspan="3" onclick="openDialog(this)">
										<input id="userId" name="userId" type="text" style="display:none;" value="${map.business.principal.id }">
										<input type="text" id="userName" name="userName" value="${map.business.principal.name }" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="3">规模</td>
									<td colspan="3"><input type="text" name="size" id="size" value="${map.business.size }"></td>
									<td colspan="3">合同金额</td>
									<td colspan="3">
										<input type="text" id="barginMoney" name="barginMoney" value="${map.business.barginMoney }" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="3">收入</td>
									<td colspan="3"><input type="text" id="income" name="income" value="${map.business.income }" readonly></td>
									<td colspan="3">支出</td>
									<td colspan="3"><input type="text" id="pay" name="pay" value="${map.business.pay }" readonly></td>
								</tr>
								<tr>
									<td colspan="3">已使用公关费用</td>
									<td colspan="3"><input type="text" id="ggMoney" name="ggMoney" value="${map.business.pay }" readonly></td>
									<td colspan="3">归属部门</td>
									<td colspan="3">
										<input id="dutyDeptId" name="dutyDeptId" type="text" style="display:none;" value="${map.business.deptD.id}">
										<input type="text" id="dutyDeptName" name="dutyDeptName" value="${map.business.deptD.name}" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="3">立项时间</td>
									<td colspan="3">
										<input type="text" id="projectDate" name="projectDate" class="projectDate" value="<fmt:formatDate value="${map.business.projectDate}" pattern="yyyy-MM-dd" />" readonly>
									</td>
									<td colspan="3">结束时间</td>
									<td colspan="3">
										<input type="text" id="projectEndDate" name="projectEndDate" class="projectEndDate" value="<fmt:formatDate value="${map.business.projectEndDate}" pattern="yyyy-MM-dd" />" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="3">状态</td>
									<c:if test="${map.business.status == 1 }">
										<td colspan="3">活动</td>
									</c:if>
									<c:if test="${map.business.status == 0 }">
										<td colspan="3">注销</td>
									</c:if>
									<c:if test="${map.business.status == -1 }">
										<td colspan="3">关闭</td>
									</c:if>
									<td colspan="3">渠道费用额度</td>
									<td colspan="3"><input type="text" id="qdMoney" name="qdMoney" value="${map.business.qdMoney}" readonly></td>
								</tr>
								<tr>
									<td colspan="3">已支付渠道费用</td>
									<td colspan="3"><input type="text" id="qdMoneyUsed" name="qdMoneyUsed" value="${map.business.qdMoneyUsed}" readonly></td>
									<td colspan="3">未支付渠道费用</td>
									<td colspan="3"><input type="text" id="qdMoneyResidue" name="qdMoneyResidue" value="${map.business.qdMoneyResidue}" readonly></td>
								</tr>
								<tr>
									<td colspan="3">业绩贡献</td>
									<td colspan="3"><input type="text" id="performanceContribution" name="performanceContribution" value="${map.business.performanceContribution}" readonly></td>
									<td colspan="3">提成额度</td>
									<td colspan="3"><input type="text" id="royaltyQuota" name="royaltyQuota" value="${map.business.royaltyQuota}" readonly></td>
								</tr>
								<tr>
									<td colspan="3">申请人</td>
									<td colspan="3">
										<input type="hidden" id="applicant" name="applicant" value="${map.business.applicant}">
										<input type="text" id="" value="${map.business.applicantP.name} " readonly>
									</td>
									<td colspan="3">申请时间</td>
									<td colspan="3"><input type="text" id="submitDate" name="submitDate" value="<fmt:formatDate value="${map.business.submitDate}" pattern="yyyy-MM-dd" />" readonly></td>
								</tr>
								<tr>
									<td colspan="3"><span>项目说明</span></td>
									<td colspan="11">
										<textarea id="describe" name="describe" placeholder="项目说明" rows="3" cols="30"></textarea>
									</td>
								</tr>
							</tbody>
							<tfoot>
								<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
									<tr>
										<td colspan="34">
											<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:70%;height:100%;"></textarea>
										</td>
									</tr>
								</c:if>
							</tfoot>
						</table>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">项目成员</span>
						</div>
						<c:choose>
						<c:when test="${map.business.statusNew eq '5' }">
						<table id="table3" style="text-align: center;width:90%;">
							<thead>
								<tr>
									<td>姓名</td>
									<td>业绩分配</td>
								</tr>
								</thead>
							<tbody id="tbodyInfoTr1">
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
						</table>
						</c:when>
						<c:otherwise>
						<table id="table3" style="text-align: center;width:90%;">
							<thead>
								<tr>
									<td>姓名</td>
									<%--<td>业绩比例</td>--%>
									<td>业绩分配</td>
								</tr>
								</thead>
							<tbody id="tbodyInfoTr">
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
						</table>
						</c:otherwise>
						</c:choose>
						<div style="width: 100%; text-align: center;margin-top: 6px" class="form-group" >
							<c:if test="${map.business.applicantP.id eq sessionScope.user.id and (map.task.name eq '项目负责人')}">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve('提交')">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name ne '提交申请' }">
								<button type="button" class="btn btn-primary" onclick="approve('同意')">同意</button>
								<button type="button" class="btn btn-warning" onclick="approve('不同意')">不同意</button>
							</c:if>
							<c:if test="${map.business.applicant eq sessionScope.user.id and map.task.name eq '提交申请' }">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve('重新申请')">保存并提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>	
		</div>				
	</section>
	<section class="content rlspace">
		<div class="row">
			<div class="col-md-12">
				<div class="box box-primary tbspace">
					<table id="table2" style="width: 90%">
						<thead>
							<tr><th colspan="20" style="text-align: center;font-weight: bolder;font-size: 1.5em;">处 理 流 程</th></tr>
							<tr style="font-weight: bolder;">
								<td  style="width:10%;">环节</td>
								<td  style="width:9%">操作人</td>
								<td  style="width:15%">操作时间</td>
								<td  style="width:10%">操作结果</td>
								<td  style="width:56%">操作备注</td>
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
<div id="barginDialog"></div>
<div id="userDialog"></div>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sale/projectManageNew/js/processModify.js"></script>
<script type="text/javascript">
	base = "<%=base%>";
	var variables = ${map.jsonMap.variables};

	var isCashier = false;
	var userId=${sessionScope.user.id};
	var status=${map.business.status};
	
	if(userId==3&&status==5){
		isCashier = true;
	}
	
	var isCashierTask = false;
	if(status==4){
		isCashierTask = true;
	}
	
	//已归档 
	if(status==5){
		$("#saveBtn").hide();
		$("#updateFormBtn").hide();
	}
	
	var describe = "${map.business.describe}";
	$("#describe").val(describe); 
	
	var demo1 = 0,demo2 = 0;
	$("#tbodyInfoTr tr").each(function(i,j){
		if($(j).attr('name') == 'cumulative'){
			$(j).find('td').eq(1).html(demo1);
			$(j).find('td').eq(2).html(demo2);
		}else{
			demo1 +=  parseInt($(j).find("#resultsProportion").val())
			demo2 +=  parseInt($(j).find("#commissionProportion").val())
		}		
	});
</script>
</body>
</html>