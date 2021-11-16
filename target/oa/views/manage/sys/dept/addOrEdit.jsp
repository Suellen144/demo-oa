<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/ztree/css/zTreeStyle/zTreeStyle.css">
<style>
.deptContent { display:none; position: absolute; z-index:1; border:1px solid #d2d6de; background-color:white; max-height:300px; overflow-y:auto; }
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">部门设置</li>
			<li class="active">
				<c:if test="${not empty dept.id }">编辑</c:if>
				<c:if test="${empty dept.id }">新增</c:if>
			</li>
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
						<h3 class="box-title">单位属性</h3>
					</div>
					<!-- /.box-header -->
					<form id="form1" class="form-horizontal tbspace" action="save" method="post">
						<input type="hidden" id="id" name="id" value="${dept.id}">
						<div class="form-group">
							<label for="parentName" class="col-sm-1 control-label">上级单位</label>
							<div class="col-sm-4">
								<c:choose>
									<c:when test="${empty dept.id }">
										<input class="form-control" id="parentName" name="parentName" value="${parent.name}" readonly>
									</c:when>
									<c:otherwise>
										<li class="title" style="list-style:none;"><input id="parentSel" type="text" onclick="showDept(this);" class="form-control" readonly value="${parent.name}" style="background-color:inherit;"/></li>
									</c:otherwise>
								</c:choose>
							</div>
							<input type="hidden" name="parentId" id="parentId" value="${parent.id}"> 
							<div id="deptContent" class="deptContent">
								<ul id="deptTree" class="ztree" style="margin-top:0; width:auto;"></ul>
							</div>
						</div>
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">单位名称</label>
							<div class="col-sm-4">
								<input class="form-control" id="name" name="name" placeholder="单位名称" value="${dept.name}">
							</div>
						</div>
						<div class="form-group">
							<label for="alias" class="col-sm-1 control-label">单位简称</label>
							<div class="col-sm-4">
								<input class="form-control" id="alias" name="alias" placeholder="单位简称" value="${dept.alias}">
							</div>
						</div>
						<div class="form-group">
							<label for="alias" class="col-sm-1 control-label">单位属性</label>
							<div class="col-sm-4">
								<select id="level" name="level" class="form-control" style="width:10em;" value="${dept.level }">
									<option value=""></option>
									<option value="1">公司</option>
									<option value="2">部门</option>
									<option value="3">项目组</option>
									<option value="3">办事处</option>
								</select>
							</div>
						</div>
							<input class="form-control" type="hidden" id="code" name="code" placeholder="部门代码" value="${dept.code}">
				<%-- 		<div class="form-group">
							<label for="code" class="col-sm-1 control-label">部门代码</label>
							<div class="col-sm-4">
								<input class="form-control" id="code" name="code" placeholder="部门代码" value="${dept.code}">
							</div>
							<label for="" class="control-label tip-label">*请输入四位数字</label>
						</div> --%>
						<%-- <div class="form-group">
							<label for="sort" class="col-sm-1 control-label">排列序号</label>
							<div class="col-sm-4">
								<input class="form-control" id="sort" name="sort" placeholder="排列序号" value="${dept.sort}">
							</div>
							<label for="" class="control-label tip-label">*请输入最多两位数字</label>
						</div> --%>
						<%-- <div class="form-group">
							<label for="userId" class="col-sm-1 control-label">部门经理</label>
							<div class="col-sm-4">
								<label id="userName" class="control-label">${dept.principal.name }</label>
								<input type="hidden" name="userId" id="userId" value="${dept.userId}">
								<button type="button" class="btn btn-default" onclick="openDialog('user')">选择</button>
								<button type="button" class="btn btn-default" onclick="removePrincipal('user')">删除</button>
							</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">部门副经理</label>
							<div class="col-sm-4">
								<label id="assistantName" class="control-label">${dept.assistant.name }</label>
								<input type="hidden" name="assistantId" id="assistantId" value="${dept.assistantId}">
								<button type="button" class="btn btn-default" onclick="openDialog('assistant')">选择</button>
								<button type="button" class="btn btn-default" onclick="removePrincipal('assistant')">删除</button>
							</div>
						</div> --%>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<button type="submit" class="btn btn-primary">提交</button>
								<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="userDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/ztree/jquery.ztree.core.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/dept/js/addOrEdit.js"></script>
</body>
</html>