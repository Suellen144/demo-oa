<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/bootstrap/css/font-awesome-dark.min.css">
<link rel="stylesheet" href="<%=base%>/static/bootstrap/css/font-awesome.min.css">
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
<style>
.menuContent { display:none; position: absolute; z-index:1; border:1px solid #d2d6de; background-color:white; max-height:300px; overflow-y:auto; }
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">菜单设置</li>
			<li class="active">
				<c:if test="${not empty menu.id }">编辑</c:if>
				<c:if test="${empty menu.id }">新增</c:if>
			</li>
		</ol>
	</header>
	
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary">
					<div class="box-header with-border">
						<h3 class="box-title">菜单设置</h3>
					</div>
					<!-- /.box-header -->
					<form id="form1" class="form-horizontal tbspace" action="save" method="post">
						<input type="hidden" id="id" name="id" value="${menu.id}">
						<div class="form-group">
							<label for="parentName" class="col-sm-1 control-label">父级菜单</label>
							<div class="col-sm-4">
								<c:choose>
									<c:when test="${empty menu.id }">
										<input class="form-control" id="parentName" name="parentName" value="${parentMenu.name}" readonly>
									</c:when>
									<c:otherwise>
										<li class="title" style="list-style:none;"><input id="parentSel" type="text" onclick="showMenu(this);" class="form-control" readonly value="${parentMenu.name}" style="background-color:inherit;"/></li>
									</c:otherwise>
								</c:choose>
							</div>
							<input type="hidden" name="parentId" id="parentId" value="${parentMenu.id}"> 
							<div id="menuContent" class="menuContent">
								<ul id="menuTree" class="ztree" style="margin-top:0; width:auto;"></ul>
							</div>
						</div>
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">菜单名</label>
							<div class="col-sm-4">
								<input type="name" class="form-control" id="name" name="name" placeholder="菜单名" value="${menu.name}">
							</div>
						</div>
						<div class="form-group">
							<label for="url" class="col-sm-1 control-label">链接</label>
							<div class="col-sm-4">
								<input class="form-control" id="url" name="url" placeholder="链接" value="${menu.url}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-1 control-label">状态</label>
							<div class="col-sm-4">
								<c:if test="${menu.enabled == 1 or empty menu.enabled }">
									<label for="enabled1">
										<input type="radio" id="enabled1" name="enabled" value="1" checked> 启用
									</label>
									<label for="enabled2">
										<input type="radio" id="enabled2" name="enabled" value="0"> 禁用
									</label>
								</c:if>
								<c:if test="${menu.enabled == 0 }">
									<label for="enabled1">
										<input type="radio" id="enabled1" name="enabled" value="1"> 启用
									</label>
									<label for="enabled2">
										<input type="radio" id="enabled2" name="enabled" value="0" checked> 禁用
									</label>
								</c:if>
							</div>
						</div>
						<div class="form-group">
							<input type="hidden" id="icon" name="icon" value="${menu.icon}" />
							<label for="sort" class="col-sm-1 control-label">菜单图标</label>
							<li id="icon_li" class="col-sm-1 ${menu.icon}"></li>
							<button type="button" onclick="openDialog()">选择</button>
						</div>
						<div class="form-group">
							<label for="sort" class="col-sm-1 control-label">排序</label>
							<div class="col-sm-4">
								<input class="form-control" id="sort" name="sort" placeholder="排序" value="${menu.sort}">
							</div>
							<label for="" class="control-label tip-label">*请输入0或正整数</label>
						</div>
						<div class="form-group">
							<label for="permission" class="col-sm-1 control-label">权限</label>
							<div class="col-sm-6">
								<input class="form-control" id="permission" name="permission" placeholder="权限集" value="${menu.permission}">
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<button type="submit" class="btn btn-primary">提交</button>
								<!-- <button type="reset" class="btn btn-default">重置</button> -->
								<button type="button" class="btn btn-default" onclick="goBack()">返回</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="iconDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.core.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/customJQueryValidatorRules.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/menu/js/addOrEdit.js"></script>
</body>
</html>