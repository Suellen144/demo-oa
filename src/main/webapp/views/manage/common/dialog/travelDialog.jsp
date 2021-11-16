<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
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
						<form id="form1" class="form-inline" role="form">
							<div class="form-group">
								<label for="account" class="col-sm-1 control-label" style="float:left;line-height:2.5em;padding-right:0.5em;">出差日期&nbsp;&nbsp;&nbsp;&nbsp;从</label>
								<input class="form-control" id="beginDate" name="beginDate" placeholder="起始日期" style="float:left;width:25%;background-color: inherit;" readonly>
								<label for="account" class="col-sm-1 control-label" style="float:left;line-height:2.5em;padding-left:0.5em;padding-right:0.5em;">到</label>
								<input class="form-control" id="endDate" name="endDate" placeholder="结束日期" style="float:left;width:25%;background-color: inherit;" readonly>
								<button type="button" class="btn btn-primary" onclick="drawTable()" style="float:left;margin-left:10px;">搜索</button>
								<button type="reset" class="btn btn-default" style="float:left;margin-left:10px;">清空</button>
							</div>
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered">
							<thead>
								<tr>
									<c:if test="${param.isCheck == true}">
										<th></th>
									</c:if>
									<th>出差人员</th>
									<th>申请日期</th>
									<th>费用预算</th>
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
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/nicescroll/jquery.nicescroll.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script>
var rowData = null;
var dataTable = null;
var isCheck = <%=request.getParameter("isCheck")%>;
var rowDataList = [];
var name;
$(function() {
	$("#beginDate,#endDate").datetimepicker({
		minView: "month",
		language:"zh-CN",
		format: "yyyy-mm-dd",
		toDay: true,
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
	
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/travel/getTravelListForDialog",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
		"drawCallBack": drawCallBack
	});
	
	$("html").niceScroll({
    	cursorcolor: "#bdbdbd",
    	cursorwidth: "10px",
    	autohidemode: false,
    	mousescrollstep: 40
    });
	
});

function init(){
	name = window.parent.getTravelname();
	return name;
}


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'name'},
        {"mData": 'applyTime'},
        {"mData": 'budget'}
    ]
	
	if(isCheck) {
		columns.splice(0, 0, {"mData": null});
	}
	
	
	return columns;
}

function getSearchData() {
	
	var params = {};
	params.beginDate = $.trim($("#beginDate").val());
	params.endDate =  $.trim($("#endDate").val());
	init(); 
	params.fuzzyContent = name;
	
	if(isNull(params.beginDate)) {
		params.beginDate = null;
	} else {
		params.beginDate += " 00:00:00";
	}
	if(isNull(params.endDate)) {
		params.endDate = null;
	} else {
		params.endDate += " 23:59:59";
	}
	
	return params;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	if(isCheck) {
		$('td:eq(0)', nRow).html("<input type='checkbox' value='"+aData.id+"' />");
		$("td:eq(1)", nRow).html(aData.applicant.name);
		$("td:eq(2)", nRow).html(new Date(aData.applyTime).pattern("yyyy-MM-dd"));
		mulitSelecte(nRow);
	} else { 
		$("td:eq(0)", nRow).html(aData.applicant.name);
		$("td:eq(1)", nRow).html(new Date(aData.applyTime).pattern("yyyy-MM-dd"));
		$(nRow).click(function() {
			$("#dataTable").find("tr").not($(this)).removeClass("selected");
			$(this).addClass("selected");
			
			rowData = dataTable.data()[$(this).index()];
		});
	 } 
}


function mulitSelecte(nRow) {
$(nRow).click(function() {
	rowDataList = [];
	rowData = dataTable.data()[$(this).index()];
	if($(this).hasClass("selected")) {
		$(this).removeClass("selected");
		$(this).find("input[type='checkbox']").prop("checked", false);
		var temp = null;
		$(rowDataList).each(function(index, data) {
			if(data.id == rowData.id) {
				temp = index;
				return ;
			}	
		});
		if(temp != null) {
			rowDataList.splice(temp, 1);
		}
	} else {
		$(this).addClass("selected");
		$(this).find("input[type='checkbox']").prop("checked", true)
	}
});
} 

function getRowData() {
	
	rowDataList = [];
	$("#dataTable").find("tbody tr").each(function(index, tr) {
		if($(this).find("input[type='checkbox']").prop("checked")) {
			rowDataList.push(dataTable.data()[index]);
		}
	});
	if(isCheck) {
		return rowDataList;
	} else {
		return rowData;
	} 
}

function Trim(str)
{ 
 return str.replace(/(^\s*)|(\s*$)/g, ""); 
}

function drawCallBack() {
	if(isCheck) {
		var idList = {};
		/* $(rowDataList).each(function(index, data) {
			idList[data.id] = true;
		}); */
		
		if($(rowDataList).length == "0"){
			if(window.parent.getTravelID() != undefined){
				var result = window.parent.getTravelID().split(",");
				$(result).each(function(index, data) {
					data=Trim(data);
					idList[data] = true;
				}); 
			}
		}
		else{
			$(rowDataList).each(function(index, data) {
				idList[data.id] = true;
			});
		}
		 
		$("#dataTable").find("tbody tr").each(function(index, tr) {
			var id = $(this).find("input[type='checkbox']").attr("value");
			
			if(idList[id]) {
				$(this).addClass("selected");
				$(this).find("input[type='checkbox']").prop("checked", true);
			}
		});
	}
}


function drawTable() {
	if(dataTable != null) {
		dataTable.draw(); 
		/* drawCallBack(); */
	}
}

function cleanForm() {
	$("#form1").clear();
}
</script>
</body>
</html>