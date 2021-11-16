<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/fileupload/css/jquery.fileupload-ui.css">
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
						<input type="hidden" id="id" name="id" value="${notice.id }">
						<input type="hidden" id="approveStatus" name="approveStatus" value="${notice.approveStatus }">
					<%-- 	<textarea id="comment" name="comment" rows="2" style="width:100%;display:none;">${notice.comment}</textarea> --%>
						<table>
							<tbody>
								<tr>
									<td><span>标题</span></td>
									<td colspan="20"><input type="text" name="title" id="title" class="form-control" value="${notice.title }"></td>
								</tr>
								<tr>
									<td style="width:4%"><span>类型</span></td>
									<td style="width:5%">
										<c:choose>
											<c:when test="${not empty notice.approveStatus and (notice.approveStatus eq '2' or notice.approveStatus eq '0')}">
												<input type="text" style="padding:0.7em 1em;" value="<custom:getDictKey type="公告类型" value="${notice.type }"/>" readonly>
												<input id="type" name="type" type="hidden" value="${notice.type }">
											</c:when>
											<c:otherwise>
												<select id="type" name="type" class="form-control" onchange="changeType(this)">
							                        <custom:dictSelect type="公告类型" selectedValue="${notice.type }" />
							                     </select>
											</c:otherwise>
										</c:choose>
									</td>
									<td style="width:2%"><span>发布部门</span></td>
									<td style="width:10%">
										<c:if test="${empty notice.id }">
											<input type="hidden" id="publisherId" name="publisherId" value="${sessionScope.user.dept.id }" >
											<c:choose>
												<c:when test="${not empty sessionScope.user.dept.alias }">
													<input type="text" id="publishersName" name="publishersName" onclick="openDept2()" value="${sessionScope.user.dept.alias }" originName="${sessionScope.user.dept.name }" readonly>
												</c:when>
												<c:otherwise>
													<input type="text" id="publishersName" name="publishersName" onclick="openDept2()" value="${sessionScope.user.dept.name }" originName="${sessionScope.user.dept.name }" readonly>
												</c:otherwise>
											</c:choose>
										</c:if>
										<c:if test="${not empty notice.id }">
											<input type="hidden" id="publisherId" name="publisherId" value="${notice.publishers.id }" >
											<c:choose>
												<c:when test="${not empty notice.publishers.alias }">
													<input type="text" id="publishersName" name="publishersName" onclick="openDept2()" value="${notice.publishers.alias }" originName="${notice.publishers.name }" readonly>
												</c:when>
												<c:otherwise>
													<input type="text" id="publishersName" name="publishersName" onclick="openDept2()" value="${notice.publishers.name }" originName="${notice.publishers.name }" readonly>
												</c:otherwise>
											</c:choose>
										</c:if>
									</td>
									<td style="width:4%"><span>发布时间</span></td>
									<td style="width:10%">
										<input type="text" id="publishTime" name="publishTime" value="<fmt:formatDate value="${notice.publishTime}" pattern="yyyy-MM-dd HH:mm" />" readonly >
									</td>
								</tr>
								<tr>
									<td style="width:4%"><span>抄送</span></td>
									<td colspan="20">
										<input type="hidden" name="deptIds" id="deptIds" value="${notice.deptIds }">
										<input type="text" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
									</td>
								</tr>
								<tr>
									<input type="hidden" name="content" id="content" >
									<td colspan="20"><textarea id="contentCK" name="contentCK" rows="7" cols="70" >${notice.content }</textarea></td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
									<td><span>附件</span></td>
									<td colspan="20">
										<input type="hidden" id="attachments" name="attachments" value="${notice.attachments }">
										<input type="hidden" id="attachName" name="attachName" value="${notice.attachName }">
										<input type="file" id="file" name="file" style="width:20%;float:left;display:none;">
										<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;margin-top:4px;" href="javascript:;">
										<c:if test="${not empty notice.attachments }">
											<a href="<%=base %>${notice.attachments }" target="_blank"><input type="text" id="showName" name="showName" value="${notice.attachName }" style="width:80%;" readonly></a>
										</c:if>
										<c:if test="${empty notice.attachments }">
											<a href="javascript:void(0);"><input type="text" id="showName" name="showName" value="${notice.attachName }" style="width:80%;" readonly></a>
										</c:if>
									</td>
								</tr>
								<c:if test="${not empty notice.approveStatus and notice.approveStatus eq '2'}">
								<tr>
									<td><span>审批意见</span></td>
									<td colspan="20"><textarea id="comment" name="comment" rows="2" style="width:100%;" readonly>${notice.comment}</textarea></td>
								</tr>
								</c:if>
							</tfoot>
						</table>
						<div style="width:96%; text-align:center;">
							<button type="button" class="btn btn-primary" onclick="preview()" >预览</button>
							<c:choose>
								<c:when test="${not empty notice.approveStatus and notice.approveStatus eq '0'}">
									<button type="button" class="btn btn-warning" onclick="del(${notice.processInstanceId})" >删除</button>
								</c:when>
							<%-- 	<c:otherwise>
									<button type="button" id="saveBtn" class="btn btn-primary" onclick="save()" >提交审核</button>
								</c:otherwise> --%>
							</c:choose>
							<c:choose>
								<c:when test="${not empty notice.approveStatus and notice.approveStatus eq '2'}">
									<button type="button" class="btn btn-primary" onclick="save()" >重新提交</button>
								</c:when>
								<c:otherwise>
									<button type="button" id="saveBtn" class="btn btn-primary" onclick="save()" >提交审核</button>
								</c:otherwise>
							</c:choose>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="deptDialog"></div>
<div id="deptDialog2"></div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="noticeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%;">
    	<div class="modal-content">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel"></h4>
         	</div>
	        <div class="modal-body" style="overflow:auto; padding-top:0px;">
	        	<div class="row">
					<div class="col-md-12">
						<div class="tbspace" style="padding-top:0px !important;">
							<form id="form1">
								<table id="table1">
									<thead>
										<tr><th colspan="8" id="modal_title" style="padding:0.5em 0px;"></th></tr>
									</thead>
									<tbody>
										<tr><td colspan="8"><div id="modal_content"></div></td></tr>
										<tr>
											<td colspan="20">
												<span>附件：</span>
												<a href="javascript:void(0)"><input type="text" id="modal_attachName" style="width:90%;" value="" readonly></a>
											</td>
										</tr>
										<tr>
											<td></td>
											<td colspan="20"><input type="text" id="modal_dept" readonly></td>
										</tr>
										<tr>
											<td></td>
											<td colspan="20"><input type="text" id="modal_createDate" readonly></td>
										</tr>
										<tr>
											<td colspan="20">
												<div id="details_div" class="box box-primary collapsed-box" style="box-shadow:none;">
										            <div class="box-header with-border">
										              <h3 class="box-title"></h3>
										              <div class="box-tools pull-right">
										                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>
										              </div>
										            </div>
										            <div class="box-body">
								            			<table>
											            	<tr>
																<td class="text-right"><span>拟稿人：</span></td>
																<td ><input type="text" id="modal_createBy" value="${sessionScope.user.name }" readonly></td>
																<td class="text-right"><span id="modal_approver_span">签发人：</span></td>
																<td ><input type="text" value="" readonly></td>
															</tr>
															<tr>
																<td class="text-right" style="width:9%;"><span>类型：</span></td>
																<td ><input type="text" id="modal_type" value="" readonly></td>
																<td class="text-right" style="width:11%;"><span>抄送：</span></td>
																<td colspan="20" style="width:70%;"><textarea rows="" cols="" id="modal_deptName" readonly></textarea></td>
															</tr>
														</table>
										            </div>
									            </div>
											</td>
										</tr>
									</tbody>
								</table>
							</form>
						</div>
					</div>
				</div>
			</div>
	      	<div class="modal-footer"></div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript">
var deptList = JSON.parse('${deptList}');
var deptMap = {};
var parentDeptList = [];
$(deptList).each(function(index, dept) { if(dept.level == 1) {parentDeptList.push(dept);} deptMap[dept.id]=dept; });
var ue="";
$(document).ready(function(){
	window.UEDITOR_HOME_URL ="<%=base%>/static/plugins/ueditor/";
	ue= UE.getEditor('contentCK'); 
})
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
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
<script type="text/javascript" src="<%=base%>/views/manage/office/notice/js/addOrEdit.js"></script>
</body>
</html>