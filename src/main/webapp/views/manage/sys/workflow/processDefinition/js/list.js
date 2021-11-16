var dataTable = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sys/workflow/processDef/getProcessDefList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
	$(":input").inputmask();
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'id'},
        {"mData": 'deploymentId'},
        {"mData": 'name'},
        {"mData": 'key'},
        {"mData": 'version'},
        {"mData": 'deploymentTime'},
        {"mData": 'suspended'},
        {"mData": null}
    ]
	
	return columns;
}

function getSearchData() {
	var params = {};
	params.key = $.trim($("#key").val());
	params.name = $.trim($("#name").val());
	params.version = $.trim($("#version").val());
	params.status = $.trim($("#status").val());

	return params;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	$('td:eq(5)', nRow).html(new Date(aData.deploymentTime).pattern("yyyy-MM-dd HH:mm:ss"));
	if(aData.suspended) {
		$('td:eq(6)', nRow).html("挂起");
	} else {
		$('td:eq(6)', nRow).html("激活");
	}
	
	var htmlText = buildOperate(aData);
	$('td:eq(7)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData) {
	var html = [];
	html.push("<a href='javascript:;' onclick='del(\""+aData.id+"\")' class='ace_detail'>删除</a>");
	html.push("&nbsp;&nbsp;");
	if(aData.suspended) {
		html.push("<a href='javascript:;' onclick='updateStatus(\""+aData.id+"\", \"active\", this)' class='ace_detail'>激活</a>");
		html.push("&nbsp;&nbsp;");
	} else {
		html.push("<a href='javascript:;' onclick='updateStatus(\""+aData.id+"\", \"suspend\", this)' class='ace_detail'>挂起</a>");
		html.push("&nbsp;&nbsp;");
	}
	html.push("<a href='"+web_ctx+"/manage/sys/workflow/processDef/convertToModel/"+aData.id+"' class='ace_detail'>转换为Model</a>");
	
	return html.join("");
}

var idForUpdate = null;
var statusForUpdate = null;
var objForUpdate = null;
function updateStatus(pdId, status, obj) {
	idForUpdate = pdId;
	statusForUpdate = status;
	objForUpdate = obj;
	
	bootstrapConfirm("提示", "是否"+(statusForUpdate=="active"?"激活":"挂起")+"此流程？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "processDefinitionStatus",    
	        "dataType": "json",   
	        "data": {"processDefinitionId": idForUpdate, "status": statusForUpdate},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		location.replace(location.href);
	        	} else {
	        		bootstrapAlert("提示", data.result, 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
}

var idForDel = null;
function del(processDefinitionId) {
	idForDel = processDefinitionId;
	
	bootstrapConfirm("提示", "是否删除流程？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "deleteProcessDefinition",    
	        "dataType": "json",   
	        "data": {"processDefinitionId": idForDel},
	        "success": function(data) {   
	        	if(data != null && data.code == 1) {
	        		location.replace(location.href);
	        	} else {
	        		bootstrapAlert("提示", data.result, 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
}

function drawTable() {
	
	$("#key").val($("#key_duplicate").val());
	$("#name").val($("#name_duplicate").val());
	$("#version").val($("#version_duplicate").val());
	
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}