var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/salaryHistory/getSalaryHistory",
		"pageSize": 10000,
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
	
	$(document).keydown(function(event){
		if(event.which == 13){
			drawTable();
			return false; // 防止刷新整个页面
		}
	});

});

function initColumn() {
	var columns =  [
	    {"mData": 'sysUser'},
        {"mData": 'sysUser'},
        {"mData": 'salary'},
        {"mData": 'changeDate'}
    ]
	return columns;
}

function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	return params;
}

/* 服务端返回数据后开始渲染表格时调用*/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	var deptId = aData.sysUser.deptId;
	if(isNull(deptId) || aData.sysUser.dept.name.indexOf("总经理") > -1) {
		$('td:eq(0)', nRow).text("");
	} else {
		$('td:eq(0)', nRow).text(aData.sysUser.dept.name);
	}
	
	$('td:eq(1)', nRow).text(aData.sysUser.name);
	
	if( !isNull(aData.changeDate) ) {
		$('td:eq(3)', nRow).html(new Date(aData.changeDate).pattern("yyyy-MM-dd"));
	}else{
		$('td:eq(3)', nRow).html("");
	}
	
	buildOperate(aData, nRow);
    return nRow;
}


/* 构造操作详情HTML */
function buildOperate(aData,tr) {
	if(!isNull(aData.salary)){
		//如果有解密权限，则解密当前已加密的数据
		if( hasDecryptPermission ) {
			var now = new Date().pattern("yyyyMMdd");
			$.ajax({
				url: web_ctx+'/manage/getEncryptionKey?baseKey='+now+"&date"+new Date(),
				type: 'GET',
				success: function(data) {
					if(data.code == 1) {
						var tempKey = data.result;
						var encryptionKey = aesUtils.decryptECB(tempKey, now);
						$('td:eq(2)', tr).text(aesUtils.decryptECB(aData.salary, encryptionKey));
					} else {
						if(data.code == -1) {
							bootstrapAlert('提示', data.result, 400, null);
							return null;
						}
					}
				}
			});
		} 
	}
	
	$(tr).css("cursor", "pointer");
	$(tr).attr("onclick","location.href='"+web_ctx+"/manage/ad/salaryHistory/addOrEditSalaryHistory?userId="+aData.userId+"'");
}


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}