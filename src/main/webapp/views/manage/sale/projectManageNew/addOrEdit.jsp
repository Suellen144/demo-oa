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
		#table2 td {
			border: solid #999 1px;
			padding: 5px;
		}
		#table1 thead th {
			border: none;
		}
		#table2 thead th {
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
		#table2 td input[type="text"] {
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
		#table2 td span {
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
		#table2 th {
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
			<li class="active">项目管理</li>
			<li class="active">添加项目立项申请表</li>
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
						<input type="hidden" id="id" name="id" value="${saleProjectManage.id}">
						<input type="hidden" id="issubmit" name="issubmit" value="">
						<input type="hidden" id="applicationType" name="applicationType" value="1">
						<input type="hidden" id="isNewProject" name="isNewProject" value="1">
						<input type="hidden" id="operStatus" value="">
						<input type="hidden" id="currStatus" name="currStatus" value="${saleProjectManage.statusNew }">
						<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						<input type="hidden" id="attachments" name="attachments" value="${saleProjectManage.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${saleProjectManage.attachName}">
						<table id="table1">
							<thead>
								<tr><th colspan="13">立项申请</th></tr>
							</thead>
							<tbody>
								<%--<tr><td colspan="13">项目基本信息</td></tr>--%>
							<%--	<tr>
									<td width="10%"><span>单位</span></td>
									<td style="line-height:inherit;text-align:left;">
										<c:if test="${saleProjectManage.deptA.name ne '东北办事处' and saleProjectManage.deptA.name ne '沈阳办事处'}">
											<select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" selectedValue="${saleProjectManage.title }"/></select>
											<c:if test="${saleProjectManage.deptA.name ne '总经理'}">
												<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${saleProjectManage.deptA.name}" readonly>
												<input type="hidden" name="applyDeptId" value="${saleProjectManage.deptA.id}">
											</c:if>
										</c:if>
										<c:if test="${saleProjectManage.deptA.name eq '东北办事处' or saleProjectManage.deptA.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
											<input  type="text"  style="height:20px;width:auto;text-align:left;" value="${saleProjectManage.deptA.name }" readonly>
										</c:if>
									</td>
									<td style="width: 8%"><span>申请人</span></td>
									<td>
										<input id="applicant" name="applicant" type="text" style="display:none;" value="${saleProjectManage.applicantP.id}">
										<input type="text" id="" value="${saleProjectManage.applicantP.name}" readonly>
									</td>
									<td><span>提交时间</span></td>
									<td colspan="7" style="width: 25%"><input type="text" id="submitDate" name="submitDate" value="<fmt:formatDate value="${saleProjectManage.submitDate}" pattern="yyyy-MM-dd" />" readonly></td>
								</tr>--%>
								<tr>
									<td><span>项目名称</span></td>
									<td><input type="text" id ="name" name="name" value="${saleProjectManage.name}" autocomplete='off'></td>
									<td><span>规模(元)</span></td>
									<td><input type="text" name="size" id="size" value="<fmt:formatNumber value='${saleProjectManage.size}' pattern='0.00' />" autocomplete='off' onkeyup="fun(this.value)"></td>
									<td><span>立项时间</span></td>
									<td colspan="7"><input id="projectDate" name="projectDate" size="18" class="projectDate" value="<fmt:formatDate value="${saleProjectManage.projectDate}" pattern="yyyy-MM-dd" />" style="width:100%;border:0; text-align: center;" autocomplete='off' readonly></td>
								</tr>
								<tr>
									<td><span>负责人</span></td>
									<td onclick="openDialog(this)">
										<input id="userId" name="userId" type="text" value="${saleProjectManage.principal.id}" style="display:none;">
										<input type="text" id="userName" name="userName" value="${saleProjectManage.principal.name}"  autocomplete='off' readonly>
									</td>
									<td><span>负责部门</span></td>
									<td>
										<input id="dutyDeptId" name="dutyDeptId" type="text" value="${saleProjectManage.deptD.id}" style="display:none;">
										<%--<input id="dutyDept" name="dutyDept" type="text" value="${saleProjectManage.deptD.id}" style="display:none;">--%>
										<input type="text" name="deptName" id="deptName" value="${saleProjectManage.deptD.name}" autocomplete='off' readonly>
									</td>
									<td><span>申请人</span></td>
									<td colspan="7">
										<input id="applicant" name="applicant" type="text" style="display:none;" value="${saleProjectManage.applicantP.id}">
										<input type="text" id="" value="${saleProjectManage.applicantP.name}" readonly>
									</td>
								</tr>
                                <tr>
                                    <td><span>立项原因</span></td>
                                    <td colspan="10"><textarea id="reason" name="reason" placeholder="立项原因" rows="3" cols="30">${saleProjectManage.reason}</textarea></td>
                                </tr>
								<tr>
									<td><span>项目说明</span></td>
									<td colspan="10"><textarea id="describe" name="describe" placeholder="项目说明" rows="3" cols="30">${saleProjectManage.describe}</textarea></td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="6" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${saleProjectManage.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${saleProjectManage.attachName }" style="text-align: left;" readonly>
										</a>
									<td colspan="3">
										<input type="file" id="file" name="file" style="display: none;">
										<c:if test="${not empty saleProjectManage.attachments }">
											<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${saleProjectManage.attachments }">删除</a>
										</c:if>
										<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;">
									</td>
									</td>
								</tr>
							</tbody>
						</table>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">项目成员</span>
						</div>
						<table id="table2" style="text-align: center;width:90%;">
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
						<div style="width: 100%; text-align: center;margin-top: 10px" class="form-group">
							<button type="button" class="btn btn-primary" onclick="save()">保存</button>
							<button type="button" class="btn btn-primary" onclick="submitInfo()">提交</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="userByDeptDialog"></div>
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
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sale/projectManageNew/js/addOrEdit.js"></script>
</body>
</html>