var dataTable = null;
$(function() {
	initDatetimepicker();
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/overtime/getOvertimeList",
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
        {"mData": 'createDate'},
        {"mData": 'startTime'}, 
        {"mData": 'endTime'},
        {"mData": 'days'},
        {"mData": 'applicant'},
        {"mData": 'status'},
    ]
	
	return columns;
}

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

function getSearchData() {
	var params = {};
	params.startTime = $.trim($("#startTime").val());
	params.endTime = $.trim($("#endTime").val());
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	
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
	
	var eq = 2;
	if(aData.applicant.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}
	else{
		$('td:eq(0)', nRow).html(aData.applicant.dept.name);
	}
	$('td:eq(1)', nRow).html(aData.applicant.name);
	
	$('td:eq('+(eq)+')', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd"));
	$('td:eq('+(eq+1)+')', nRow).html(new Date(aData.startTime).pattern("yyyy-MM-dd HH:mm"));
	$('td:eq('+(eq+2)+')', nRow).html(new Date(aData.endTime).pattern("yyyy-MM-dd HH:mm"));
	
	
	var daysText = [];
	if(!isNull(aData.days)) {
		daysText.push(aData.days);
		daysText.push("天");
	}
	if(!isNull(aData.hours)) {
		daysText.push(aData.hours);
		daysText.push("小时");
	}
	$('td:eq('+(eq+3)+')', nRow).html(daysText.join(""));
	
	
	/*
	 * 审批状态
	 * 0： 重新申请 1：部门经理审批 2：HR审批 3：已归档 4：取消申请 5：部门经理不同意 6：HR不同意  7:总经理审批  8:总经理不同意 9:总监环节（总经理审批） 10：总监环节（总经理不同意）11 :项目经理审批，12：项目经理不同意
	 * */
	if(aData.status == 0 || aData.status == 5 || aData.status == 6  || aData.status == 8|| aData.status == 10 || aData.status == 12) {
		$('td:eq('+(eq+4)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+4)+')', nRow).html('部门经理审批');
	} else if(aData.status == 2) {
		$('td:eq('+(eq+4)+')', nRow).html('HR审批');
	} else if(aData.status == 3) {
		$('td:eq('+(eq+4)+')', nRow).html('已归档');
	} else if(aData.status == 4) {
		$('td:eq('+(eq+4)+')', nRow).html('取消申请');
	}else if(aData.status == 7) {
			$('td:eq('+(eq+4)+')', nRow).html('总经理审批');
	}else if(aData.status == 9) {
		$('td:eq('+(eq+4)+')', nRow).html('总经理审批');
	}else if(aData.status == 11){
		$('td:eq('+(eq+4)+')', nRow).html('项目经理审批');
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


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}


function clearForm() {
	$("#searchForm").clear();
	$("#beginDate").prop("readonly", true);
	$("#endDate").prop("readonly", true);
}

function toAdd() {
	window.location.href = "toAdd";
}

function toProcess(processInstanceId) {
    if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/ad/chkatt/overtime/mobileprocess"
        }
	}else {
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/ad/chkatt/overtime/process"
        }
	}

	
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}