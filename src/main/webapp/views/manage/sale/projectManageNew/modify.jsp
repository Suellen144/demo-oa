<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
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

.ulBoxf ul{width:60%;margin:auto;}
.ulBoxf ul li{display: flex;justify-content: center;padding-bottom:20px;}
.ulBoxf ul li input{width: 50%;padding-left: 8px;margin-left: 10px;}
</style>
</head>
<body style="min-width:1100px;overflow:auto;font-size:small;">
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">项目管理</li>
			<li class="active">项目变更</li>
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
						<input type="hidden" id="currStatus" name="currStatus" value="${project.statusNew }">
						<input type="hidden" id="operStatus" value="">
						<c:if test="${map.business.applicantP.id eq sessionScope.user.id and (map.task.name eq '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.applicantP.id ne sessionScope.user.id or (map.task.name ne '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:if>
						<input type="hidden" id="isHandler" value="${map.isHandler}">
						<input type="hidden" id="researchCostLines" value="${project.researchCostLines}">
						<input type="hidden" id="projectId" name="projectId" value="${project.id}">
						<input type="hidden" id ="currUserId" value="${sessionScope.user.id }"readonly>
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<input type="hidden" id="applicationType" name="applicationType" value="2">
						<input type="hidden" id ="status" name="status" value="${project.status}">
						<input type="hidden" id ="createUserId" name="createUserId" value="${sessionScope.user.id }"readonly>
						<div style="text-align: center;font-weight: bolder;font-size: 1.5em;">
							<thead>
								<tr><th colspan="12">项目变更申请</th></tr>
							</thead>							
						</div>
						<table id="table1">
							<tbody>
								<tr><td colspan="12">项目详情</td></tr>
								<tr>
									<td colspan="3">项目名称</td>
									<td colspan="3">
										<input type="text" id="name" name="name" value="${project.name }">
									</td>
									<td colspan="3">负责人</td>
									<td colspan="3" onclick="openDialog(this)">
										<input id="userId" name="userId" type="hidden" value="${project.principal.id }">
										<input type="text" id="userName" name="userName" value="${project.principal.name }" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="3">规模</td>
									<td colspan="3"><input type="text" name="size" id="size" value="${project.size }" onkeyup="initInputBlur()"></td>
									<td colspan="3">合同金额</td>
									<td colspan="3">
										<input type="text" id="barginMoney" name="barginMoney" value="${map.business.applicantP.name }" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="3">收入</td>
									<td colspan="3"><input type="text" id="income" name="income" value="" readonly></td>
									<td colspan="3">支出</td>
									<td colspan="3"><input type="text" id="pay" name="pay" value="" readonly></td>
								</tr>
								<tr>
									<td colspan="3">已使用公关费用</td>
									<td colspan="3"><input type="text" id="ggMoney" name="ggMoney" value="" readonly></td>
									<td colspan="3">归属部门</td>
									<td colspan="3">
										<input id="dutyDeptId" name="dutyDeptId" type="hidden" value="${project.deptD.id}">
										<input type="text" id="dutyDeptName" name="dutyDeptName" value="${project.deptD.name}" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="3">立项时间</td>
									<td colspan="3">
										<input type="text" id="projectDate" name="projectDate" class="projectDate" value="<fmt:formatDate value="${project.projectDate}" pattern="yyyy-MM-dd" />" readonly>
									</td>
									<td colspan="3">结束时间</td>
									<td colspan="3">
										<input type="text" id="projectEndDate" name="projectEndDate" class="projectEndDate" value="<fmt:formatDate value="${project.projectEndDate}" pattern="yyyy-MM-dd" />" readonly>
									</td>
								</tr>
								<tr>
									<td colspan="3">状态</td>
									<c:if test="${project.status == 1 }">
										<td colspan="3">活动</td>
									</c:if>
									<c:if test="${project.status == 0 }">
										<td colspan="3">注销</td>
									</c:if>
									<c:if test="${project.status == -1 }">
										<td colspan="3">关闭</td>
									</c:if>
									<td colspan="3">渠道费用额度</td>
									<td colspan="3"><input type="text" id="qdMoney" name="qdMoney" value="" readonly></td>
								</tr>
								<tr>
									<td colspan="3">已支付渠道费用</td>
									<td colspan="3"><input type="text" id="qdMoneyUsed" name="qdMoneyUsed" value="" readonly></td>
									<td colspan="3">未支付渠道费用</td>
									<td colspan="3"><input type="text" id="qdMoneyResidue" name="qdMoneyResidue" value="" readonly></td>
								</tr>
								<tr>
									<td colspan="3">业绩贡献</td>
									<td colspan="3"><input type="text" id="performanceContribution" name="performanceContribution" value="" readonly></td>
									<td colspan="3">提成额度</td>
									<td colspan="3"><input type="text" id="royaltyQuota" name="royaltyQuota" value="" readonly></td>
								</tr>
								<tr>
									<td colspan="3">申请人</td>
									<td colspan="3">
										<input type="hidden" id="applicant" name="applicant" value="${project.applicant}">
										<input type="text" id="" value="${project.applicantP.name} " readonly>
									</td>
									<td colspan="3">申请时间</td>
									<td colspan="3"><input type="text" id="submitDate" name="submitDate" value="<fmt:formatDate value="${project.submitDate}" pattern="yyyy-MM-dd" />" readonly></td>
								</tr>
								<tr>
									<td colspan="3">项目说明</td>
									<td colspan="9">
										<textarea id="describe" name="describe" placeholder="项目说明" rows="3" cols="30" readonly></textarea>
									</td>
								</tr>
							</tbody>
						</table>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">项目成员</span>
						</div>
						<table id="table3" style="text-align: center;width:90%;">
							<thead>
								<tr>
									<td>姓名</td>
								<%--	<td>业绩比例</td>--%>
									<td>业绩分配</td>
								</tr>
								</thead>
							<tbody id="tbodyInfoTr">
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
						</table>
						<div style="width: 100%; text-align: center;margin-top: 6px" class="form-group" >													
							<button type="button" id="submitBtn" class="btn btn-primary" onclick="submitInfo()">提交</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>	
		</div>				
	</section>
</div>
<div id="userDialog"></div>
<div id="userByDeptDialog"></div>
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

<script type="text/javascript" src="<%=base%>/views/manage/sale/projectManageNew/js/modify.js"></script>
<script type="text/javascript">
	base = "<%=base%>";
	
	$("#describe").val("${project.describe}"); 
	
	var demo1 = 0,demo2 = 0;
	$("#tbodyInfoTr tr").each(function(i,j){
		if($(j).attr('name') == 'cumulative'){
			$(j).find('td').eq(1).html(demo1);
			$(j).find('td').eq(2).html(demo2);
		}else{
			demo1 +=  parseInt($(j).find("#resultsProportion").val())
			demo2 +=  parseInt($(j).find("#commissionProportion").val())
		}		
	})
</script>
</body>
</html>