<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<style>
.name {
	font-size: 1.5em;
	font-weight: bold;
	padding: 10px 0px;
}
.dept {
	background-color: #dcdcdc;
	margin: 0 auto;
	padding: 3px 0px;
}
table {
	table-collapse: collapse;
	border: none;
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
	line-height: 2.4em;
}
td p {
	padding: 0.5em;
	text-align: center;
}
th {
	border: solid #999 1px;
	text-align: left;
	padding: 3px 5px;
}
textarea {
	resize: none;
	border: none;
	outline: medium;
}

</style>
</head>
<body style="background-color:#ecf0f5;">
<div class="wrapper">
	<header>
		<ol class="breadcrumb" style="background-color:#ededed;border-bottom:1px solid #ccc;">
			<li class="active">主页</li>
			<li class="active">修改密码</li>
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
						<h3 class="box-title">修改密码</h3>
					</div>
					<div class="box-body">
						<form id="form1" class="form-horizontal tbspace" method="post">
							<input type="hidden" id="password" name="password" value="${sessionScope.user.password }">
							<input type="hidden" id="account" name="account"value="${sessionScope.user.account }" readonly>
							
							<div class="form-group">
								<label for="password" class="col-sm-1 control-label">原始密码</label>
								<div class="col-sm-4">
									<input class="form-control" type="password" id="origin_pwd" name="origin_pwd" placeholder="原始密码" value="">
									<label id="origin_pwd_error" class="error" style="display:none;">原始密码错误！</label>
								</div>
							</div>
							<div class="form-group">
								<label for="password" class="col-sm-1 control-label">新密码</label>
								<div class="col-sm-4">
									<input class="form-control" type="password" id="new_pwd" name="new_pwd" placeholder="新密码" value="">
								</div>
							</div>
							<div class="form-group">
								<label for="password" class="col-sm-1 control-label">重复密码</label>
								<div class="col-sm-4">
									<input class="form-control" type="password" id="re_pwd" name="re_pwd" placeholder="重复新密码" value="">
									<label id="re_pwd_error" class="error" style="display:none;">重复密码与新密码不一致！</label>
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-offset-2 col-sm-10">
									<button type="submit" class="btn btn-primary">确认</button>
									<button type="reset" class="btn btn-default">重置</button>
									<button type="button" id="backBtn" class="btn btn-default" onclick="javascript:window.history.back();">返回</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sys/user/js/changepwd.js"></script>
</body>
</html>