<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/fileupload/css/jquery.fileupload-ui.css">
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.css" />
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css" />
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
<style>
table {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
	width: 96%;
}
td {
	border: solid #999 1px;
	padding: 0px;
}
td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	padding: 8px 1em;
}
td span {
	padding: 0px 15px;
}
th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
textarea {
	resize: none;
	border: none;
	outline: medium;
}

span.cke_combo_text {
	width: 25px;
}

#table1 {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
	width: 98%;
}
#table1 td {
	padding: 6px 5px;
	border: none;
}
#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}
#table1 td span {
	padding: 0px;
}
#table1 th {
	text-align: center;
	font-size: 1.5em;
	padding-right: 0px;
	border: none;
}

#modal_deptName {
	width: 69%;
	height: 100%;
	overflow: visible;
	position: absolute;
	top: 70%;
}
#modal_dept, #modal_createDate {
	width: auto !important;
	min-width: 18em;
	text-align: center;
	float: right;
}
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">公共信息</li>
			<li class="active">信息发布</li>
			<li class="active">发布信息</li>
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
						<input type="hidden" id="id" name="id" value="${meeting.id }">
						<table>
							<tbody>
								<tr>
									<td><span style="white-space: nowrap;font-weight: bold">主题</span></td>
									<td colspan="20"><input type="text" name="theme" id="theme" class="form-control" value="${meeting.theme }"></td>
								</tr>
								<tr>
									<td style="width:2%"><span style="white-space: nowrap;font-weight: bold">部门</span></td>
									<td style="width:5%">
										<c:if test="${empty meeting.id }">
											<input type="hidden" id="deptId" name="deptId" value="${sessionScope.user.dept.id }">
											<input type="hidden" id="status" name="status" value="">
											<c:choose>
												<c:when test="${not empty sessionScope.user.dept.alias }">
													<input type="text" id="publishersName" name="publishersName" value="" originName="${sessionScope.user.dept.name }" readonly>
												</c:when>
												<c:otherwise>
													<input type="text" id="publishersName" name="publishersName"  value="${sessionScope.user.dept.name }" originName="${sessionScope.user.dept.name }" readonly>
												</c:otherwise>
											</c:choose>
										</c:if>
										
										<c:if test="${not empty meeting.id }">
											<input type="hidden" id="deptId" name="deptId" value="${meeting.deptId}" >
											<input type="hidden" id="status" name="status" value="${meeting.status}">
											<c:choose>
												<c:when test="${not empty meeting.dept.alias }">
													<input type="text" id="publishersName" name="publishersName" value="" originName="" readonly>
												</c:when>
												<c:otherwise>
													<input type="text" id="publishersName" name="publishersName" value="${meeting.applicant.dept.name }" originName="" readonly>
												</c:otherwise>
											</c:choose> 
										</c:if>
									</td>
									<td style="width:1%;white-space:nowrap;font-weight: bold"><span>记录人</span></td>
									<td style="width:2%">
										<c:if test="${empty meeting.id }">
											<input type="hidden" id="userId" name="userId" value="${sessionScope.user.id }" >
											<input type="text" id="userName" name="userName" value="${sessionScope.user.name }" >
										</c:if>
										<c:if test="${not empty meeting.id }">
											<input type="hidden" id="userId" name="userId" value="${meeting.userId}" >
											<input type="text" id="userName" name="userName" value="${meeting.applicant.name}" >
										</c:if>
									</td>
									<td style="width:1%;white-space:nowrap;font-weight: bold"><span>主持人</span></td>
									<td style="width:3%">
											<input type="text" id="presenters" name="presenters" value="${meeting.presenters}" >
									</td>
									<td style="width:4%;white-space:nowrap;"><span style="font-weight: bold">填写时间</span></td>
									<c:if test="${empty meeting.id }">
									<td style="width:10%">
										<input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${currDate}" pattern="yyyy-MM-dd" />" readonly >
									</td>
									</c:if>
									<c:if test="${not empty meeting.id }">
									<td style="width:10%">
										<input type="text" id="applyTime" name="applyTime" value="<fmt:formatDate value="${meeting.applyTime}" pattern="yyyy-MM-dd" />" readonly >
									</td>
									</c:if>
								</tr>
								<tr>
									<td style="width:4%"><span style="white-space: nowrap;font-weight: bold">发送至</span></td>
									<td colspan="20">
										<input type="hidden" name="userids" id="userids" value="${meeting.userids }">
										<input type="text"  id = "usernames" onclick="openuserIds()" readonly>
									</td>
								</tr>
								<tr>
									<td style="width:2%"><span style="white-space: nowrap;font-weight: bold">参与人员</span></td>
									<td colspan="20">
											<input type="text" id="participant" name="participant" value="${meeting.participant}" >
									</td>
								</tr>
								<tr>
									<input type="hidden" name="comment" id="comment" >
									<td colspan="20"><textarea id="contentCK" name="contentCK" rows="7" cols="70" >${meeting.comment}</textarea></td>
								</tr>
							</tbody>
						</table>
						<div style="width:96%; text-align:center;">
							<button type="button" class="btn btn-primary" onclick="save()" >保存</button>
							<c:if test="${meeting.status ne 1}">
							<button type="button" class="btn btn-primary" onclick="submitinfo()" >提交</button>
							</c:if>
							<c:if test="${(not empty meeting.id) && meeting.status ne 1}">
								<button type="button" class="btn btn-warning" onclick="del()" >删除</button>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="deptModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header" style="border-bottom-color:#3c8dbc">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel" style="font-weight: bolder;">参与人员选择</h4>
         </div>
         <div class="modal-body">
				<div class="box-body" style="min-height: 200px;">
					<div id="dept_div" class="col-md-6">
						<ul id="deptUserTree" class="ztree"></ul>
					</div>
				</div>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-primary"data-dismiss="modal" onclick="setDept()">确认</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div><!-- /.modal-content -->
</div><!-- /.modal -->
</div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript">
var userIds = [];
var userId='${meeting.userids}';
userIds.push(userId);
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/treeTable/jquery.treetable.js"></script>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-ui.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<%-- <script type="text/javascript" src="<%=base%>/static/plugins/ckeditor_4.6.1_full/ckeditor.js"></script> --%>
<script type="text/javascript" src="<%=base%>/static/plugins/ueditor/ueditor.config.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/ueditor/ueditor.all.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/ueditor/lang/zh-cn/zh-cn.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/meeting/js/addOrEdit.js"></script>
</body>
<script type="text/javascript">
var ue="";
$(document).ready(function(){
	window.UEDITOR_HOME_URL ="<%=base%>/static/plugins/ueditor/";
	ue= UE.getEditor('contentCK'); 
})
</script>
</html>