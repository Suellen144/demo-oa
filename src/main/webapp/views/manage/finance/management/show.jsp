<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">财务管理</li>
		<li class="active">报销申请</li>
	</ol>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
							<button type="button" class="btn btn-primary" onclick="toAdd()" style="float:left;">报销申请</button>
							<div>
							<form id="searchForm" class="form-inline" role="form">
							<!-- <div class="form-group">
								<input class="form-control" id="name" name="name" placeholder="报销人" style="float:right;width:65%;">
								<label for="name" class="col-sm-4 control-label" style="float:right;line-height:2.5em;">报销人</label>
							</div>  -->
							<div class="form-group" style="width:17%;">
								<label for="orderNo" class="col-sm-4 control-label" style="float:left;line-height:2.5em;white-space: nowrap;">报销单号</label>
								<input class="form-control" id="orderNo" name="orderNo" placeholder="报销单号" style="float:left;width:65%;">
							</div>	
							<!-- <div class="form-group">
								<label for="kind" class="control-label">报销类别</label>
								<select id="kind" name="kind" class="form-control">
									<option value=" "></option>
									<option value="1">差旅报销</option>
									<option value="2">通用报销</option>
								</select>
							</div> -->
							<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
							<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
							</form>
							</div>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>报销类型</th>
									<th>报销人</th>
									<th>发起时间</th>
									<th>报销单号</th>
									<th>当前环节</th>
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

<!-- 模态框（Modal） -->
<div class="modal fade" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">
               	流程图
            </h4>
         </div>
         <div class="modal-body">
         	   <div id="imgcontainer"></div>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
         </div>
      </div><!-- /.modal-content -->
</div><!-- /.modal -->
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/management/js/show.js"></script>
</body>
</html>