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
		<li class="active">项目管理</li>
	</ol>
</header>
<style>
	#myTab>li.active a{
		background-color: #3c8dbc;
		color: white;
		font-weight: bold;
	}
	#dataTable td{
		white-space: nowrap;
	}
	#dataTable th{
		white-space: nowrap;
	}
</style>
<ul id="myTab" class="nav nav-tabs rlspace">
			<li class="active"><a href="#list" data-toggle="tab">项目列表</a></li>
			<!-- <li><a href="#normalApply" data-toggle="tab">项目申请管理</a></li> -->
			<li><a href="#normalContract" data-toggle="tab">合同管理</a></li>
			<!-- <li><a href="#normalInvoice" data-toggle="tab">发票管理</a></li>
			<li><a href="#normalCollection" data-toggle="tab">收付款管理</a></li> -->
			<c:if test="${sessionScope.user.deptId eq '2' or sessionScope.user.deptId eq '4'}">
			<li><a href="#commission" data-toggle="tab">提成管理</a></li>
			<li><a href="#performance" data-toggle="tab">业绩管理</a></li>
			</c:if>
</ul>
<div id="myTabContent" class="tab-content">
	<div class="tab-pane fade in active" id="list">
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">项目管理</li>
		</ol>
		<!-- Main content -->
		<section class="content rlspace">
			<div class="row">
				<div class="col-xs-12">
					<div class="box box-primary">
						<div class="box-header">
							<form id="searchForm" class="form-inline" role="form">
								<c:choose>
								<c:when test="${sessionScope.user.dept.id eq '4' }">
								<button type="button" class="btn btn-primary" onclick="toAddOrEdit('')" style="margin-right:10px;" >新增项目</button>
								</c:when>
								<c:otherwise>
								<button type="button" class="btn btn-primary" onclick="toAdd()" style="margin-right:10px;" >新增项目</button>
								</c:otherwise>
								</c:choose>
								<td><label for="fuzzyContent" class="control-label" style="margin-left: 10px">搜索内容</label></td>
								<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配" style="margin-left: 4px"></td>
								<td>
								<label for="status_duplicate" class="control-label" style="line-height:2.5em;">状态</label></td>
								<td><select id="status" name="status" class="form-control">
									<option value="1">活动</option>
									<option value="2">审批中</option>
									<option value="-1">关闭</option>
									<option value="0">注销</option>
								</select></td>
								<td><label for="roleName_duplicate" class="control-label" style="margin-left: 8px">时间</label></td>
								<td>
									<input class="form-control" id="startTime" name="startTime" placeholder="开始时间" style="background-color: inherit;margin-left: 8px"" readonly>
									<span style="margin-left: 4px">到</span>
									<input class="form-control" id="endTime" name="endTime" placeholder="结束时间" style="background-color: inherit;margin-left: 4px"" readonly>
								</td>
								<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
								<!-- <button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button> -->
								<!-- <span style="display: inline-block;width:58px;height: 36.67px;" title="导出Excel" class="btn btn-primary  fa fa-x fa-cloud-download" onclick="exportExcel()" ></span> -->
							</form>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<table id="dataTable" class="table table-bordered table-hover" >
								<thead>
									<tr>
										<th style="text-align: center;">项目名称</th>
										<th style="text-align: center;">负责人</th>
										<th style="text-align: center;">规模(元)</th>
										<th style="text-align: center;">合同金额</th>
										<th style="text-align: center;">收入</th>
										<th style="text-align: center;">支出</th>
										<th style="text-align: center;">攻关费用余额</th>
										<th style="text-align: center;" id="replace1">立项时间</th>
										<th style="text-align: center;" id="replace2">结束时间</th>
										<!-- <th style="min-width:60px">状态</th> -->
									</tr>
								</thead>
							</table>
						</div>
						<!-- /.box-body -->
					</div>
					<!-- /.box -->
				</div>
			</div>
		</section>
	</div>
	<%-- <div class="tab-pane fade" id="normalApply">
		<iframe id="normalApply_iframe" name="normalApply_iframe" width="100%" style="min-height: 768px"
				frameborder="no" scrolling="yes" src="<%=base%>/manage/finance/projectApplication/toList"></iframe>
	</div> --%>
	<div class="tab-pane fade" id="normalContract">
		<iframe id="normalContract_iframe" name="normalContract_iframe" width="100%" style="min-height: 768px"
				frameborder="no" scrolling="yes" src="<%=base%>/manage/sale/barginManage/toListNew"></iframe>
	</div>
	<%-- <div class="tab-pane fade" id="normalInvoice">
		<iframe id="normalInvoice_iframe" name="normalInvoice_iframe" width="100%" style="min-height: 768px"
				frameborder="no" scrolling="yes" src="<%=base%>/manage/sale/finInvoiced/toList"></iframe>
	</div>
	<div class="tab-pane fade" id="normalCollection">
		<iframe id="normalCollection_iframe" name="normalCollection_iframe" width="100%" style="min-height: 768px"
				frameborder="no" scrolling="yes" src="<%=base%>/manage/finance/collection/toListNew"></iframe>
	</div> --%>
	<div class="tab-pane fade" id="commission">
		<iframe id="normalRoyalty_iframe" name="normalRoyalty_iframe" width="100%" style="min-height: 768px"
				frameborder="no" scrolling="yes" src="<%=base%>/manage/finance/projectApplication/toRoyaltyNew"></iframe>
	</div>
	<div class="tab-pane fade" id="performance">
		<iframe id="normalAchievement_iframe" name="normalAchievement_iframe" width="100%" style="min-height: 768px"
				frameborder="no" scrolling="yes" src="<%=base%>/manage/finance/projectApplication/toAchievementList"></iframe>
	</div>
</div>
<iframe id="excelDownload" style="display:none;"></iframe>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sale/projectManageNew/js/list.js"></script>
<script>
var userId = ${sessionScope.user.id};
</script>
</body>
</html>
<script>
/* window.document.getElementById("normalCollection_iframe").contentWindow.onscroll = function aaa() {
    var ifm = document.getElementById("normalCollection_iframe").contentWindow.document.documentElement;
    var normalCollection_iframe = window.frames["normalCollection_iframe"].document.getElementById("reimburse_header");
    var top = normalCollection_iframe.clientHeight;
    
    if(top < ifm.scrollTop){ 
    	console.log(normalCollection_iframe)
    	normalCollection_iframe.classList.add("topIfm")
    }else{
    	normalCollection_iframe.classList.remove("topIfm")
    }
} */
</script>