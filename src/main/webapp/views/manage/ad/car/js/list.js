var dataTable = null;

$(function() {
	initDatetimepicker();
	
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/ad/car/getList",
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
	
	var daysText = [];
	/*
	 * 审批状态
	 * 0： 重新申请 1：部门经理审批 2：行政主管审批 3：司机确认  4：已归档    5：取消申请  6：部门经理不同意 7：行政主管不同意 
	 * */
	if(aData.status == 0 || aData.status == 6 || aData.status == 7 ) {
		$('td:eq('+(eq+3)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+3)+')', nRow).html('部门经理审批');
	} else if(aData.status == 2) {
		$('td:eq('+(eq+3)+')', nRow).html('行政主管审批');
	} else if(aData.status == 3) {
		$('td:eq('+(eq+3)+')', nRow).html('司机确认');
	} else if(aData.status == 4) {
		$('td:eq('+(eq+3)+')', nRow).html('已归档');
	} else if(aData.status == 5) {
		$('td:eq('+(eq+3)+')', nRow).html('取消申请');
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
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/ad/car/process"
	}
	
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}