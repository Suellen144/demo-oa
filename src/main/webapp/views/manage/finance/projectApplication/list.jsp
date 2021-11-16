<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
	<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">财务管理</li>
		<li class="active">项目管理</li>
	</ol>
	
	<style>
		.blackColor{
			color: #000000;
		}
	</style>
</header>

<!-- <div class="wrapper"> -->
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
						<form id="searchForm" class="form-inline" role="form">
							<table id="searchTable">
								<tr>
								<td><button type="button" class="btn btn-primary" onclick="toAdd()" style="margin-right:10px;" >新增项目</button></td>
								<!-- <td><button type="button" class="btn btn-primary" onclick="toAddOrEdit1('1')" style="margin-right:10px;" >新增合同</button></td> -->
								<td><label for="type_duplicate" class="control-label" style="line-height:2.5em;">申请类型</label></td>
								<td><select id="applicationType" name="applicationType" class="form-control" style="margin-left: 8px">
									<option value=" " selected="selected"></option>
									<option value="1" >新增申请</option>
									<option value="0" >变更申请</option>
								</select></td>
								<td><label for="fuzzyContent" class="control-label" style="margin-left: 10px">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配" style="margin-left: 4px"></td>
								<td><label for="roleName_duplicate" class="control-label" style="margin-left: 8px">申请时间</label></td>
								<td>
										<input class="form-control" id="startTime" name="startTime" placeholder="开始时间" style="background-color: inherit;margin-left: 8px"" readonly>
											<span style="margin-left: 4px">到</span>
										<input class="form-control" id="endTime" name="endTime" placeholder="结束时间" style="background-color: inherit;margin-left: 4px"" readonly>
								</td>
								<td><button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button></td>
								<td><button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button></td>
								<td><span style="display: inline-block;width:58px;height: 36.67px;margin-left: 8px" title="导出Excel" class="btn btn-primary  fa fa-x fa-cloud-download" onclick="exportExcel()" ></span></td>
							</tr>
						</table>
						</form> 	
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>名称</th>
									<th>负责人</th>
									<th style="min-width:60px">规模</th>
									<th style="min-width:45px">申请人</th>
									<th style="min-width:45px">申请时间</th>
									<th style="min-width:60px">申请类型</th>
									<th style="min-width:60px">当前环节</th>
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
<!-- </div> -->
<iframe id="excelDownload" style="display:none;"></iframe>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/projectApplication/js/list.js"></script>
</body>
</html>