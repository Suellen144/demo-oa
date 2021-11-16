<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
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

#content{
  white-space: pre-wrap;
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
		<li class="active">行政管理</li>
		<li class="active">用章管理</li>
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
								<table id="searchTable">
									<tr>
										<shiro:hasPermission name="ad:meeting:apply">
										<td style="padding-right:4px;"><button id="addBtn" type="button"
												class="btn btn-primary" onclick="toAdd()">填写纪要</button></td>
										</shiro:hasPermission>
										<td><label for="fuzzyContent" class="control-label" style="margin-left: 10px;">搜索内容</label></td>
										<td><input class="form-control" id="fuzzyContent"
											name="fuzzyContent" placeholder="内容模糊匹配" style="margin-left: 10px;"></td>
										<td>
											<button type="button" class="btn btn-primary"
												onclick="drawTable()" style="margin-left: 10px;">搜索</button>
											<button type="button" class="btn btn-default"
												onclick="clearForm()" style="margin-left: 10px;">清空</button>
										</td>
									</tr>
								</table>
							</form>
						</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th style="width: 5%;">部门</th>
									<th style="width: 10%;">纪要号</th>
<!-- 									<th>记录人</th> -->
									<th>主题</th>
									<th style="width:5%">状态</th>
									<th style="width:5%">发起时间</th>
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
<div class="modal fade" id="meetingModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:90%;">
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
										<tr><td colspan="8"><div id="content"></div></td></tr>
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
																<td class="text-right"><span>记录人：</span></td>
																<td colspan="1"><input type="text" id="createBy" value="" readonly></td>
																<td class="text-right"><span>主持人：</span></td>
																<td ><input type="text" id="approver" value="" readonly></td>
															</tr>
															<tr>
																<td class="text-right" style="width:9%;"><span>参与人员：</span></td>
																<td ><input type="text" id="type2" value="" readonly></td>
																<td class="text-right" style="width:11%;"><span>发送至：</span></td>
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
	      	<div class="modal-footer">
	      	<button type="button" class="btn btn-warning" data-dismiss="modal" >关闭</button>
	      	</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/meeting/js/list.js"></script>
</body>
</html>