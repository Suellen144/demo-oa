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
			<li class="active">用户管理</li>
			<li class="active">
				<c:if test="${not empty user.id }">编辑</c:if>
				<c:if test="${empty user.id }">新增</c:if>
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
						<h3 class="box-title">用户设置</h3>
					</div>
					<!-- /.box-header -->
					<form id="form1" class="form-horizontal tbspace" action="save" method="post">
						<input type="hidden" id="id" name="id" value="${user.id}">
						<div class="form-group">
							<label for="account" class="col-sm-1 control-label">帐号</label>
							<div class="col-sm-4">
								<input type="text" name="account" style="display: none">
								<input class="form-control" id="account" name="account" placeholder="帐号" value="${user.account}" autocomplete="off">
							</div>
						</div>
						<c:if test="${empty user.id }">
						<div class="form-group">
							<label for="password" class="col-sm-1 control-label">密码</label>
							<div class="col-sm-4">
								<input type="text" style="display: none">
								<input class="form-control" type="password" id="password" name="password" placeholder="密码" value="" readonly autocomplete="off">
								<div style="color:red;">（初始密码为八位随机数,通过邮件发送至该用户邮箱，请及时修改新密码！）</div>
							</div>
						</div>
						</c:if>
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">姓名</label>
							<div class="col-sm-4">
								<input class="form-control" id="name" name="name" placeholder="姓名" value="${user.name}">
							</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">所属单位</label>
							<div class="col-sm-4">
								<label id="deptName" class="control-label">${user.dept.name }</label>
								<input type="hidden" name="deptId" id="deptId" value="${user.deptId}">
								<button type="button" class="btn btn-default" onclick="openDept()">选择</button>
							</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">所处职位</label>
							<div class="col-sm-4">
								<label id="positionName" class="control-label"></label>
								<input type="hidden" name="positionId" id="positionId" value="">
								<button type="button" class="btn btn-default" onclick="openPosition()">选择</button>
							</div>
						</div>
						<div class="form-group">
							<label for="userId" class="col-sm-1 control-label">负责人</label>
							<div class="col-sm-4">
								<input id="principalName" name="principalName" value="${user.principalName}"
									   style="border-style:none;width: 50px" readonly>
								<input type="hidden" name="principalId" id="principalId" value="${user.principalId}">
								<button type="button" class="btn btn-default" onclick="openDialog(this)">选择</button>
							</div>
						</div>
						<div class="form-group"> 
							<h3 class="col-sm-2" style="margin-left:15px;">角色</h3>
						</div>
						<div class="form-group col-sm-7" id="roles" style="margin-left:15px;">
							<c:forEach items="${roleList}" var="role">
								<label class="col-sm-3 control-label" style="text-align:left;">
									<input type="checkbox" style="vertical-align:middle; margin-top:0;" name="roleidList[]" value="${role.id}"> ${role.name}
								</label>
							</c:forEach>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<button type="submit" class="btn btn-primary">提交</button>
								<!-- <button type="button" class="btn btn-default" onclick="window.location.reload(true);return false;">重置</button> -->
								<button type="button" id="backBtn" class="btn btn-default" onclick="javascript:window.history.back(-1);">返回</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="deptDialog"></div>
<div id="positionDialog"></div>
<div id="userByDeptDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script>
	var user = ${userJson};
</script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/user/js/addOrEdit.js"></script>
</body>
</html>