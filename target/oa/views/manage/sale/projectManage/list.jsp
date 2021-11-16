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
		<li class="active">项目管理</li>
	</ol>
	
	<style>
		.blackColor{
			color: #000000;
		}
	</style>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
						<form id="searchForm" class="form-inline" role="form">
								<button type="button" class="btn btn-primary" onclick="toAddOrEdit('')" style="margin-right:10px;" >新增项目</button>
								
								<label for="name_duplicate"  control-label" style="line-height:2.5em;">项目</label>
								<input class="form-control" id="name_duplicate" name="name_duplicate" placeholder="项目" style="width:10%;">
								<input type="hidden" id="name" name="name" value="" />
							
								<label for="type_duplicate" class="control-label" style="line-height:2.5em;">项目类型</label>
								<input type="hidden" id="type" name="type" value="" />
								<select id="type_duplicate" name="type_duplicate" class="form-control" style="text-align：left" >
									<option></option>
									<custom:dictSelect type="项目类型"/>
								</select>	
								
								<label for="status_duplicate" class="control-label" style="line-height:2.5em;">状态</label>
								<input type="hidden" id="status" name="status" value="" />
								<select id="status_duplicate" name="status_duplicate" class="form-control">
									<option value=" "></option>
									<option value="1" selected="selected">活动</option>
									<option value="0" >关闭</option>
									<!-- <option value="-1">注销</option> -->
								
								</select>
								
							
							<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
							<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
							<span style="display: inline-block;width:58px;height: 36.67px;" title="导出Excel" class="btn btn-primary  fa fa-x fa-cloud-download" onclick="exportExcel()" ></span>
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>项目</th>
									<th>类型</th>
									<!-- <th>项目编码</th> -->
									<!-- <th style="min-width:45px">性质</th> -->
									<th style="min-width:60px">项目所在地</th>
									<th style="min-width:45px">负责人</th>
									<th style="min-width:45px">状态</th>
									<th style="min-width:60px">创建时间</th>
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
<iframe id="excelDownload" style="display:none;"></iframe>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sale/projectManage/js/list.js"></script>
</body>
</html>