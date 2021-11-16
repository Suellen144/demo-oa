<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1, #table2 {
	width: 90%;
	text-align:center;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table1 td, #table2 td {
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
#table1 td span, #table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th, #table2 th {
	border: solid #999 1px;
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

	<c:forEach items="${projectHistoryList }" var="projectHistory" varStatus="varStatus">
		<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace" style="border:0;">
					<div style="text-align: left;line-height:20px;padding-bottom:5px;font-weight: normal;font-size: 20px;width: 90%;margin: auto;">
						<span>变更发起人：${projectHistory.alteredPerson.name}</span>
						<span>变更时间：<fmt:formatDate value="${projectHistory.createDate}" pattern="yyyy-MM-dd" /></span>		
					</div>
							<table id="table1">
								<tbody>
									<tr><td colspan="12">项目详情</td></tr>
									<tr>
										<td colspan="3">项目名称</td>
										<td colspan="3">
											<input type="text" id="name" name="name" value="${projectHistory.name }" readonly>
										</td>
										<td colspan="3">负责人</td>
										<td colspan="3">
											<input type="text" id="userName" name="userName" value="${projectHistory.principal.name }" readonly>
										</td>
									</tr>
									<tr>
										<td colspan="3">规模</td>
										<td colspan="3"><input type="text" name="size" id="size" value="${projectHistory.size }"></td>
										<td colspan="3">合同金额</td>
										<td colspan="3">
											<input type="text" id="barginMoney" name="barginMoney" value="${projectHistory.barginMoney }" readonly>
										</td>
									</tr>
									<tr>
										<td colspan="3">收入</td>
										<td colspan="3"><input type="text" id="income" name="income" value="${projectHistory.income }" readonly></td>
										<td colspan="3">支出</td>
										<td colspan="3"><input type="text" id="pay" name="pay" value="${projectHistory.pay }" readonly></td>
									</tr>
									<tr>
										<td colspan="3">已使用公关费用</td>
										<td colspan="3"><input type="text" id="ggMoney" name="ggMoney" value="${projectHistory.pay }" readonly></td>
										<td colspan="3">归属部门</td>
										<td colspan="3">
											<input type="text" id="dutyDeptName" name="dutyDeptName" value="${projectHistory.deptD.name}" readonly>
										</td>
									</tr>
									<tr>
										<td colspan="3">立项时间</td>
										<td colspan="3">
											<input type="text" id="projectDate" name="projectDate" class="projectDate" value="<fmt:formatDate value="${projectHistory.projectDate}" pattern="yyyy-MM-dd" />" readonly>
										</td>
										<td colspan="3">结束时间</td>
										<td colspan="3">
											<input type="text" id="projectEndDate" name="projectEndDate" class="projectEndDate" value="<fmt:formatDate value="${projectHistory.projectEndDate}" pattern="yyyy-MM-dd" />" readonly>
										</td>
									</tr>
									<tr>
										<td colspan="3">状态</td>
										<c:if test="${projectHistory.status == 1 }">
											<td colspan="3">活动</td>
										</c:if>
										<c:if test="${projectHistory.status == 0 }">
											<td colspan="3">注销</td>
										</c:if>
										<c:if test="${projectHistory.status == -1 }">
											<td colspan="3">关闭</td>
										</c:if>
										<td colspan="3">渠道费用额度</td>
										<td colspan="3">${projectHistory.qdMoney}</td>
									</tr>
									<tr>
										<td colspan="3">已支付渠道费用</td>
										<td colspan="3"><input type="text" id="qdMoneyUsed" name="qdMoneyUsed" value="${projectHistory.qdMoneyUsed}" readonly></td>
										<td colspan="3">未支付渠道费用</td>
										<td colspan="3"><input type="text" id="qdMoneyResidue" name="qdMoneyResidue" value="${projectHistory.qdMoneyResidue}" readonly></td>
									</tr>
									<tr>
										<td colspan="3">业绩贡献</td>
										<td colspan="3"><input type="text" id="performanceContribution" name="performanceContribution" value="${projectHistory.performanceContribution}" readonly></td>
										<td colspan="3">提成额度</td>
										<td colspan="3"><input type="text" id="royaltyQuota" name="royaltyQuota" value="${projectHistory.royaltyQuota}" readonly></td>
									</tr>
									<tr>
										<td colspan="3">申请人</td>
										<td colspan="3">
											<input type="text" id="" value="${projectHistory.applicantP.name} " readonly>
										</td>
										<td colspan="3">申请时间</td>
										<td colspan="3"><input type="text" id="submitDate" name="submitDate" value="<fmt:formatDate value="${projectHistory.submitDate}" pattern="yyyy-MM-dd" />" readonly></td>
									</tr>
									<tr>
										<td colspan="3">项目描述</td>
										<td colspan="9">
											<textarea id="describe" name="describe"  rows="3" cols="30" readonly>${projectHistory.describe}</textarea>
										</td>
									</tr>
									<tr><td colspan="12">项目成员</td></tr>
									<tr name="" class="node trnode">
										<td colspan="6">姓名</td>
									<%--	<td colspan="4">业绩比例</td>--%>
										<td colspan="6">业绩分配</td>
									</tr>
								</tbody>
								<tbody id="tbodyInfoTr">
									<c:forEach items="${projectHistory.projectMemberHistoryList }" var="projectMemberHistory" varStatus="varStatus">
										<tr name="node" >
											<td colspan="6">
				    							<input type="text" id="uName" name="uName" value="${projectMemberHistory.principal.name}" readonly />
				 							</td>
				    						<%--<td colspan="4"><input type="text" id="resultsProportion" name="resultsProportion" value="${projectMemberHistory.resultsProportion}" readonly /></td>--%>
				    						<td colspan="6"><input type="text" id="commissionProportion" name="commissionProportion" value="${projectMemberHistory.commissionProportion}" readonly /></td>
										</tr>
									</c:forEach>
									<tr name="cumulative">
										<td colspan="6">累计</td>
										<td colspan="6"></td>
									</tr>
								</tbody>
							</table>
				</div>
			</div>	
		</div>				
	</section>
	</c:forEach>
	<!-- Main content -->
	
</div>
<div id="userDialog"></div>
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

<%-- <script type="text/javascript" src="<%=base%>/views/manage/sale/projectManageNew/js/modify.js"></script> --%>
<script type="text/javascript">
	base = "<%=base%>";
	
	$("#describe").val("${projectHistory.describe}");
	
	var demo2 = 0;
	$("#tbodyInfoTr tr").each(function(i,j){
		if($(j).attr('name') == 'cumulative'){
			$(j).find('td').eq(1).html(demo2+"%");
			demo2 = 0;
		}else{
			demo2 +=  parseInt($(j).find("#commissionProportion").val())
		}		
	})
</script>
</body>
</html>