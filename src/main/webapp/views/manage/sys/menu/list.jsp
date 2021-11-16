<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.css" />
<link rel="stylesheet" href="<%=base%>/static/treeTable/css/jquery.treetable.theme.default.css" />

<style>
td,th{border:1px solid;}
th {background-color: #3c8dbc;color: #fff; border: 1px solid #1E71A0 !important;}
td {border-color:#ddd;line-height:1.5em;}
</style>
</head>
<body>
	<header>
	 	<ol class="breadcrumb">
	       <li class="active">主页</li>
	       <li class="active">菜单设置</li>
	    </ol>
	</header>
	
	<div class="col-xs-12">
		<table id="treetable" style="width:100%;">
			<thead>
				<tr>
					<th>菜单名</th>
					<th>URL</th>
					<th style="text-align:center;">排序</th>
					<th>状态</th>
					<th>权限</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
	
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/treeTable/jquery.treetable.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/menu/js/list.js"></script>
<script>
var canAdd = '<shiro:hasPermission name="sys:menu:add">true</shiro:hasPermission>';
var canEdit = '<shiro:hasPermission name="sys:menu:edit">true</shiro:hasPermission>';
var canDel = '<shiro:hasPermission name="sys:menu:del">true</shiro:hasPermission>';
</script>
</body>
</html>