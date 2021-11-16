<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<style>
table {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
}
td {
	border: solid #999 1px;
	padding: 0px;
	font-size: 0.6em;
	text-align: center;
}
td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
	padding: 0px 1em;
}
td input[type="radio"] {
	margin-left: 0.5em;
	vertical-align: middle;
}
td label {
	font-weight: normal;
}
td p {
	padding: 5px 1em;
	margin: 0px;
}
th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}

input {

	width:38%; 
	height: 34px;
	background-color: #fff;
	text-align:left;
	vertical-align:middle;
	border:1px solid #ccc; 
	outline: medium;
	padding: 6px 12px;
}

.connectedSortable {
	padding-right: 0px;
}

div#rMenu {position:absolute; visibility:hidden; top:0;text-align: left;padding: 2px;}
div#rMenu ul{position: relative;
			z-index: 1}

div#rMenu ul li{
	margin: 1px 0;
	padding: 3px 30px;
	cursor: pointer;
	list-style: none;
}
</style>
<body>
<header>
	<ol class="breadcrumb">
		<li>主页</li>
		<li class="active">公共信息</li>
		<li>文件管理</li>
	</ol>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<section class="col-md-4 connectedSortable ui-sortable">
				<div class="box box-primary box-solid">
					<div class="box-header with-border">
      					<h3 class="box-title">目录结构</h3>
			    	</div>
					<div class="box-body">
						<div id="Divcloum1" class="col-xs-6">
							<ul id="fileTree" class="ztree"></ul>
						</div>
						<div id="rMenu">
							<ul class="context-menu-list context-menu-root">
								<li id="add_dir" class="context-menu-item context-menu-icon context-menu-icon-add" onclick="addDir();">新增目录</li>
								<li id="del_dir" class="context-menu-item context-menu-icon context-menu-icon-delete" onclick="delDir();">删除目录</li>
								
								<li id="add_file" class="context-menu-item context-menu-icon context-menu-icon-add context-menu-visible" onclick="addFile();">新增文件</li>
								<li id="del_file" class="context-menu-item context-menu-icon context-menu-icon-delete context-menu-visible" onclick="delFile();">删除文件</li>
							</ul>
						</div>
					</div>
				</div>
			</section>
			<section class="col-md-7 connectedSortable ui-sortable">
				<div class="box box-primary box-solid">
					<div class="box-header with-border">
	   					<h3 id="title" class="box-title"></h3>
			    	</div>
					<div class="box-body">
						<!-- 目录表单 -->
						<form id="dirForm" class="form-horizontal tbspace" style="display: none;">
							<input type="hidden" id="dirOper">
							<div class="form-group">
								<label for="name" class="col-md-2 control-label">上级目录</label>
								<div class="col-sm-4">
									<input class="form-control" id="parentDir" readonly>
								</div>
							</div>
							<div class="form-group">
								<label for="name" class="col-md-2 control-label">目录名</label>
								<div class="col-sm-4">
									<input class="form-control" id="name" name="name" placeholder="目录名"  maxlength="20">
								</div>
							</div>
							<div class="form-group">
								<label for="deptId" class="col-md-2 control-label">所属部门</label>
								<div class="col-sm-10">
									
									<input type="button" name="deptName" id="deptName"  onclick="openDept()" readonly>
									<input  type="hidden" name="deptIds" id="deptIds">
									
								</div>
							</div>
							<div class="form-group">
								<label for="name" class="col-md-2 control-label">备注</label>
								<div class="col-sm-8">
									<textarea name="comment" rows="3" style="width:100%; resize:none;" placeholder="目录备注"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="name" class="col-md-2 control-label"></label>
								<div class="col-sm-8">
									<button type="submit" class="btn btn-primary">保存</button>
								</div>
							</div>
						</form>
						
						<!-- 文件表单 -->
						<form id="fileForm" class="form-horizontal tbspace" style="display: none;">
							<input type="hidden" id="fileOper">
							<input type="hidden" name="name">
							<input type="hidden" name="originName">
							<input type="hidden" name="filePath">
							<select id="type_hidden" style="display:none;"><custom:dictSelect type="文件类型"/></select>
							
							<div class="form-group">
								<label for="name" class="col-md-2 control-label" >文件目录</label>
								<div class="col-sm-4">
									<input type="button" class="form-control" id="fileDir"  readonly>
								</div>
							</div>
							<%-- <div class="form-group">
								<label for="name" class="col-md-2 control-label">文件类型</label>
								<div class="col-sm-8">
									<select id="type" name="type" class="form-control" style="width:auto;"><custom:dictSelect type="文件类型"/></select>
								</div>
							</div> --%>
							<div class="form-group">
								<label for="name" class="col-md-2 control-label">上传文件</label>
								<div class="col-sm-10">
									<input type="text" id="showName" name="showName"  readonly>
									<input class="form-control" type="file" id="file" name="file" style="display:none;">
									<button type="button" class="btn btn-default" value="选择文件" onclick="$('#file').click()">选择</button>
								</div>
							</div>
							<!-- <div class="form-group">
								<label for="name" class="col-md-2 control-label">备注</label>
								<div class="col-sm-8">
									<textarea name="comment" rows="3" style="width:100%; resize:none;" placeholder="文件备注"></textarea>
								</div>
							</div> -->
							<div class="form-group">
								<label for="name" class="col-md-2 control-label"></label>
								<div class="col-sm-8">
									<button type="submit" class="btn btn-primary">保存</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</section>
		</div>
	</section>
</div>

<div id="deptDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.core.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>


<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/filemanage/js/addOrEdit.js"></script>
</body>
</html>