<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">考勤管理</li>
			<li class="active">考勤数据</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title" style="font-weight:bold;">Excel上传(默认导入部门Sheet考勤数据，请注意Excel样式)</h3>
					</div>
					
					<div class="box-body">
						<form id="form1" class="form-horizontal tbspace" action="save" method="post">
							<input type="hidden" id="id" name="id" value="${file.id}">
							<input type="hidden" id="filePath" name="filePath" value="${file.filePath}">
							<input type="hidden" id="originName" name="originName" value="${file.originName}">
							<input type="hidden" id="name" name="name" value="${file.name}">
							<div class="form-group">
								<label for="name" class="col-sm-1 control-label">请选择文件</label>
								<div class="col-sm-4">
									<c:if test="${empty file.id }">
										<input type="file" id="file1" name="file1" value="">
									</c:if>
									<input class="form-control" id="showName" name="showName" value="${file.originName}" readonly>
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-offset-2 col-sm-10">
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-offset-2 col-sm-10">
									<button type="button" class="btn btn-primary" onclick="upload()">提交</button>
									<button type="button" id="backBtn" class="btn btn-default" onclick="window.history.back(-1);">返回</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="deptDialog"></div>

<%@ include file="../../../common/footer.jsp"%>
<!-- <script type="text/javascript">
	var deptList = ${deptList};
</script> -->
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/attendance/js/addOrEdit.js"></script>
</body>
</html>