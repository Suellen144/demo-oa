<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<style>
#table1 {
	width: 90%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table2 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table1 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table2 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
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
	outline: medium;
}

#table2 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}


#table1 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table2 th {
	border: none;
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
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">收款管理</li>
			<li class="active">申请收款</li>
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
						<input type="hidden" id="userId" name="userId" value="${sessionScope.user.id }">
						<input type="hidden" id="deptId" name="deptId" value="${sessionScope.user.dept.id }">
						<input type="hidden" id="id" name="id" value="${finCollection.id }">
						<input type="hidden" id="attachments" name="attachments" value="${finCollection.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${finCollection.attachName}">
						<input type="hidden" id="barginProcessInstanceId" value="${finCollection.barginManage.processInstanceId}">
						<input type="hidden" id="isSubmit" name="isSubmit" value="">
						<input type="hidden" id="isNewProject" name="isNewProject" value="1">
						<input type="hidden" id="isNewProcess" name="isNewProcess" value="1">
						<input type="hidden" id="isInvoiced" name="isInvoiced" value="0">
						<input type="hidden" id="barginId" name="barginId" value="${finCollection.barginId }">
						<input type="hidden" id="projectId" name="projectId" value="${finCollection.projectId }">
						<input type="hidden" id="isOldData" name="isOldData" value="1">
                        <input type="hidden" id="principalId" name="principalId"  value="${finCollection.projectManage.principal.id}">
                        <input type="hidden" id="principalName"   value="${finCollection.projectManage.principal.name}">
						<table id="table1">
							<thead>
								<tr><th colspan="20">收款登记</th></tr>
							</thead>
							<tbody>
								<tr>
									<td><span>合同编号</span></td>
									<td>
										<input type="text" id="barginCode" value="${finCollection.barginManage.barginCode}" readonly onclick="viewBargin()">
									</td>
									<td><span>合同名称</span></td>
									<td>
										<input type="text" id="barginName" value="${finCollection.barginManage.barginName}" readonly onclick="viewBargin()">
									</td>
									<td ><span>项目名称</span></td>
									<td colspan="3">
										<input  type="text" id="projectManageName" value="${finCollection.projectManage.name}" readonly>
									</td>
								</tr>
								<tr>
									<td><span>合同金额</span></td>
									<td>
										<input  type="text" id="totalPay" name="totalPay" value="<fmt:formatNumber value='${finCollection.barginManage.totalMoney }' pattern='0.00'/>" onkeyup="initInputBlur()" >
									</td>
									<td><span>收款金额</span></td>
									<td>
										<input type="text"  name="applyPay" id="applyPay" onkeyup="initInputBlur()" value="<fmt:formatNumber value='${finCollection.applyPay}' pattern='0.00' />" onchange="checkDate()">
									</td>
									<td ><span>渠道费用</span></td>
									<td colspan="3">
									<input type="text"  name="channelCost" id="channelCost" value="${finCollection.channelCost}" onkeyup="initInputBlur()" onchange="checkDate()">
									</td>
								</tr>
								<tr>
									<td><span>提成基数</span></td>
									<td>
										<input type="text"  name="commissionBase" id="commissionBase" value="${finCollection.commissionBase}" onkeyup="initInputBlur()" >
									</td>
									<td><span>提成比例</span></td>
									<td>
									<select id="commissionProportion" name="commissionProportion"  style="width:100%;" >
											<option value="0" <c:if test="${finCollection.commissionProportion == '0'}"> selected </c:if>>0%</option>
											<option value="5" <c:if test="${finCollection.commissionProportion == '5'}"> selected </c:if>>5%</option>
											<option value="10" <c:if test="${finCollection.commissionProportion == '10'}"> selected </c:if>>10%</option>
										</select>
									</td>
									<td><span>分配额度</span></td>
									<td colspan="3">
										<input type="text" name="allocations" id="allocations" value="${finCollection.allocations}" onkeyup="initInputBlur()">
									</td>
								</tr>
								<tr>
									<td><span>收款类型</span></td>
									<td>
										<select  style="width: 100%" name="collectionType"><custom:dictSelect type="费用性质" selectedValue="${finCollection.collectionType }"/></select>
									</td>
									<td><span>付款单位</span></td>
									<td>
										<input type="text"  name="payCompany" id="payCompany"  value="${finCollection.payCompany}">
									</td>
                                    <td><span>收款时间</span></td>
                                    <td colspan="3">
                                        <input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${finCollection.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
                                    </td>
									
								</tr>
								<tr>
								<td><span>关联合同</span></td>
									<td colspan="10" style="text-align:left;">
										<input type="button" value="请选择合同" onclick="openBargin()" style="border:none;">
										<input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="border:none;display:none;">
									</td>
								</tr>
								<%--<tr>
									<td><span>申请人</span></td>
									<td>
										<input type="text" value="${sessionScope.user.name }" readonly>
										<input type="hidden" id="applyUserId" name="applyUserId" value="${sessionScope.user.id }" readonly></td>
									</td>
									<td  style="width:10%;"><span>所属单位</span></td>
									<td>
										<div style="float: left;height:20px;font-size: 15px;">
											<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
												<div style="float: left;">
													<select name="applyUnit" disabled="disabled"><custom:dictSelect
															type="流程所属公司" /></select>
												</div>
											</c:if>
											<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
												<div style="float: left;">
													<input name="applyUnit" value="10" type="hidden">
													<custom:getDictKey type="流程所属公司" value="10"/>
												</div>
											</c:if>
											<div style="float: left;height:20px;font-size: 15px;">
												<c:if test="${sessionScope.user.dept.name ne '总经理'}">
													<input  type="text" value="${sessionScope.user.dept.name }" readonly>
												</c:if>
											</div>
											<div style="clear: both"></div>
										</div>
									</td>
									<td><span>申请时间</span></td>
									<td colspan="3">
										<input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${finCollection.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
									</td>
								</tr>--%>
								<tr>
									<td><span>附件</span></td>
									<td colspan="6" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${finCollection.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${finCollection.attachName }" style="text-align: left;" readonly>
										</a>
									<td colspan="3">
										<input type="file" id="file" name="file" style="display: none;">
										<c:if test="${not empty finCollection.attachments }">
											<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${finCollection.attachments }">删除</a>
										</c:if>
										<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;">
									</td>
									</td>
								</tr>
								<tr>
									<td><span>备注</span></td>
									<td colspan="20" style="text-align:left;">
										<textarea name ="reason">${finCollection.reason }</textarea>
									</td>
								</tr>

								<%--<c:if test="${finCollection.status eq '4' or finCollection.collectionBill != null or finCollection.collectionBill != null}" >
									<tr>
										<td><span>收款金额</span></td>
										<td colspan="3">
											<input type="text" class="linkage" name="collectionBill" id="collectionBill" value="${finCollection.collectionBill}">
										</td>
										<td><span>收款时间</span></td>
										<td colspan="3">
											<input type="text" id="collectionDate" name="collectionDate" value="<fmt:formatDate value="${finCollection.collectionDate }" pattern="yyyy-MM-dd" />" style="color:gray;">
										</td>
									</tr>
								</c:if>--%>
								</tbody>
						</table>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">提成分配方案</span>
						</div>
							<table id="table2" style="text-align: center;width:90%;">
							<thead>
								<tr  name='node1' class='node1'>
								<td >参与人员</td>
								<td >业绩分配</td>
								</tr>
							</thead>
							<tbody id="tableTbody" >
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
							</table>
						<div style="width: 80%; text-align: center;margin:auto;padding-top:5px;">
							<button type="button" class="btn btn-primary" onclick="submitinfo()" >提交</button>
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="userDialog"></div>
<div id="barginDialog"></div>
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
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/collection/js/addNew.js"></script>
<script type="text/javascript" src="<%=base%>/static/js/layer/layer.js"></script>
</body>
</html>