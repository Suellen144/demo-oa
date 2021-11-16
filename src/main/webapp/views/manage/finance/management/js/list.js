var dataTable = null;
$(function() {
	initDatetimepicker();
	dataTable = $("#dataTable").datatable({
		"id": "dataTable",
		"url": web_ctx + "/manage/finance/management/getList",
		"columns": initColumn(),
		"search": getSearchData,
		"rowCallBack": rowCallBack,
	});

});


function initDatetimepicker() {
	$("#beginDate, #endDate").datetimepicker({
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
	    {"mData": 'kind'},  
        {"mData": 'name'},  //报销人
        {"mData": 'createDate'}, 
        {"mData": 'orderNo'},  //报销单号
        {"mData": 'status'},  //申请状态
        {"mData": 'cost'},  //申请状态
    ]

	return columns;
}

function getSearchData() {
	var params = {};
	var status = "";
	params.beginDate = $.trim($("#beginDate").val());
	params.endDate = $.trim($("#endDate").val());
	params.status = $.trim($("#status").val());
	params.fuzzyContent = $.trim($("#fuzzyContent").val());
	
	if(!isNull(params.beginDate)) {
		params.beginDate += " 0:0:0";
	}
	if(!isNull(params.endDate)) {
		params.endDate += " 23:59:59";
	}

	return params;
}

//添加回车响应事件
$(document).keydown(function(event){
	var curkey = event.which;
	if(curkey==13){
		drawTable();
		return false;
	}
});

function clearForm() {
	$("#searchForm").clear();
	$("#beginDate").prop("readonly", true);
	$("#endDate").prop("readonly", true);
}


function drawTable() {
	if(dataTable != null) {
		dataTable.draw();
	}
}

/**
 * 服务端返回数据后开始渲染表格时调用
 **/
function rowCallBack(nRow, aData, iDisplayIndex) {

	if(iDisplayIndex % 2 == 0) {
		nRow.bgColor = "#EDEDED";
	}
	
	var eq = 1;
	if(aData.kind == 1){
		$('td:eq(0)', nRow).html("差旅报销");
	}
	else{
		$('td:eq(0)', nRow).html("通用报销");
	}
	$('td:eq(1)', nRow).html(aData.name);
	
	$('td:eq('+(eq+1)+')', nRow).html(new Date(aData.createDate).pattern("yyyy-MM-dd HH:mm"));
	
	$('td:eq('+(eq+2)+')', nRow).html(aData.orderNo);
	
	$('td:eq('+(eq+3)+')', nRow).html(aData.cost);
	
	//审批状态 0：提交申请 1：部门经理审批 2：经办人审批 3：复核人审批 4：总经理审批 5：出纳审批 6：审批通过 7：取消申请 8：部门经理驳回 9：经办驳回 10：复核驳回 11：总经理驳回 12：出纳驳回
	if(aData.status == 0) {
		$('td:eq('+(eq+4)+')', nRow).html('提交申请');
	} else if(aData.status == 1) {
		$('td:eq('+(eq+4)+')', nRow).html('部门经理审批');
	} else if(aData.status == 13) {
		$('td:eq('+(eq+4)+')', nRow).html('总经理助理审批');
	} else if(aData.status == 2) {
		$('td:eq('+(eq+4)+')', nRow).html('经办审批');
	} else if(aData.status == 3 || aData.status == 11) {
		$('td:eq('+(eq+4)+')', nRow).html('复核审批');
	} else if(aData.status == 4) {
		$('td:eq('+(eq+4)+')', nRow).html('总经理审批');
	} else if(aData.status == 5) {
		$('td:eq('+(eq+4)+')', nRow).html('出纳审批');
	} else if(aData.status == 6) {
		$('td:eq('+(eq+4)+')', nRow).html('审批完结');
	} else if(aData.status == 7) {
		$('td:eq('+(eq+4)+')', nRow).html('取消申请');
	} else if(aData.status == 8 || aData.status == 9
			|| aData.status == 10 || aData.status == 12 || aData.status == 14) {
		$('td:eq('+(eq+4)+')', nRow).html('提交申请');
	}
	else{
		$('td:eq('+(eq+4)+')', nRow).html('申请待提交');
	}
	buildOperate(aData, nRow);
    return nRow;
}

/**
 * 构造操作详情HTML 
 **/
function buildOperate(aData,tr) {
/*	var html = [];
	if(aData.status == null){
		html.push("<a href='"+web_ctx+"/manage/finance/reimburs/toEdit?id="+aData.id+"'>修改申请</a>");
	}
	else{
		html.push("<a href='javascript:;' onclick='toProcess("+aData.processInstanceId+")'>查看流程</a>");
	}
	return html.join("");*/
	$(tr).css("cursor", "pointer");
	if(aData.status == null && aData.kind == 2){
			$(tr).attr("onclick","location.href='"+web_ctx+"/manage/finance/reimburs/toEdit?id="+aData.id+"'");
	}
	else if(aData.status == null && aData.kind == 1){
		$(tr).attr("onclick","location.href='"+web_ctx+"/manage/finance/travelReimburs/toEdit?id="+aData.id+"'");
	}
	else if(aData.status != null && aData.kind == 2){
			$(tr).attr("onclick","toReimbursProcess("+aData.processInstanceId+")");
	}
	else{
		$(tr).attr("onclick","toTravelReimbursProcess("+aData.processInstanceId+")");
	}
}

function toEdit(id) {
	window.location.href = "toEdit";
}

function toReimbursProcess(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/finance/reimburs/process"
	}
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}

function toTravelReimbursProcess(processInstanceId) {
	var param = {
		"processInstanceId": processInstanceId,
		"page": "manage/finance/travelReimburs/process",
		"entityClass": "com.reyzar.oa.domain.FinTravelReimburs",
		"tableName": "fin_travelreimburs"
	}
	
	window.location.href = web_ctx + "/activiti/process?" + urlEncode(param);
}