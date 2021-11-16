<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#myTab>li.active a{
	background-color: #3c8dbc;	
	color: white;
	font-weight: bold;
}

#table1 {
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
	width: 98%;
}
#table1 td {
	/* border: solid #999 1px; */
	padding: 10px 5px;
}
#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}
#table1 td span {
	padding: 0px;
}
#table1 th {
	text-align: center;
	/* border: solid #999 1px; */
	font-size: 1.5em;
	padding-right: 0px;
	white-space: nowrap !important;  
}

tbody td {   
    white-space: nowrap !important;  
}  

#table2 tr {
	float: left;
}
#table2 label {
	text-align: right;
	line-height:2.5em;
	padding: 0px 0.5em 0px 1em;
}

#dataTable th {
	padding-right: 0px
}

.text-right {
	text-align: right;
}

#content{
	white-space: pre-line;
}

#deptName {
	width: 69%;
	height: 100%;
	overflow: visible;
	position: absolute;
	top: 70%;
	border: none;
	resize: none;
	outline: none;
}

#dept, #updateDate {
	width: auto !important;
	min-width: 18em;
	text-align: center;
	float: right;
}

.auto_truncate {
	text-overflow: ellipsis;
 	white-space: nowrap;
 	overflow: hidden;
 	float: left;
}

#beginDate, #endDate {
	width: 20%;
}
</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">公共信息</li>
		<li class="active">信息发布</li>
	</ol>
</header>

<ul id="myTab" class="nav nav-tabs rlspace">
  		<li class="active"><a href="#list" data-toggle="tab">通知管理</a></li>
    	<li><a href="#document" data-toggle="tab">公文管理</a></li> 
</ul>

<div id="myTabContent" class="tab-content">
<div class="tab-pane fade in active" id="list">	
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
						<form id="searchForm" class="form-inline" role="form">
							<select id="noticeType" style="display:none;">
								<custom:dictSelect type="公告类型"/>
							</select>
							<table id="table2">
								<tr>
									<td>
										<shiro:hasPermission name="off:notice:add">
											 <button id="addBtn" type="button" class="btn btn-primary" onclick="toAdd()">信息发布</button>
										</shiro:hasPermission>
									</td>
									<td><label for="fuzzyContent" class="control-label">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="标题或内容"></td>
									
									<td><label for="roleName_duplicate" class="control-label">发布时间</label></td>
									<td>
										<input class="form-control" id="beginDate" name="beginDate" placeholder="起始时间" style="background-color: inherit;" readonly>
										<span>到</span>
										<input class="form-control" id="endDate" name="endDate" placeholder="结束时间" style="background-color: inherit;" readonly>

										<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
										<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>标题</th>
									<th class="col-sm-3 col-md-3 col-lg-2">发布部门</th>
									<th class="col-sm-2 col-md-1 col-lg-1">发布时间</th>
									<c:if test="${sessionScope.user.id ne 2 }">
										<shiro:hasPermission name="off:notice:add">
										<th class="col-sm-2 col-md-1 col-lg-1">发布状态</th>
										</shiro:hasPermission>
									</c:if>
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
	<div class="tab-pane fade" id="document">
      <iframe id="document_iframe" name="document_iframe" width="100%" height="1000"  frameborder="no" scrolling="yes" src="<%=base%>/manage/office/noitce/findDocumentToList"></iframe>
   </div>
</div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="noticeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%;">
    	<div class="modal-content">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel"></h4>
         	</div>
	        <div class="modal-body" style="overflow:auto; padding-top:0px;">
	        	<div class="row">
					<div class="col-md-12">
						<div class="tbspace" style="padding-top:0px !important;">
							<form id="form1">
								<table id="table1">
									<thead>
										<tr><th colspan="8" id="title" style="padding:0.5em 0px;"></th></tr>
									</thead>
									<tbody>
										<tr><td colspan="8"><div id="content" style="white-space: pre-line;"></div></td></tr>
										<tr>
											<td colspan="20">
												<span>附件：</span>
												<a href="javascript:void(0)"><input type="text" id="attachName" name="attachName" style="width:90%;" value="" readonly></a>
											</td>
										</tr>
										<tr>
											<td><span></span></td>
											<td colspan="20"><input type="text" id="dept" name="dept" value="" readonly></td>
										</tr>
										<tr>
											<td><span></span></td>
											<td colspan="20" ><input type="text" id="updateDate" value="" readonly></td>
										</tr>
										<tr>
											<td colspan="20">
												<div id="details_div" class="box box-primary collapsed-box" style="box-shadow:none;">
										            <div class="box-header with-border">
										              <h3 class="box-title"></h3>
										              <div class="box-tools pull-right">
										                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>
										              </div>
										            </div>
										            <div class="box-body">
								            			<table>
											            	<tr>
																<td class="text-right"><span>拟稿人：</span></td>
																<td colspan="1"><input type="text" id="createBy" value="" readonly></td>
																<td class="text-right"><span>签发人：</span></td>
																<td ><input type="text" id="approver" value="" readonly></td>
															</tr>
															<tr>
																<td class="text-right" style="width:9%;"><span>类型：</span></td>
																<td ><input type="text" id="type2" value="" readonly></td>
																<td class="text-right" style="width:11%;"><span>抄送：</span></td>
																<td style="width:70%;"><textarea id="deptName" name="deptName" readonly></textarea></td>
															</tr>
														</table>
										            </div>
									            </div>
											</td>
										</tr>
									</tbody>
								</table>
							</form>
						</div>
					</div>
				</div>
			</div>
	      	<div class="modal-footer"></div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/office/notice/js/list.js"></script>
<script type="text/javascript">
var flag = '<shiro:hasPermission name="off:notice:add">true</shiro:hasPermission>';
var canEdit = '<shiro:hasPermission name="off:notice:edit">true</shiro:hasPermission>';
var canDel = '<shiro:hasPermission name="off:notice:del">true</shiro:hasPermission>';
var userId = '${sessionScope.user.id}';
var deptList = JSON.parse('${deptList}');
var deptMap = {};
var parentDeptList = [];
$(deptList).each(function(index, dept) { if(dept.level == 1) {parentDeptList.push(dept);} deptMap[dept.id]=dept; });
</script>
</body>
</html>