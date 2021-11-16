<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1 {
	width: 98%;
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
  text-align-last:center;
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
						<input type="hidden" id="id" name="id" value="${commonPay.id}">
						<input type="hidden" id="attachments" name="attachments" value="${commonPay.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${commonPay.attachName}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
					
						<table id="table1">
							<thead>
								<tr ><th colspan="12">银行常规付款申请表</th></tr>
							</thead>
							<tbody>
								<tr>
									<td colspan="1"><span>制单人</span></td>
									<td colspan="2">
										<c:if test="${empty commonPay.id}">
											<input type="text"  id ="name" value="${sessionScope.user.name }"readonly>
										</c:if>
										<c:if test="${not empty commonPay.id}">
											<input type="text"  id ="name" value="${commonPay.user.name }"readonly>
										</c:if>
									</td>
									<td colspan="2"><span>付款单位</span></td>
									<td colspan="2">
									<select name="payCompany"  id="payCompany" style="height:20px;display: inline-block;"><custom:dictSelect type="流程所属公司" selectedValue="${commonPay.payCompany}"/></select>
									<input type="text" value="${commonPay.dept.name }" readonly>
									</td>
									<td colspan="1"><span>发起时间</span></td>
									<td  colspan="1">
										<input type="text" name="applyTime"  id ="applyTime" value='<fmt:formatDate value="${commonPay.applyTime }" pattern="yyyy-MM-dd" />' readonly>
									</td>
									<td colspan="1"><span>所属月份</span></td>
									<td  colspan="1" style="width: 10%;">
										<input type="text" name="voucherTime"  id ="voucherTime" value='<fmt:formatDate value="${commonPay.voucherTime }" pattern="yyyy-MM" />' readonly>
									</td>
								</tr>
								<tr>
									<td style="width: 8%"><span>日期</span></td>
									<td colspan="2"><span>项目</span></td>
									<td colspan="2"><span>事由</span></td>
									<td style="width: 8%"><span>金额</span></td>
									<td><span>类别</span></td>
								<%--	<td><span>費用性质</span></td>--%>
									<td><span>部门</span></td>
									<td><span>收款单位</span></td>
									<td><span>收款账号</span></td>
									<td><span>操作</span></td>
								</tr>
								<c:if test="${not empty commonPay.id and not empty commonPay.commonPayAttachs}">
									<c:forEach items="${commonPay.commonPayAttachs}" var="commonPayAttach" varStatus="varStatus">
										<tr name="node">
											<input type="hidden"  name="attachId" value="${commonPayAttach.id}">
											<td><input type="text" name="date" class="date" value='<fmt:formatDate value="${commonPayAttach.date}" pattern="yyyy-MM-dd" />' readonly></td>
											<td colspan="2" onclick="openProject(this)">
												<input  name="projectName"  id="projectName" value="${commonPayAttach.projectManage.name}"  style="width: 100%;border: none;text-align: center;" readonly>
												<input type="hidden" name="projectManageId" value="${commonPayAttach.projectManageId}">
											</td>
											<td colspan="2"><textarea name="reason" class="input"  >${commonPayAttach.reason}</textarea></td>
											<td><input class="moneyFormat" type="text" name="money" onkeyup="inittotal()" style="text-align:right;" value="<fmt:formatNumber value="${commonPayAttach.money }" pattern="0.00"/>"></td>
											<td><select name="type" style="width: 100%;height: 100%;"><custom:dictSelect type="通用报销类型" selectedValue="${commonPayAttach.type}"/></select></td>
										<%--	<td><select name="costProperty" style="width: 100%;height: 100%;"><custom:dictSelect type="付款类型" selectedValue="${commonPayAttach.costProperty}"/></select></td>--%>
											<td>
												<input type="text"  name="deptsName" value="${commonPayAttach.dept.name }" onclick="openDept(this)" readonly/>
												<input type="hidden" name="deptsId"  value="${commonPayAttach.deptId }">
											</td>
											<td><input type="text" name="receivedCompany" value="${commonPayAttach.receivedCompany}"></td>
											<td><input type="text" name="receivedAccount" value="${commonPayAttach.receivedAccount}"></td>
											<td>
													<a href="javascript:void(0);" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png"></a></a>
													<a href="javascript:void(0);" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
											</td>
										</tr>
									</c:forEach>
								</c:if>
								<c:if test="${empty commonPay.id}">
									<c:forEach begin="1" end="1" var="index">
										<tr name="node">
											<input type="hidden"  name="attachId" value="">
											<td><input type="text" name="date" class="date" value='' style="width: 100%;" readonly></td>
											<td colspan="2" onclick="openProject(this)">
												<input  name="projectName"  id="projectName" value=""  style="width: 100%;border: none;text-align: center;" readonly/>
												<input type="hidden" name="projectManageId" value=""/>
											</td>
											<td colspan="2"><textarea name="reason" class="input" style="vertical-align: middle;" ></textarea></td>
											<td><input type="text" name="money" onkeyup="inittotal()" style="text-align:right;" value="<fmt:formatNumber value="" pattern="0.00" />"></td>
											<td><select name="type" style="width: 100%;height: 100%;"><custom:dictSelect type="通用报销类型" selectedValue=""/></select></td>
										<%--	<td><select name="costProperty" style="width: 100%;height: 100%;"><custom:dictSelect type="付款类型" selectedValue=""/></select></td>--%>
											<td>
												<input type="text"  name="deptsName" value="" onclick="openDept(this)" readonly/>
												<input type="hidden" name="deptsId"  value="">
											</td>
											<td><input type="text" name="receivedCompany" value=""/></td>
											<td><input type="text" name="receivedAccount" value=""/></td>
											<td>
													<a href="javascript:void(0);" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png"></a></a>
													<a href="javascript:void(0);" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
											</td>
										</tr>
									</c:forEach>
								</c:if>
<%-- 								<c:if test="${not empty commonPay.id and not empty commonPay.commonPayAttachs}"> --%>
								<tr>
									<td><span>合计</span></td>
									<td colspan="11"  id="total" style="text-align:left;">
									</td>
								</tr>
<%-- 								</c:if> --%>
								<tr>
									<td><span>备注</span></td>
									<td colspan="11"><textarea id="remark" name="remark" rows="2" style="width: 100%;">${commonPay.remark}</textarea></td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="9" style="border-right-style:hidden;">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${commonPay.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${commonPay.attachName }" style="text-align: left;" readonly>
											</a>
										<td colspan="5">
											<input type="file" id="file" name="file" style="display: none;">
											<c:if test="${not empty commonPay.attachments }">
												<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${commonPay.attachments }">删除</a>
											</c:if>
											<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;"> 
										</td>
									</td>
								</tr>
				
							</tbody>
						</table>
						<div style="width: 100%; text-align: center;margin-top: 10px" class="form-group">
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
							<c:if test="${not empty commonPay.id }">
							<button type="button" class="btn btn-warning" onclick="del(${commonPay.id})" >删除</button>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="deptDialog"></div>
<select id="type_hidden" style="display:none;">
	<custom:dictSelect type="通用报销类型"/>
</select>
<select id="costType_hidden" style="display:none;">
	<custom:dictSelect type="付款类型"/>
</select>
<div id="projectDialog"></div>
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
<script type="text/javascript" src="<%=base%>/views/manage/finance/commonPay/js/addOrEdit.js"></script>
</body>
</html>