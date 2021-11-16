var dataTable = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/invest/getList",
		"columns": initColumn(),
		//"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
});


function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
	    {"mData": 'value'}, 
	    {"mData": 'createDate'},
        {"mData": null}   //操作列
    ]
	
	return columns;
}

function getSearchData() {
	return null;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	$('td:eq(1)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mmm"));
	
	var htmlText = buildOperate(aData);
	$('td:eq(2)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData) {
	var html = [];
	html.push("<a href='javascript:;' onclick='toEdit("+aData.id+")'>编辑</a>");
	html.push("&nbsp;&nbsp;")
	html.push("<a href='javascript:;' onclick='del("+aData.id+", this)'>删除</a>");
	return html.join("");
}

function toAdd() {
	window.location.href = "toAddOrEdit";
}

function toEdit(id) {
	window.location.href = "toAddOrEdit?id="+id;
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
	        "data": { "id": idForDel },
	        "success": function(data) {   
	        	if(!isNull(data) && data.code == 1) {
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

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}