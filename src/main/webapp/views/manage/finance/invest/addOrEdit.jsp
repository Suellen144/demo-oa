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
			<li class="active">财务管理</li>
			<li class="active">费用归属管理</li>
			<li class="active">
				<c:if test="${not empty invest.id }">编辑</c:if>
				<c:if test="${empty invest.id }">新增</c:if>
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
						<h3 class="box-title">费用归属管理</h3>
					</div>
					<!-- /.box-header -->
					<form id="form1" class="form-horizontal tbspace" method="post">
						<input type="hidden" id="id" name="id" value="${invest.id}">
						<div class="form-group">
							<label for="parentName" class="col-sm-1 control-label">费用归属</label>
							<div class="col-sm-4">
								<input class="form-control" id="value" name="value" value="${invest.value}">
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<button type="submit" class="btn btn-primary">提交</button>
								<!-- <button type="reset" class="btn btn-default">重置</button> -->
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
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/finance/invest/js/addOrEdit.js"></script>
</body>
</html>