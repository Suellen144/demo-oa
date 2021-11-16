var dataTable = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sale/projectManage/getProjectList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	drawTable();
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'name'},
        {"mData": 'type'},
        {"mData": 'location'},
        {"mData": 'principal'},
        {"mData": 'status'},
        {"mData": 'createDate'},
    ]
	
	return columns;
}

function getSearchData() {
	var params = {};
	params.name = $.trim($("#name").val());
	params.type = $.trim($("#type").val());
	params.status = $.trim($("#status").val());
	return params;
}

function drawTable() {
	$("#name").val($("#name_duplicate").val());
	$("#type").val($("#type_duplicate").val());
	$("#status").val($("#status_duplicate").val());
	
	if(dataTable != null) {
		dataTable.draw();
	}
}


//添加回车响应事件
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey==13){
		drawTable();
		return false;
	}
});

function clearForm() {
	$("#searchForm").clear();
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	// 项目类型
	if(aData.type == "0") {
		$('td:eq(1)', nRow).html("销售类");
	} else if(aData.type == "1"){
		$('td:eq(1)', nRow).html("研发类");
	}else if(aData.type == "2"){
		$('td:eq(1)', nRow).html("运营成本类");
	}else if(aData.type == "3"){
		$('td:eq(1)', nRow).html("业务成本类");
	}else if(aData.type == "4"){
		$('td:eq(1)', nRow).html("渠道合作项目");
	}else if(aData.type == "5"){
		$('td:eq(1)', nRow).html("合资项目");
	}
	
	// 开发地点
	if(aData.location == "0") {
		$('td:eq(2)', nRow).html("公司");
	} else if(aData.location == "1") {
		$('td:eq(2)', nRow).html("其他");
	} 
	
	// 项目负责人
	if(aData.principal != null) {
		$('td:eq(3)', nRow).html(aData.principal.name);
	}
	
	// 状态
	if(aData.status == "1") {
		$('td:eq(4)', nRow).html("活动");
	} else if(aData.status == "0") {
		$('td:eq(4)', nRow).html("关闭");
	} if(aData.status == "-1") {
		$('td:eq(4)', nRow).html("注销");
	}
	
	// 创建日期
	$('td:eq(5)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd"));
	
	// 操作
	var htmlText = buildOperate(nRow,aData);
	$('td:eq(6)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow,aData) {
	var html = [];
	/*html.push("<a href='javascript:;' onclick='toAddOrEdit("+aData.id+")' class='ace_detail'>编辑</a>");
	html.push("&nbsp;&nbsp;");*/
	$(nRow).attr("onclick", "toAddOrEdit("+aData.id+")");
	$(nRow).css("cursor", "pointer");
	return html.join("");
}


function toAddOrEdit(id) {
	window.location.href = web_ctx + "/manage/sale/projectManage/toAddOrEdit?id=" + id;
}

var idForDel = null;
var sourceForDel = null;
function del(id, source) {
	idForDel = id;
	sourceForDel = source;
	
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "delete",    
	        "dataType": "json",   
	        "data": {"id":idForDel},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		var tr = $(sourceForDel).parents("tr");
	        		dataTable.row(tr).remove().draw(false);
	        	} else {
	        		bootstrapAlert("提示", "删除出错", 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
	
}


function exportExcel(){
	var params = getSearchData();
	var url = web_ctx +  "/manage/sale/projectManage/exportExcel?" + params;
	$("#excelDownload").attr("src", url);
}