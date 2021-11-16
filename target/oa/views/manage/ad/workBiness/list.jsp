<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet"
	href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1 {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
}

#table1 td {
	border: solid #999 1px;
	padding: 5px;
	text-align: center;
}

#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table1 td span {
	padding: 0px 15px;
}

#table1 th {
	text-align: center;
	font-size: 1.5em;
}

textarea {
	resize: none;
	border: none;
	outline: medium;
}

input{
	text-align: center;
}

select {
	appearance: none;
	-moz-appearance: none;
	-webkit-appearance: none;
	border: none;
}

/* IE10以上生效 */
select::-ms-expand {
	display: none;
}

.td_weight {
	font-weight: bold;
}

.nest_td {
	padding: 0px !important;
}

.nest_td table {
	width: 100% !important;
}

.nest_td td {
	border: none !important;
}

.nest_td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

td.nest_td_left {
	border-right: solid #999 1px !important;
	width: 30% !important;
}

</style>
</head>
<body>
	<div class="wrapper">
		<header>
			<ol class="breadcrumb">
				<li class="active">主页</li>
				<li class="active">行政管理</li>
				<li class="active">出差管理</li>
				<li class="active">申请出差</li>
			</ol>
		</header>

		<!-- Main content -->
		<section class="content rlspace">
			<div class="row">
				<div class="col-md-12">
					<div class="box box-primary tbspace">
						<form id="form1">
							<table id="table1">
								<thead>
									<tr>
										<th colspan="20">商务工作登记表</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<input type="hidden" name = status  id="status" value="${buinsess.status}" readonly>
										<input type="hidden" id="id" name="id" value="${buinsess.id }">
										<td style="width: 8%;" class="td_weight"><span>填写人</span></td>
										<td style="width: 10%;"><input type="text"
											value="${user.name }" readonly></td>
										<td style="width: 8%;" class="td_weight"><span>填写日期</span></td>
										<td style="width: 25%;" colspan="2"><input type="text"
											id="applyTime" name="applyTime" value="<fmt:formatDate value="${buinsess.applyTime}" pattern="yyyy-MM-dd" />" readonly></td>
										<td style="width: 8%;" class="td_weight"><span>单位</span></td>
										<td style="width:16%;">
											<c:if test="${dept.name ne '总经理'}">
												<input style="font-size: 15px;" type="text" value="广东睿哲科技股份有限公司${dept.name }" readonly>
											</c:if>
										</td>
									</tr>
									<tr>
										<td class="td_weight" ><span>日期</span></td>
										<td class="td_weight"><span>时长</span></td>
										<td class="td_weight"><span>交付日期</span></td>
										<td class="td_weight" style="width:8%;"><span>负责人</span></td>
										<td class="td_weight"><span>工作内容</span></td>
										<td class="td_weight" colspan ="3"><span>备注</span></td>
									</tr>
									<c:forEach items="${buinsessAttachs}" var="business" varStatus="varStatus">
									<tr name="node">
										<td>
										<input name="workDate" type="text" 
										 text-align: center;" readonly  value="<fmt:formatDate value="${business.workDate }" pattern="yyyy-MM-dd" />" ></td>
										<td>
										<input name="workTime" type="text" id="workTime"  readonly value ="${business.workTime}"
										text-align: center;"></td>
										<td>
										<input name="payDate" type="text" readonly  value="<fmt:formatDate value="${business.payDate }" pattern="yyyy-MM-dd" />" 
										text-align: center;" readonly></td>
										<td>
										<input name="responsibleUserId" type="hidden" id="responsibleUserId">
										<input type="text" name="responsibleUserName" id="responsibleUserName"   readonly class="input" value = "${business.responsibleUserName }" ></td>
										</td>
										<td>
										<textarea name="content" style="width:100%;height:10px;;" readonly>${business.content}
										</textarea></td>
										<td colspan="3">
										<textarea name="remark" readonly
										text-align: center;">${business.remark }</textarea></td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</form>
					</div>
				</div>
			</div>
		</section>
	</div>
	<div id="userDialog"></div>
	<%@ include file="../../common/footer.jsp"%>
	<script type="text/javascript">
	base = "<%=base%>";
	</script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

	<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
	<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
	<script type="text/javascript"
		src="<%=base%>/views/manage/ad/workBiness/js/list.js"></script>
</body>
</html>