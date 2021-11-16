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
						<form id="searchForm" class="form-inline" role="form">
							 <table id="searchTable" style="margin-top: 8px">
								<tr >
									<td ><label for="fuzzyContent" class="control-label" style="margin-top: 10px;margin-left: 10px">搜索内容</label></td>
									<td><input class="form-control" style="margin-top: 6px;margin-left: 6px" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配"></td>
								
									<td><button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left: 15px;margin-top: 6px">搜索</button></td>
									<td><button type="reset" class="btn btn-default" onclick="clearForm()" style="margin-left: 6px;margin-top: 6px">清空</button></td>
								</tr>
						</table>
					</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered" style="font-size: 12px;text-align: center;">
							<thead>
								<tr>
									<th>所属部门</th>
									<th>流程发起人</th>
									<th>合同类型</th>
									<th>合同编号</th>
									<th>发起时间</th>
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
		"url": web_ctx + "/manage/sale/barginManage/getBarginListForDialog",
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
         {"mData": 'dept'}, 
         {"mData": 'sysUser'},
 	     {"mData": 'barginType'}, 
         {"mData": 'barginCode'},   
         {"mData": 'createDate'},
    ]
	
	return columns;
}


function getSearchData() {
	var params = {};
	var status = "5";
	params.startTime = $.trim($("#startTime").val());
	params.endTime = $.trim($("#endTime").val());
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	params.status = status;
	if(!isNull(params.startTime)) {
		params.startTime += " 0:0:0";
	}
	if(!isNull(params.endTime)) {
		params.endTime += " 23:59:59";
	}

	return params;
}

function initDatetimepicker() {
	$("input[name='startTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
	
	$("input[name='endTime']").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        bootcssVer:3,
        autoclose: true,
    });
}


/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	if(aData.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}else{
		$('td:eq(0)', nRow).html(aData.dept.name);
	}
	$('td:eq(1)', nRow).html(aData.sysUser.name);
	
	if(aData.barginType == "B") {
		$('td:eq(2)', nRow).html('采购合同');
	} else if(aData.barginType == "S") {
		$('td:eq(2)', nRow).html('销售合同');
	} else if(aData.barginType == "C") {
		$('td:eq(2)', nRow).html('合作协议');
	} else if(aData.barginType == "L") {
		$('td:eq(2)', nRow).html('劳动合同');
	} else if(aData.barginType == "M") {
		$('td:eq(2)', nRow).html('备忘录');
	}else if(aData.barginType == "E") {
		$('td:eq(2)', nRow).html('融投资协议');
	}
	
	$('td:eq(4)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));
	
	if(aData.status == "1") {
		$('td:eq(5)', nRow).html('部门经理审批');
	} else if(aData.status == "2") {
		$('td:eq(5)', nRow).html('财务审批');
	} else if(aData.status == "3") {
		$('td:eq(5)', nRow).html('总经理审批');
	} else if(aData.status == "4") {
		$('td:eq(5)', nRow).html('出纳确认');
	}else if(aData.status == "5") {
		$('td:eq(5)', nRow).html('已归档');
	} else if(aData.status == "6") {
		$('td:eq(5)', nRow).html('取消申请');
	} else if(aData.status == "7" || aData.status == "8" || aData.status == "9") {
		$('td:eq(5)', nRow).html('提交申请');
	} else if(aData.status == null || aData.status== "") {
		$('td:eq(5)', nRow).html('未提交');
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
		
		parent.window._getBargin_();
		
		var closeBtn = parent.window.document.getElementById("bargin_close");
		$(closeBtn).trigger("click");	
		 
	});
    return nRow;
    return nRow;
}

//添加回车响应事件
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey==13){
		drawTable();
		return false;
	}
});

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function getRowData() {
	return rowData;
}

function clearForm() {
	$("#searchForm").clear();
	$("#startTime").prop("readonly", true);
	$("#endTime").prop("readonly", true);
}
</script>
</body>
</html>