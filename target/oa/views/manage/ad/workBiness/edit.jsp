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
	width:100%;
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

input{
	text-align: center;
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
										<input type="hidden" id="sessionUserId" name="sessionUserId" value="${sessionScope.user.id}">
										<input type="hidden" id="userId" name="userId" value="${user.id}">
										<input type="hidden" id="id" name="id" value="${buinsess.id }">
										<td style="width: 5%;" class="td_weight"><span>填写人</span></td>
										<td style="width: 10%;"><input type="text"
											value="${user.name }" readonly></td>
										<td style="width: 5%;" class="td_weight"><span>填写日期</span></td>
										<td style="width: 25%;" colspan="2"><input type="text"
											id="applyTime" name="applyTime" value="<fmt:formatDate value="${buinsess.applyTime}" pattern="yyyy-MM-dd" />" readonly></td>
										<td style="width: 10%;" class="td_weight"><span>单位</span></td>
										<td style="width:10%;">
												<c:if test="${dept.name ne '总经理'}">
													<input type="text" value="${dept.name}" readonly>
												</c:if>
											</div>
										</td>
									</tr>
									<tr>
										<td class="td_weight" ><span>日期</span></td>
										<td class="td_weight"><span>时长</span></td>
										<td class="td_weight"><span>交付日期</span></td>
										<td class="td_weight" style="width:5%;"><span>负责人</span></td>
										<td class="td_weight"><span>工作内容</span></td>
										<td class="td_weight"><span>备注</span></td>
										<td class="td_weight"><span>操作</span></td>
									</tr>
									<c:forEach items="${buinsessAttachs}" var="business" varStatus="varStatus">
									<tr name="node">
										<td>
										<input name="workDate" type="text" class="workDate" 
										 text-align: center;" readonly  value="<fmt:formatDate value="${business.workDate }" pattern="yyyy-MM-dd" />" ></td>
										<td>
										<input name="workTime" type="text" id="workTime" class="workTime"  value ="${business.workTime}"
										text-align: center;"></td>
										<td>
										<input name="payDate" type="text" class="payDate" value="<fmt:formatDate value="${business.payDate }" pattern="yyyy-MM-dd" />" 
										text-align: center;" readonly></td>
										<td onclick="openDialog(this)">
										<input name="responsibleUserId" type="hidden" id="responsibleUserId" value="${business.responsibleUserId }">
										<input type="text" name="responsibleUserName" id="responsibleUserName"   readonly class="input" value = "${business.responsibleUserName }" ></td>
										</td>
										<td><textarea name="content" style="width:100%;height:10px;">${business.content}</textarea></td>
										<td><textarea name="remark" style="width:100%;height:10px;">${business.remark }</textarea></td>
										
										<td style="width:6%;">
											<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> 
											<a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
							<div style="width:90%; text-align:center;">
								<button type="button" class="btn btn-primary" id="saveButton" onclick="save()" style="display: none;">保存</button>
								<button type="button" class="btn btn-primary" id="submitButton" onclick="submitinfo()" style="display: none;" >提交</button>
								<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
							</div>
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
		src="<%=base%>/views/manage/ad/workBiness/js/edit.js"></script>
		
		<script>
	var hasEditPermission = false;
	<shiro:hasPermission name="ad:workmanage:edit">
		hasEditPermission = true;
	</shiro:hasPermission>
</script>
</body>
</html>