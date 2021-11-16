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
			<li class="active">数据字典</li>
			<li class="active">数据设置</li>
			<li class="active">
				<c:if test="${not empty dictData.id }">编辑</c:if>
				<c:if test="${empty dictData.id }">新增</c:if>
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
						<h3 class="box-title">字典数据设置</h3>
					</div>
					<!-- /.box-header -->
										<form id="form1" class="form-horizontal tbspace" action="update" method="post">
						<input type="hidden" id="id" name="id" value="${dictData.id}">
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">数据名</label>
							<div class="col-sm-4">
								<input class="form-control" id="name" name="name" value="${dictData.name}"  placeholder="数据名">
							</div>
						</div>
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">数据值</label>
							<div class="col-sm-4">
								<input class="form-control" id="value" name="value" value="${dictData.value}"  placeholder="数据值">
							</div>
						</div>
						<div class="form-group">
							<label for="name" class="col-sm-1 control-label">备注</label>
							<div class="col-sm-4">
								<input class="form-control" id="remark" name="remark" value="${dictData.remark}"  placeholder="备注">
							</div>
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
<script type="text/javascript" src="<%=base%>/views/manage/sys/dict/js/addOrEdit.js"></script>
</body>
</html>