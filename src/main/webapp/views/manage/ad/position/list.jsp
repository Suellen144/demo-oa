<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<style>
table {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
	width: 80%;
}

td {
	border: solid #999 1px;
	padding: 5px 0px;
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
	font-size:small;
	font-weight: bold;
}

th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}

#ul_user li {
	list-style-type: none;
}

#ul_user li:hover {
	cursor: pointer;
	font-weight: bold;
	font-size: 1.2em;
}

.connectedSortable {
	padding-right: 0px;
}

div#rMenu {position:absolute; visibility:hidden; top:0; background-color: #555;text-align: left;padding: 2px;}
div#rMenu ul li{
	margin: 1px 0;
	padding: 0 5px;
	cursor: pointer;
	list-style: none outside none;
	background-color: #DFDFDF;
}
</style>
<body>
</head>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">行政管理</li>
		<li class="active">职位管理</li>
	</ol>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<section class="col-md-9 connectedSortable ui-sortable">
				<div class="box box-primary box-solid">
					<!-- <div class="box-header with-border">
						<h3 class="box-title">组织机构</h3>
					</div> -->
					<div class="box-body">
						<div id="Divcloum1" class="col-xs-6">
							<ul id="deptTree" class="ztree"></ul>
						</div>
					</div>
				</div>
			</section>
		</div>
	</section>
</div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="positionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">职位表单</h4>
         </div>
         <div class="modal-body">
         	<form id="form">
				<input type="hidden" id="id" name="id"> 
				<input type="hidden" id="deptId" name="deptId">
				<table>
					<thead>
						<tr><th colspan="6"><span id="positionName"></span></th></tr>
					</thead>
					<tbody>
						<tr>
							<td><p>中文名&nbsp;</p></td>
							<td>
								<input id="name" name="name" type="text" value=""  class="form-control">
							</td>
						</tr>
						<tr>
							<td><p>英文名&nbsp;</p></td>
							<td>
								<input id="enname" name="enname" type="text" value=""  class="form-control">
							</td>
						</tr>
						<tr>
							<td><p>职位等级&nbsp;</p></td>
							<td>
								<select id="level" name="level" class="form-control" style="border:none;"><custom:dictSelect type="职位等级"/></select>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
         </div>
         <div class="modal-footer">
            <button type="submit" class="btn btn-primary" id="saveBtn" onclick="save()">保存</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div><!-- /.modal-content -->
</div><!-- /.modal -->
</div>

<div id="deptDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.core.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.ui.position.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/position/js/list.js"></script>
</body>
</html>