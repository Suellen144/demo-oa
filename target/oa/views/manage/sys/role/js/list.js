var datatable = null;
$(function() {
	datatable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sys/role/getRoleList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
});

$(document).keydown(function(event){
	if(event.which == 13) {
		drawTable();
		return false;
	}
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'name'}, //mData 表示发请求时候本列的列明，返回的数据中相同下标名字的数据会填充到这一列
        {"mData": 'enname'},
        {"mData": 'enabled'},
        {"mData": null}
    ]
	
	return columns;
}

function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	return params;
}

function drawTable() {
	if(datatable != null) {
		datatable.draw();
	}
}

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
	
	var htmlText = buildOperate(aData);
	$('td:eq(3)', nRow).html(htmlText);
	
	if(aData.enabled == 1) {
		$('td:eq(2)', nRow).html('启用');
	} else {
		$('td:eq(2)', nRow).html('禁用');
	}
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData) {
	var html = [];
	html.push("<a href='toAuthority?id="+aData.id+"' class='ace_detail'>授权</a>");
	html.push("&nbsp;&nbsp;");
	html.push("<a href='"+web_ctx+"/manage/sys/role/toAddOrEdit?id="+aData.id+"' class='ace_detail'>编辑</a>");
	html.push("&nbsp;&nbsp;");
	html.push("<a href='javascript:;' name='' onclick='del("+aData.id+")'>删除</a>");
	
	return html.join("");
}

var idForDel = null;
function del(roleid) {
	idForDel = roleid;
	
	bootstrapConfirm("提示", "是否删除？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "delete",    
	        "dataType": "json",   
	        "data": {"id": idForDel},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		start = $("#dataTable").dataTable().fnSettings()._iDisplayStart; 
	        		total = $("#dataTable").dataTable().fnSettings().fnRecordsDisplay(); 
	        		location.replace(location.href);
	        		if((total-start)==1 && start > 0) { 
		        		$("#dataTable").dataTable().fnPageChange('previous', true); 
	        		}
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

function toAddOrEdit(id) {
	window.location.href = web_ctx+"/manage/sys/role/toAddOrEdit?id="+id;
}