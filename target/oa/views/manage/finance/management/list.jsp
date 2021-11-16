<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">财务管理</li>
		<li class="active">报销管理</li>
	</ol>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
							<form id="searchForm" class="form-inline" role="form">
							<div class="form-group">
								<td><label for="fuzzyContent" class="control-label">搜索内容</label></td>
								<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配"></td>
							</div>
							<div class="form-group">
								<label for="status" class="control-label">审批环节</label>
								<select id="status" name="status" class="form-control">
									<option value=" "></option>
									<option value="1">部门经理审批</option>
									<option value="13">总经理助理审批</option>
									<option value="2">经办审批</option>
									<option value="3">复核审批</option>
									<option value="4">总经理审批</option>
									<option value="5">出纳审批</option>
									<option value="6">审批完结</option>
								</select>
							</div>
							<td><label for="roleName_duplicate" class="control-label">发起时间</label></td>
							<div  class="form-group">
									<input class="form-control" id="beginDate" name="beginDate" placeholder="开始时间" style="background-color: inherit;" readonly>
										<span>到</span>
									<input class="form-control" id="endDate" name="endDate" placeholder="结束时间" style="background-color: inherit;" readonly>
							</div>
							<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
							<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
							</form>
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
									<th>报销金额</th>
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
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/management/js/list.js"></script>
<script>
var userId = ${sessionScope.user.id};
</script>
</body>
</html>