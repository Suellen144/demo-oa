<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.css" />
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css" />
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
<style>
/* body{overflow-y:hidden;} */
td,th{border:1px solid;}
th {background-color: #3c8dbc;color: #fff;}
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">角色设置</li>
			<li class="active">授权</li>
		</ol>
	</header>
	
	<div class="row">
		<section class="col-md-12 connectedSortable ui-sortable">	
			<table id="treetable" style="width:100%;">
				<thead>
					<tr>
						<th style="width:30%;">菜单名</th>
						<th>权限标识</th>
						<th>数据权限</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</section>
	</div>
	
	<div style="text-align: center;">
		<button class="btn btn-primary" id="authBtn" onclick="doAuthority()">授权</button>
		<button class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
	</div>
</div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="authorityModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">数据授权</h4>
         </div>
         <div class="modal-body">
         	<div class="box box-primary box-solid">
				<div class="box-header with-border" style="padding: 0px;">
	    			<h3 class="box-title" style="font-size:0.9em; padding: 0.3em 1em 0.1em; line-height: 1.9;">数据权限</h3>
	    			<input type="hidden" id="menuId" value="">
		    	</div>
				<div class="box-body" style="min-height: 200px;">
					<div id="dept_div" class="col-md-6">
						<ul id="deptTree" class="ztree"></ul>
					</div>
				</div>
		 	</div>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-primary"data-dismiss="modal" onclick="setDataPermission()">确认</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div><!-- /.modal-content -->
</div><!-- /.modal -->

<%@ include file="../../common/footer.jsp"%>
<script>
	var role = ${role};
	var permissMap = ${permissMap};
	var dataPermissionList = ${dataPermissionList};
	var dpModule = ${dpModule};
</script>
<script type="text/javascript" src="<%=base%>/static/treeTable/jquery.treetable.js"></script>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/role/js/authority.js"></script>
</body>
</html>