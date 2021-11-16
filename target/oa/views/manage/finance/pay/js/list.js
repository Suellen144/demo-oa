var dataTable = null;
$(function() {
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/pay/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});
    initDatetimepicker();
});

function initDatetimepicker() {
    $("#startTime, #endTime").datetimepicker({
        minView: "month",
        language:"zh-CN",
        format: "yyyy-mm-dd",
        pickDate: true,
        pickTime: false,
        autoclose: true,
    });
}

function initColumn() {
	var columns = [ //这个属性下的设置会应用到所有列
        {"mData": 'dept'}, 
        {"mData": 'sysUser'},
        {"mData": 'barginManage'},
        {"mData": 'projectManage'},
        {"mData": 'collectCompany'},
        {"mData": 'applyMoney'},
        {"mData": 'createDate'},
        {"mData": 'status'}
    ]

	return columns;
}

function getSearchData() {
	var params = {};
	var status = "";
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	params.status = $.trim($("#status").val());
	params.startTime = $.trim($("#startTime").val());
	params.endTime = $.trim($("#endTime").val());

    if(!isNull(params.startTime)) {
        params.startTime += " 0:0:0";
    }
    if(!isNull(params.endTime)) {
        params.endTime += " 23:59:59";
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
	
	if(aData.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}else{
		$('td:eq(0)', nRow).html(aData.dept.name);
	}
	$('td:eq(1)', nRow).html(aData.sysUser.name);
	if(aData.barginManage != null){
		$('td:eq(2)', nRow).html(aData.barginManage.barginCode);
	}else{
		$('td:eq(2)', nRow).html();
	}
	if(aData.projectManage != null){
		$('td:eq(3)', nRow).html(aData.projectManage.name);
	}else{
		$('td:eq(3)', nRow).html();
	}
	
	$('td:eq(5)', nRow).html(aData.applyMoney);
	$('td:eq(6)', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));
	if(aData.status == "1") {
		$('td:eq(7)', nRow).html('部门经理审批');
	}else if(aData.status == "11"){
		$('td:eq(7)', nRow).html('项目负责人审批');
	} else if(aData.status == "2") {
		$('td:eq(7)', nRow).html('财务审批');
	} else if(aData.status == "3") {
		$('td:eq(7)', nRow).html('总经理审批');
	} else if(aData.status == "4") {
		$('td:eq(7)', nRow).html('出纳审批');
	}else if(aData.status == "5") {
		$('td:eq(7)', nRow).html('已归档');
	} else if(aData.status == "6") {
		$('td:eq(7)', nRow).html('取消申请');
	} else if(aData.status == "7" || aData.status == "8" || aData.status == "9" || aData.status == "10" || aData.status == '12') {
		$('td:eq(7)', nRow).html('提交申请');
	} else if(aData.status == null || aData.status== "") {
		$('td:eq(7)', nRow).html('未提交');
	} 
	
	// 操作
	var htmlText = buildOperate(nRow,aData);
	$('td:eq(8)', nRow).html(htmlText);
	
    return nRow;
}

/**
 * 构造操作详情HTML 0： 重新申请 1：部门经理审批 2：财务审批 3：总经理审批 4：出纳审批 5：已归档 6：取消申请 7：部门经理不同意 8：财务不同意 9：总经理不同意 10：出纳不同意
 **/
function buildOperate(nRow,aData) {
	var html = [];
		if(aData.status != null){
			$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+")");
		}else{
			$(nRow).attr("onclick", "location.href='"+web_ctx+"/manage/finance/pay/toAddOrEdit?id="+aData.id+"'");
		}
	
	$(nRow).css("cursor", "pointer");
	return html.join("");
}


//添加回车响应事件
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey==13){
		drawTable();
		return false;
	}
});

function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

function clearForm() {
	$("#searchForm").clear();
}

function toProcess(processInstanceId,isNewProject){
	if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
		browser.versions.iPhone || browser.versions.iPad){
		var param = {
			"processInstanceId": processInstanceId,
			"page": "manage/finance/pay/mobileprocess"
		}
	}else {
		var param = {
			"processInstanceId": processInstanceId,
			"page": "manage/finance/pay/process"
		}
	}
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}


function toAddOrEdit(){
	window.location.href = web_ctx + "/manage/finance/pay/toAddOrEdit";
}

