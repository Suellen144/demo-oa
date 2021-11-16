<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">

<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">系统管理</li>
		<li class="active">流程管理</li>
		<li class="active">流程定义和部署</li>
	</ol>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
						<!-- 搜索条件 -->
						<form id="searchForm" class="form-inline" role="form">
						<div class="input-group">
							<div class="form-group col-sm-6">
								<label for="key_duplicate" class="control-label" style="float:left;line-height:2.5em;padding:0px 13px;">Key</label>
								<input class="form-control" id="key_duplicate" name="key_duplicate" placeholder="Key" >
								<input type="hidden" id="key" name="key" value="" />
							</div>
							<div class="form-group col-sm-6">
								<label for="name_duplicate" class="control-label" style="float:left;line-height:2.5em;padding:0px 13px;">名称</label>
								<input class="form-control" id="name_duplicate" name="name_duplicate" placeholder="名称" >
								<input type="hidden" id="name" name="name" value="" />
							</div>
							<br/>
							<div class="form-group col-sm-6">
								<label for="version_duplicate" class="control-label" style="float:left;line-height:2.5em;padding:0px 13px;">版本</label>
								<input class="form-control" id="version_duplicate" name="version_duplicate" placeholder="版本" data-inputmask="'mask':'9{+}'">
								<input type="hidden" id="version" name="version" value="" />
							</div>
							<div class="form-group col-sm-8">
								<label for="status" class="control-label" style="float:left;line-height:2.5em;padding:0px 13px;">状态</label>
								<select id="status" name="status" class="form-control">
									<option value="">全部</option>
									<option value="1">激活</option>
									<option value="0">挂起</option>
								</select>
								<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
								<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
							</div>
						</div>
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>流程定义ID</th>
									<th>部署ID</th>
									<th>名称</th>
									<th>KEY</th>
									<th>版本号</th>
									<th>部署时间</th>
									<th>挂起状态</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
					<!-- /.box-body -->
				</div>
				<!-- /.box -->
			</div>
		</div>
	</section>
</div>

<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/workflow/processDefinition/js/list.js"></script>
</body>
</html>