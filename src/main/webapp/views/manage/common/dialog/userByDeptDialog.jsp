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
	
#searchTable tr {
	float: left;
	}
#searchTable label {
	text-align: right;
	line-height:2.5em;
	padding: 0px 0.5em 0px 1em;
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
							 <table id="searchTable">
								<tr>
									<td>
									</td>
									<td><label for="fuzzyContent" class="control-label">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配"></td>
									<td>
										<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
										<button type="reset" class="btn btn-default" style="margin-left:10px;">清空</button>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered">
							<thead>
								<tr>
									<th>帐号</th>
									<th>姓名</th>
									<th>手机号码</th>
									<th>部门</th>
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
var selectUser = null; // 选中的用户ID
var deptName;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
// 		"url": web_ctx + "/manage/sys/user/getUserList",
		"url": web_ctx + "/manage/sys/user/getUserList2",
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
	    {"mData": 'account'},
        {"mData": 'name'},
		{"mData": 'mobilephone'},
        {"mData": 'dept'}
    ]
	
	return columns;
}

function getSearchData() {
	var params = {};
	init();
	if ($.trim($("#fuzzyContent").val()) != ""){
        params.fuzzyContent = $.trim($("#fuzzyContent").val());
	}else {
       // $("#fuzzyContent").val(deptName);
	//	params.fuzzyContent = $.trim($("#fuzzyContent").val());
     //   params.fuzzyContent = deptName;
	}
	return params;
}

function init() {
	deptName = window.parent.getDeptName();
	return deptName;
}

$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey==13){
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
	
	if(aData.dept != null) {
		$("td:eq(3)", nRow).html(aData.dept.name);
	}
	$(nRow).attr("id", aData.id);
	if( !isNull(selectUser) && selectUser == aData.id ) {
		$(nRow).siblings().removeClass("selected");
		$(nRow).addClass("selected");
	}
	
	$(nRow).click(function() {
		if( $(this).hasClass("selected") ) {
			$(this).removeClass("selected");
			rowData = null;
		} else {
			$("#dataTable").find("tr").not($(this)).removeClass("selected");
			$(this).addClass("selected");
			
			rowData = dataTable.data()[$(this).index()];
		}
	});
	
	$(nRow).dblclick(function(){
			
			$("#dataTable").find("tr").not($(this)).removeClass("selected");
			$(this).addClass("selected");
			rowData = dataTable.data()[$(this).index()];
			
			//parent.window._getUserData_();
			parent.window._getUserByDeptData_();
			
			var closeBtn = parent.window.document.getElementById("user_close2");
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

function setSelectedUser(selectUserParam) {
	selectUser = selectUserParam;
	$("#dataTable tbody").find("tr").each(function(index, tr) {
		$(tr).siblings().removeClass("selected");
		if( $(tr).attr("id") == selectUser ) {
			$(tr).addClass("selected");
			return false;
		}
	});
}
</script>
</body>
</html>