<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">

<style>
	td {
		text-align: left;
	}
	.selected {
		background-color: gray;
	}
</style>
</head>
<body>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header" style="padding:0px;">
						<form class="form-inline" role="form">
							<div class="form-group">
								<label for="name" class="col-sm-1 control-label" style="float:left;line-height:2.5em;">项目</label>
								<input class="form-control" id="name" name="name" placeholder="项目" style="float:left;width:30%;">
							</div>
							<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
							<button type="reset" class="btn btn-default" style="margin-left:10px;">清空</button>
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered">
							<thead>
								<tr>
									<th>项目</th>
									<th>负责人</th>
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

<%@ include file="../footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/nicescroll/jquery.nicescroll.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script>
var rowData = null;
var dataTable = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sale/projectManage/getProjectList2",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
	$("html").niceScroll({
    	cursorcolor: "#bdbdbd",
    	cursorwidth: "10px",
    	autohidemode: false,
    	mousescrollstep: 40
    });
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'name'},
        {"mData": 'principal'}
    ]
	
	return columns;
}


function getSearchData() {
	var params = {};
	params.nature = $("#nature").val();
	params.name = $("#name").val();
	return params;
}


$(document).keydown(function(event){
	if(event.which == 13){
		drawTable();
		return false;
	}
});

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	if(aData.name != null) {
		$('td:eq(0)', nRow).html(aData.name);
		$('td:eq(0)', nRow).attr("title", aData.name);
	}
	
	// 项目负责人
	if(aData.principal != null) {
		$('td:eq(1)', nRow).text(aData.principal.name);
	}
	else{
		$('td:eq(1)', nRow).text("");
	}
	
	$(nRow).click(function() {
		$("#dataTable").find("tr").not($(this)).removeClass("selected");
		$(this).addClass("selected");
		
		rowData = dataTable.data()[$(this).index()];
	});
	
	$(nRow).dblclick(function(){
		
		$("#dataTable").find("tr").not($(this)).removeClass("selected");
		$(this).addClass("selected");
		rowData = dataTable.data()[$(this).index()];
		
		parent.window._getProject_();
		
		var closeBtn = parent.window.document.getElementById("project_close");
		$(closeBtn).trigger("click");	
		 
	});
    return nRow;
}

function getRowData() {
	return rowData;
}

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}
</script>
</body>
</html>