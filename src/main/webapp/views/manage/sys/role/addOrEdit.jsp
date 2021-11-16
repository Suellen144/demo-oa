<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">角色设置</li>
			<li class="active">
				<c:if test="${not empty role.id }">编辑</c:if>
				<c:if test="${empty role.id }">新增</c:if>
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
						<h3 class="box-title">角色设置</h3>
					</div>
					<!-- /.box-header -->
					<form id="form1" class="form-horizontal tbspace" action="save" method="post">
						<input type="hidden" id="id" name="id" value="${role.id}">
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">角色名</label>
							<div class="col-sm-4">
								<input class="form-control" id="name" name="name" value="${role.name}"  placeholder="角色名">
							</div>
						</div>
						<div class="form-group">
							<label for="enname" class="col-sm-1 control-label">角色英文名</label>
							<div class="col-sm-4">
								<input class="form-control" id="enname" name="enname" placeholder="角色英文名" value="${role.enname}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-1 control-label">状态</label>
							<div class="col-sm-4">
								<c:if test="${empty role.enabled or role.enabled == 1 }">
									<label for="enabled1">
										<input type="radio" id="enabled1" name="enabled" value="1" checked> 启用
									</label>
									<label for="enabled2">
										<input type="radio" id="enabled2" name="enabled" value="0"> 禁用
									</label>
								</c:if>
								<c:if test="${role.enabled == 0 }">
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
							<div class="col-sm-offset-2 col-sm-10">
								<button type="submit" class="btn btn-primary">提交</button>
								<!-- <button type="reset" class="btn btn-default">重置</button> -->
								<button type="button" id="backBtn" class="btn btn-default" onclick="goBack()">返回</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/role/js/addOrEdit.js"></script>
</body>
</html>