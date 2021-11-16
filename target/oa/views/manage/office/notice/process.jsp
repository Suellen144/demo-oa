<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="com.reyzar.oa.domain.OffNotice" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
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

.td_weight {
	font-weight: bold;
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
			<li class="active">信息审批</li>
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
						<input type="hidden" id="id" name="id" value="${map.business.id }">
						<input type="hidden" name="deptIds" id="deptIds" value="${map.business.deptIds }">
						<input type="hidden" id="approveStatus">
						<input type="hidden" id="approverId" name="approverId" value="${sessionScope.user.id }">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments }">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName }">
						
						<input type="hidden" id="taskId" value="${map.task.id }">
						
						<table>
							<tbody>
								<tr>
									<td><span>标题</span></td>
									<td colspan="20"><input type="text" name="title" id="title" class="form-control" value="${map.business.title }"></td>
								</tr>
								<tr>
									<td style="width:4%"><span>类型</span></td>
									<td style="width:10%">
										<input type="text" style="padding:0.7em 1em;" value="<custom:getDictKey type="公告类型" value="${map.business.type }"/>" readonly>
										<input id="type" name="type" type="hidden" value="${map.business.type }">
									</td>
									<td style="width:4%"><span>发布部门</span></td>
									<td style="width:10%">
										<input type="hidden" id="publisherId" name="publisherId" value="${map.business.publishers.id }" >
										<c:choose>
											<c:when test="${not empty map.business.publishers.alias }">
												<input type="text" id="publishersName" name="publishersName" onclick="openDept2()" value="${map.business.publishers.alias }" originName="${map.business.publishers.name }" readonly>
											</c:when>
											<c:otherwise>
												<input type="text" id="publishersName" name="publishersName" onclick="openDept2()" value="${map.business.publishers.name }" originName="${map.business.publishers.name }" readonly>
											</c:otherwise>
										</c:choose>
									</td>
									<td style="width:4%"><span>发布时间</span></td>
									<td style="width:10%">
										<input type="text" id="publishTime" name="publishTime" value="<fmt:formatDate value="${map.business.publishTime}" pattern="yyyy-MM-dd HH:mm" />" readonly >
									</td>
								</tr>
								<tr>
									<td style="width:4%"><span>抄送</span></td>
									<td colspan="20">
										<input type="text" id="deptName" name="deptName" onclick="openDept()" value="${deptName }" readonly>
									</td>
								</tr>
								<tr>
									<input type="hidden" name="content" id="content" >
									<td colspan="20"><textarea id="contentCK" name="contentCK" rows="7" cols="70" >${map.business.content }</textarea></td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
									<td><span>附件</span></td>
									<td colspan="20">
										<input type="file" id="file" name="file" style="width:20%;float:left;display:none;">
										<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float:right;margin-top:4px;" href="javascript:;">
										<c:if test="${not empty map.business.attachments }">
											<a href="<%=base %>${map.business.attachments }" target="_blank"><input type="text" id="showName" name="showName" value="${map.business.attachName }" style="width:80%;" readonly></a>
										</c:if>
										<c:if test="${empty map.business.attachments }">
											<a href="javascript:void(0);"><input type="text" id="showName" name="showName" value="${map.business.attachName }" style="width:80%;" readonly></a>
										</c:if>
									</td>
								</tr>
								<tr>
									<td><span>审批意见</span></td>
									<td colspan="20"><textarea id="comment" name="comment" rows="2" style="width:100%;">${map.business.comment}</textarea></td>
								</tr>
							</tfoot>
						</table>
						<div style="width:96%; text-align:center;">
							<button type="button" class="btn btn-primary" onclick="preview()" >预览</button>
							<button type="button" class="btn btn-primary" onclick="save(1)">同意</button>
							<button type="button" class="btn btn-primary" onclick="save(2)">不同意</button>
						<%-- 	<button type="button" class="btn btn-warning" onclick="del(${map.business.processInstanceId })">删除</button> --%>
							<button type="button" class="btn btn-default" onclick="window.history.back(-1);">返回</button>
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
											<td><span></span></td>
											<td colspan="20"><input type="text" id="modal_dept" value="${map.business.user.dept.name }" readonly></td>
										</tr>
										<tr>
											<td><span></span></td>
											<td colspan="20"><input type="text" id="modal_createDate" value="" readonly></td>
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
																<td ><input type="text" id="modal_createBy" value="${map.business.user.name }" readonly></td>
																<td class="text-right"><span>签发人：</span></td>
																<td ><input type="text" value="${sessionScope.user.name }" readonly></td>
															</tr>
															<tr>
																<td class="text-right" style="width:9%;"><span>类型：</span></td>
																<td ><input type="text" id="modal_type" value="" readonly></td>
																<td class="text-right" style="width:11%;"><span>抄送：</span></td>
																<td colspan="20" style="width:70%;"><textarea id="modal_deptName" readonly></textarea></td>
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
var notice = ${map.jsonMap.business};
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

<script type="text/javascript" src="<%=base%>/views/manage/office/notice/js/process.js"></script>
</body>
</html>