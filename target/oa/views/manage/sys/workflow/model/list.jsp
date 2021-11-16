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
		<li class="active">流程模型</li>
	</ol>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
						<button class="btn btn-primary" type="button" data-toggle="modal" data-target="#editorModal">创建流程</button>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>ID</th>
									<th>KEY</th>
									<th>Name</th>
									<th>Version</th>
									<th>创建时间</th>
									<th>更新时间</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${modelList}" var="model" varStatus="status">
									<c:if test="${status.index % 2 == 0 }">
										<tr bgcolor="#EDEDED">
									</c:if>
									<c:if test="${status.index % 2 != 0 }">
										<tr>
									</c:if>
										<td>${model.id }</td>
										<td>${model.key }</td>
										<td>${model.name}</td>
										<td>${model.version}</td>
										<td><fmt:formatDate value="${model.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
										<td><fmt:formatDate value="${model.lastUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
										<td>
											<a href="<%=base%>/processEditor/modeler.html?modelId=${model.id}" target="_blank">编辑</a>
											<a href="javascript:;" onclick="deploy(${model.id})">部署</a>
											导出(<a href="<%=base%>/manage/sys/workflow/model/export/${model.id}/bpmn" target="_blank">BPMN</a>
											|&nbsp;<a href="<%=base%>/manage/sys/workflow/model/export/${model.id}/json" target="_blank">JSON</a>)
					                        <a href="javascript:;" onclick="del(${model.id})">删除</a>
										</td>
									</tr>
								</c:forEach>
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

<!-- Modal -->
<div class="modal fade" id="editorModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-sm-15">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">
               	流程基本信息
            </h4>
         </div>
         <div class="modal-body">
				<form id="form1" class="form-horizontal" action="<%=base%>/manage/sys/workflow/model/create" target="_blank" method="post">
					<div class="form-group">
						<label for="name" class="col-sm-2 control-label">名称</label>
						<div class="col-sm-4">
							<input class="form-control" id="name" name="name" type="text" placeholder="名称" />
						</div>
					</div>
					<div class="form-group">
						<label for="key" class="col-sm-2 control-label">KEY</label>
						<div class="col-sm-4">
							<input class="form-control" id="key" name="key" type="text" placeholder="KEY" />
						</div>
					</div>
					<div class="form-group">
						<label for="description" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-6">
							<textarea id="description" name="description" class="form-control" rows="3"></textarea>
						</div>
					</div>
		   		 </form>
         </div>
         <div class="modal-footer">
         	<button type="button" class="btn btn-primary" onclick="create()">确认</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div>
	</div>
</div>

<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/workflow/model/js/list.js"></script>
</body>
</html>