var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/seal/getSealList",
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
        {"mData": 'applicant'},     
        {"mData": 'sealType'},
        {"mData": 'createDate'},
        {"mData": 'applicant'},
        {"mData": 'status'},
        
    ]
	
	return columns;
}

function getSearchData() {
	var params = {};
	params.fuzzyContent = $.trim($("#fuzzyContent").val());

	return params;
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {
	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	var eq = 2;
	if(aData.applicant.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}
	else{
		$('td:eq(0)', nRow).html(aData.applicant.dept.name);
	}
	$('td:eq(1)', nRow).html(aData.applicant.name);
	
	if(aData.sealType == 0 || aData.sealType == 4 || aData.sealType == 8 
			|| aData.sealType == 12 || aData.sealType == 16 || aData.sealType == 20 || aData.sealType == 24){
		$('td:eq('+(eq)+')', nRow).html("公章");
	}
	else if(aData.sealType == 1 || aData.sealType == 5 || aData.sealType == 9
			|| aData.sealType == 13 || aData.sealType == 17 || aData.sealType == 21 || aData.sealType == 25){
		$('td:eq('+(eq)+')', nRow).html("合同章");
	}
	else if(aData.sealType == 2 || aData.sealType == 6 || aData.sealType == 10
			|| aData.sealType == 14 || aData.sealType == 18 || aData.sealType == 22 || aData.sealType == 26){
		$('td:eq('+(eq)+')', nRow).html("财务章");
	}
	else if(aData.sealType == 3 || aData.sealType == 7 || aData.sealType == 11
			|| aData.sealType == 15 || aData.sealType == 19 || aData.sealType == 23 || aData.sealType == 27){
		$('td:eq('+(eq)+')', nRow).html("法人章");
	}
	else{
		$('td:eq('+(eq)+')', nRow).html(" ");
	}
	
	$('td:eq('+(eq+1)+')', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd"));
	
	
	
	/*
	 * 审批状态
	 * 0： 重新申请 1：部门经理审批 2：总经理审批 3 财务审批 4：已归档 5：取消申请6：部门经理不同意 7：总经理不同意
	 * */
	if(aData.status == 0 || aData.status == 6 || aData.status == 7 || aData.status == 8) {
		$('td:eq('+(eq+2)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+2)+')', nRow).html('部门经理审批');
	} else if(aData.status == 2) {
		$('td:eq('+(eq+2)+')', nRow).html('总经理审批');
	} else if(aData.status == 3) {
		$('td:eq('+(eq+2)+')', nRow).html('用章');
	}else if(aData.status == 4) {
		$('td:eq('+(eq+2)+')', nRow).html('已归档');
	}
	else if(aData.status == 5) {
		$('td:eq('+(eq+2)+')', nRow).html('取消申请');
	}
	
	buildOperate(nRow, aData);
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/

function buildOperate(nRow, aData) {
	$(nRow).attr("onclick", "toProcess(\""+aData.processInstanceId+"\")");
	$(nRow).css("cursor", "pointer");
}

function toAdd() {
	window.location.href = "toAdd";
}


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}



function toProcess(processInstanceId) {
    if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/ad/seal/mobileprocess"
        }
	}else{
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/ad/seal/process"
        }
	}

	
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}