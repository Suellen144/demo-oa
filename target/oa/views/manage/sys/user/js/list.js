var dataTable = null;

$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/sys/user/getUserList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
});


function initColumn() {
	var columns =  [ //这个属性下的设置会应用到所有列
	    {"mData": 'account'},
        {"mData": 'name'},
        {"mData": 'dept'},
        {"mData": 'positionList'},
        {"mData": 'roleList'},
        {"mData": null}
    ]
	
	return columns;
}

function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	return params;
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
		var deptName = aData.dept.name;
		$('td:eq(2)', nRow).html(deptName);
	}
	if(aData.roleList != null && aData.roleList.length > 0) {
		var roles = [];
		$(aData.roleList).each(function(index, role) {
			roles.push(role.name);
			roles.push("<br/>");
		});
		
		$('td:eq(4)', nRow).html(roles.join(""));
	}
	
	if(aData.positionList != null && aData.positionList.length > 0) {
		var positions = [];
		$(aData.positionList).each(function(index, position) {
			positions.push(position.name);
			positions.push("<br/>");
		});
		
		$('td:eq(3)', nRow).html(positions.join(""));
	}
	
	var htmlText = buildOperate(aData);
	$('td:eq(5)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData) {
	var html = [];
	if(canChangePwd != "") {
		html.push("<a href='javascript:void();' onclick='resetPassword("+aData.id+")' class='ace_detail'>初始化密码</a>");
		html.push("&nbsp;&nbsp;");
	}
	if(canEdit != "") {
		html.push("<a href='"+web_ctx+"/manage/sys/user/toAddOrEdit?id="+aData.id+"' class='ace_detail'>编辑</a>");
		html.push("&nbsp;&nbsp;");
	}
	if(canDel != "") {
		if(aData.account=="admin"){//如果是系统管理员则不能进行删除
			
		}else{
			html.push("<a href='javascript:;' name='' onclick='del("+aData.id+", this)'>删除</a>");
		}
	}
	
	return html.join("");
}

function drawTable() {
	
/*	$("#name").val($("#name_duplicate").val());
	$("#account").val($("#account_duplicate").val());
	$("#deptName").val($("#deptName_duplicate").val());
	$("#roleName").val($("#roleName_duplicate").val());
	*/
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}

function toAddOrEdit() {
	window.location.href = web_ctx+"/manage/sys/user/toAddOrEdit";
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
	        "data": {"id": idForDel},
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

var idForReset = null;
function resetPassword(userId) {
	idForReset = userId;
	
	bootstrapConfirm("提示", "确认初始化密码？", 300, function() {
		$.ajax( {   
	        "type": "POST",    
	        "url": "resetPassword",    
	        "dataType": "json",   
	        "data": {"userId": idForReset},
	        "success": function(data) {   
	        	if(data != null) {
	        		bootstrapAlert("提示", data.result, 400, null);
	        	}
	        },
	        "error": function(data) {
	        	bootstrapAlert("提示", "网络错误，请稍后重试！", 400, null);
	        }
	    });
	}, null);
}