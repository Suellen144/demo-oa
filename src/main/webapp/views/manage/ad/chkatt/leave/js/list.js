var dataTable = null;

$(function() {
	initDatetimepicker();
	
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/leave/getLeaveList",
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
	var columns =  [ //这个属性下的设置会应用到所有列
        {"mData": 'applicant'},             
        {"mData": 'startTime'}, //mData 表示发请求时候本列的列明，返回的数据中相同下标名字的数据会填充到这一列
        {"mData": 'endTime'},
        {"mData": 'leaveType'},
        {"mData": 'days'},
        {"mData": 'applicant'},
        {"mData": 'status'}
    ]
	
	return columns;
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
	
	var eq = 1;
	if(aData.applicant.dept.name == "总经理"){
		$('td:eq(0)', nRow).html("");
	}
	else{
		$('td:eq(0)', nRow).html(aData.applicant.dept.name);
	}
	$('td:eq('+(eq)+')', nRow).html(aData.applicant.name);
	
	$('td:eq('+(eq+1)+')', nRow).html(new Date(aData.startTime).pattern("yyyy-MM-dd HH:mm"));
	$('td:eq('+(eq+2)+')', nRow).html(new Date(aData.endTime).pattern("yyyy-MM-dd HH:mm"));
	
	if(aData.leaveType == 0) {
		$('td:eq('+(eq+3)+')', nRow).html('事假');
	} else if(aData.leaveType == 1) {
		$('td:eq('+(eq+3)+')', nRow).html('年假');
	} else if(aData.leaveType == 2) {
		$('td:eq('+(eq+3)+')', nRow).html('调休');
	} else if(aData.leaveType == 3) {
		$('td:eq('+(eq+3)+')', nRow).html('病假');
	} else if(aData.leaveType == 4) {
		$('td:eq('+(eq+3)+')', nRow).html('婚假');
	} else if(aData.leaveType == 5) {
		$('td:eq('+(eq+3)+')', nRow).html('产假');
	} else if(aData.leaveType == 6) {
		$('td:eq('+(eq+3)+')', nRow).html('陪产假');
	} else if(aData.leaveType == 7) {
		$('td:eq('+(eq+3)+')', nRow).html('其他');
	}
	
	var daysText = [];
	if(!isNull(aData.days)) {
		daysText.push(aData.days);
		daysText.push("天");
	}
	if(!isNull(aData.hours)) {
		daysText.push(aData.hours);
		daysText.push("小时");
	}
	$('td:eq('+(eq+4)+')', nRow).html(daysText.join(""));
	
	/*
	 * 审批状态
	 * 0： 重新申请 1：部门经理审批 2：HR审批 3：总经理审批 4：销假 5：已归档 6：取消申请 7：部门经理不同意 8：HR不同意 9：总经理不同意
	 * */
	if(aData.status == 0 || aData.status == 7 || aData.status == 8 || aData.status == 9 || aData.status == 12 ) {
		$('td:eq('+(eq+5)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+5)+')', nRow).html('部门经理审批');
	} else if(aData.status == 2) {
		$('td:eq('+(eq+5)+')', nRow).html('HR审批');
	} else if(aData.status == 3) {
		$('td:eq('+(eq+5)+')', nRow).html('总经理审批');
	} else if(aData.status == 4) {
		$('td:eq('+(eq+5)+')', nRow).html('销假');
	} else if(aData.status == 5) {
		$('td:eq('+(eq+5)+')', nRow).html('已归档');
	} else if(aData.status == 6) {
		$('td:eq('+(eq+5)+')', nRow).html('取消申请');
	}else if(aData.status == 10) {
		$('td:eq('+(eq+5)+')', nRow).html('HR确认');
	}else if(aData.status == 11) {
		$('td:eq('+(eq+5)+')', nRow).html('项目经理审批');
	}
	
	buildOperate(nRow, aData);
	
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(nRow, aData) {
	$(nRow).attr("onclick", "toProcess("+aData.processInstanceId+")");
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
	$("#beginDate").prop("readonly", true);
	$("#endDate").prop("readonly", true);
}

function toProcess(processInstanceId) {
	if(browser.versions.mobile || browser.versions.ios || browser.versions.android ||
        browser.versions.iPhone || browser.versions.iPad){
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/ad/chkatt/leave/mobileprocess"
        }
	}else {
        var param = {
            "processInstanceId": processInstanceId,
            "page": "manage/ad/chkatt/leave/process"
        }
	}

	
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}