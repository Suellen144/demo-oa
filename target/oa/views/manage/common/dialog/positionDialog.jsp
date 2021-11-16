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
	.form-group {
		float: left;
		width: 50%;
		padding-top: 10px;
		padding-left: 10px;
	}
	.form-group input {
		width: 50%;
		display: inline-block;
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
							<div class="form-group">
								<label for="name"  class="control-label">职位(中英文)</label>
								<input class="form-control" id="name" name="name" placeholder="职位">
							</div>
							<!-- <div class="form-group">
								<label for="code" class="control-label">职位代码</label>
								<input class="form-control" id="code" name=code placeholder="代码">
							</div> -->
								<div style="float:left;padding-top:10px;">
								<button type="button" class="btn btn-primary" onclick="search()" style="float:left;margin-left:10px;">搜索</button>
								<button type="button" class="btn btn-default" onclick="clearForm()" style="float:left;margin-left:10px;">清空</button>
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
									<th>职位</th>
									<th>所属单位</th>
									<!-- <th>职位代码</th> -->
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
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script>
var rowData = null;
var dataTable = null;
var isCheck = <%=request.getParameter("isCheck")%>;
var rowDataList = [];

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/position/getPositionList",
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


$(document).keydown(function(event){
	if(event.which == 13){
		search();
		return false;
	}
});

function getDeptName(deptId){
	$.ajax({
		url:web_ctx+"/manage/sys/dept/findByDeptId?timetamp="+new Date().getTime(),
		async: false,
		dataType: "json",
		contentType:"application/json;charset:UTF-8",
		data:{"deptId":deptId},
		success:function(data){
			deptName = data;
		},
		error:function(data) {
			bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
		}
	})
	return deptName;
}


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'name'},
        {"mData": 'deptId'}
        /* {"mData": 'code'} */
    ];
	
	if(isCheck) {
		columns.splice(0, 0, {"mData": null});
	}
	
	return columns;
}

function getSearchData() {
	var params = {};
	params.name = $.trim($("#name").val());
	params.code = $.trim($("#code").val());

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
		if(getDeptName(aData.deptId)!=null){
			$('td:eq(2)', nRow).html(getDeptName(aData.deptId).name);
		}else{
			$('td:eq(2)', nRow).html("");
		}
		mulitSelecte(nRow);
	} else {
		$(nRow).click(function() {
			$("#dataTable").find("tr").not($(this)).removeClass("selected");
			$(this).addClass("selected");
			
			rowData = dataTable.data()[$(this).index()];
		});
	}
	
    return nRow;
}

function mulitSelecte(nRow) {
	$(nRow).click(function() {
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
			$(this).find("input[type='checkbox']").prop("checked", true);
			
			rowDataList.push(rowData);
		}
	});
}

function getRowData() {
	if(isCheck) {
		return rowDataList;
	} else {
		return rowData;
	}
}

function drawTable() {
	if(dataTable != null) {
		drawCallBack();
	}
}


function search() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}

function drawCallBack() {
	if(isCheck) {
		var idList = {};
		if($(rowDataList).length == "0"){
			if(window.parent.getpositionname() != undefined){
				var result = window.parent.getpositionname().split(",");
				$(result).each(function(index, data) {
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
</script>
</body>
</html>