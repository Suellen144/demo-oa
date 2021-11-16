<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
table {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
table td {
	border: solid #999 1px;
	padding: 5px;
}
table thead th {
	border: none;
}

select{
  appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
  text-align-last:center;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}

table td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	text-align:center;
	outline: medium;
}
table td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
table th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
textarea {
	width: 100%;
	height:100%;
	resize: none;
	border: none;
	outline: medium;
	vertical-align: middle;
	padding-top: 8px;
	padding-bottom: 8px;
}

</style>
</head>
<body style="min-width:1100px;overflow:auto;font-size:small;">
<body>
<div class="wrapper">

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					
					<form id="form1" style="vertical-align: middle;text-align: center">
						<input type="hidden" id="annual_id" name="annual_id" value="${saleBarginUserAnnual.id}">
						<%--<input type="hidden" id="annual" name="annual" value="${saleBarginUserAnnual.annual}">--%>

					
						<table id="table1">
							<thead>
								<tr ><th colspan="12">合同年度申请表</th></tr>
							</thead>
							<tbody>
								<tr>
									<td colspan="1"><span>年度</span></td>
									<td colspan="5">
										<c:if test="${empty saleBarginUserAnnual.annual}">
											<input type="text" name="annual" id ="annual" value="">
										</c:if>
										<c:if test="${not empty saleBarginUserAnnual.annual}">
											<input type="text" name="annual" id ="annual" value="${saleBarginUserAnnual.annual}">
										</c:if>
									</td>
								</tr>
								<tr>
									<td style="width: 8%"><span>合同名称</span></td>
									<td style="width: 8%"><span>年度支出</span></td>
									<td style="width: 8%"><span>年度收入</span></td>
									<td style="width: 8%"><span>年度提成比例(%)</span></td>
									<td style="width: 8%"><span>年度提成</span></td>
									<td style="width: 8%"><span>操作</span></td>
									<%--<td><span>費用性质</span></td>--%>
									<%--<td><span>收款单位</span></td>--%>
									<%--<td><span>收款账号</span></td>--%>
									<%--<td><span>操作</span></td>--%>
								</tr>

								<c:if test="${not empty saleBarginUserAnnual.id and not empty saleBarginUserAnnual.barginAttachs}">
									<c:forEach items="${saleBarginUserAnnual.barginAttachs}" var="SaleBarginUserAnnualAttach" varStatus="varStatus">
										<tr name="node">
											<input type="hidden"  name="attachId" value="${SaleBarginUserAnnualAttach.id}">
											<td>
												<input type="hidden" name="barginId"
													   value="${SaleBarginUserAnnualAttach.barginId}">
												<input type="text" name="barginName"
													   value="${SaleBarginUserAnnualAttach.saleBarginManage.barginName}" readonly>
											</td>
											<td>
												<input type="text" name="barginAnnualPay"
													   value="${SaleBarginUserAnnualAttach.barginAnnualPay}"
													   onkeyup="initCountAnnualCommission(this)">
											</td>
											<td>
												<input type="text" name="barginAnnualIncome"
													   value="${SaleBarginUserAnnualAttach.barginAnnualIncome}"
												       onkeyup="initCountAnnualCommission(this)">
											</td>
											<td>
												<input type="text" name="barginAnnualCommissionPercent"
													   value="${SaleBarginUserAnnualAttach.barginAnnualCommissionPercent}"
												       onkeyup="initCountAnnualCommission(this)">
											</td>
											<td>
												<input type="text" name="barginAnnualCommission"
													   value="${SaleBarginUserAnnualAttach.barginAnnualCommission}">
											</td>
											<td>
												<input type="hidden" name="commissionId"
													   value="${SaleBarginUserAnnualAttach.commissionId}">
												<button class="btn btn-primary" type="button"  data-toggle="modal" data-target="#myModal"
														onclick="writePersion(this)">操作</button>
											</td>
										</tr>
									</c:forEach>
								</c:if>
								<c:if test="${empty saleBarginUserAnnual.id and not empty saleBarginUserAnnual.saleBarginManageList}">
									<c:forEach items="${saleBarginUserAnnual.saleBarginManageList}" var="SaleBarginManage" varStatus="varStatus">
										<tr name="node">
											<input type="hidden"  name="attachId" value="">
											<td>
												<input type="hidden" name="barginId"
													   value="${SaleBarginManage.id}">
												<input type="text" name="barginName"
													   value="${SaleBarginManage.barginName}">
											</td>
											<td>
												<input type="text" name="barginAnnualPay" value=""
													   onkeyup="initCountAnnualCommission(this)">
											</td>
											<td>
												<input type="text" name="barginAnnualIncome" value=""
													   onkeyup="initCountAnnualCommission(this)">
											</td>
											<td>
												<input type="text" name="barginAnnualCommissionPercent" value="5"
													   onkeyup="initCountAnnualCommission(this)">
											</td>
											<td>
												<input type="text" name="barginAnnualCommission" value="">
											</td>
											<td>
												<input type="hidden" name="commissionId" value="">
												<button class="btn btn-primary"  data-toggle="modal"  type="button" data-target="#myModal"
														onclick="writePersion(this)">操作</button>
											</td>
										</tr>
									</c:forEach>
								</c:if>
							</tbody>
						</table>
						<div style="width: 100%; text-align: center;margin-top: 10px" class="form-group">
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>
<div class="modal fade bs-example-modal-lg" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 id="modalTitle" class="modal-title"></h4>
			</div>
			<div class="modal-body" id="singleDetail_content">
				<form id="form2" style="vertical-align: middle;text-align: center">
				<input id="commissionId" type="hidden" name="commissionId" value="">
				<table id="table2" >
					<thead>
						<tr>
							<td style="width: 25%">部门</td>
							<td style="width: 25%">用户</td>
							<td style="width: 25%">用户提成比例(%)</td>
							<td style="width: 25%">用户提成</td>
						</tr>
					</thead>
					<tbody id="user_content">
					</tbody>
				</table>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="savePersonCommission()">保存</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>
<%@ include file="../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
	base = "<%=base%>";
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sale/barginUserAnnualAttach/js/list.js"></script>
</body>
</body>
</html>