<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<%--<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">--%>
<style>
#myTab>li.active a{
	background-color: #3c8dbc;	
	color: white;
	font-weight: bold;
}
#dataTable_info, #dataTable_paginate {
	display: none;
}

.control-label {
	padding-left: 1em;
	padding-right: 0.5em;
}

#dataTable th {   
    white-space: nowrap !important;  
      text-align: center;
}  

#dataTable td {   
    white-space: nowrap !important;  
    text-align: center;
}


/*table.dataTable thead > tr > th {
!*	 padding-right: auto;*!
}*/

</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">行政管理</li>
		<li class="active">档案管理</li>
	</ol>
</header>

<ul id="myTab" class="nav nav-tabs rlspace">
  		<li class="active"><a href="#list" data-toggle="tab">档案管理</a></li>
		<c:forEach items="${user.roleList }" var="role">
		<c:if test="${role.name eq '财务' or role.name eq '总经理'}">
  		<li><a href="#salary" data-toggle="tab">薪酬管理</a></li> 
    	<li><a href="#salaryManage" data-toggle="tab">历史薪酬管理</a></li>
			<c:if test="${sessionScope.user.id eq '2' or sessionScope.user.id eq '3'}">
		<li><a href="#reward" data-toggle="tab">留任奖管理</a></li>
			</c:if>
		</c:if>
		</c:forEach>
</ul>
<div id="myTabContent" class="tab-content">
<div class="tab-pane fade in active" id="list">	
	<div class="wrapper">
		<!-- Main content -->
		<section class="content rlspace">
			<div class="row">
				<div class="col-md-12">
					<div class="box box-primary">
						<!-- /.box-header -->
						<div class="box-header">
						<c:forEach items="${user.roleList }" var="role">
						<c:if test="${(role.name eq '行政' ) or (role.name eq '总经理')}">
						 <button id="addBtn" type="button" class="btn btn-primary" onclick="toAdd()">新增</button>
						</c:if>
						</c:forEach>
						<c:if test="${user.name eq '超级管理员' }">
						 <button id="addBtn" type="button" class="btn btn-primary" onclick="toAdd()">新增</button>
						</c:if>
							 <form id="searchForm" class="form-inline" role="form" style="float: right;">
								 <table id="searchTable">
									<tr>
										<td>
											<select class="form-control" id="dept" name="dept" onchange="drawTable()"><option value="">全部</option><custom:dictSelect type="存续公司"/><option value="">注销公司</option></select>
											<select class="form-control" id="entryStatus" name="entryStatus"onchange="drawTable()"><option value="">全部</option><custom:dictSelect type="员工在职状态" selectedValue="" /></select>
											<div class="input-group">
											<div  class="form-control">
												 <input type="text"  id="fuzzyContent" name="fuzzyContent" placeholder="模糊匹配" style="border: none;outline: none;"  class="input-mg">
											    <span class="fa fa-x fa-search" onclick="drawTable()"></span>
											</div>
											    <span  title="导出Excel" class="input-group-addon btn btn-primary  fa fa-x fa-cloud-download" onclick="exportExcel()" ></span>
											</div>
										</td>
									</tr>
								</table>
							</form>
						</div>
						<div class="box-body">
							<table id="dataTable" class="table table-bordered table-hover" style="font-size: 14px;">
								<thead>
									<tr><th colspan="12" style="text-align: center;"><span id="spCompany"></span>员工列表</th></tr>
									<tr>
										<th text-align: center; style="width: 4%">序号</th>
										<th style="width: 4%">部门</th>
										<th style="width: 4%">姓名</th>
										<th style="width: 4%">职位</th>
										<th style="width: 7%">入职日期</th>
										<th style="width: 4%">学历</th>
										<th style="width: 7%">院校</th>
										<th style="width: 4%">专业</th>
										<th style="width: 8%">电话</th>
										<th style="width: 8%">邮箱</th>
										<th style="width: 15%">身份证</th>
										<th style="width: 7%">离职日期</th>
										<th style="width: 4%">状态</th>
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
</div>
	<c:forEach items="${user.roleList }" var="role">
	<c:if test="${role.name eq '财务' or role.name eq '总经理' or user.name eq '超级管理员'}">
	<div class="tab-pane fade" id="salaryManage">
      <iframe  name="salaryManage_iframe" width="100%" height="1000"  frameborder="no" scrolling="yes" src="<%=base%>/manage/ad/salaryManage/toList"></iframe>
   </div>
   <div class="tab-pane fade" id="salary">
      <iframe  name="salary_iframe" width="100%" height="1000"  frameborder="no" scrolling="yes" src="<%=base%>/manage/ad/salary/toList"></iframe>
   </div>
	<div class="tab-pane fade" id="reward">
			<iframe name="salary_iframe" width="100%" height="1000"  frameborder="no" scrolling="yes" src="<%=base%>/manage/ad/reward/toList"></iframe>
	</div>
	</c:if>
	</c:forEach>
</div>
<iframe id="excelDownload" style="display:none;"></iframe>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/validator/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/record/js/list.js"></script>
</body>
</html>